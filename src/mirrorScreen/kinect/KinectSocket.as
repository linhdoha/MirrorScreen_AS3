package mirrorScreen.kinect 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class KinectSocket extends Socket 
	{
		public static const BODY_DATA_SIGN:String = "+BDD";
		public static const BODY_DATA_EVENT:String = "bodyDataEvent";
		
		private	var _data:ByteArray = new ByteArray();
		private var isReading:Boolean = false;
		private var _currentReadingData:String;
		
		public function KinectSocket(host:String=null, port:int=0) 
		{
			super(host, port);
			configureListeners();
			if (host && port)  {
				super.connect(host, port);
			}
		}
		
		private function configureListeners():void {
			addEventListener(Event.CLOSE, closeHandler);
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		private function closeHandler(event:Event):void {
			trace("closeHandler: " + event);
		}

		private function connectHandler(event:Event):void {
			trace("connectHandler: " + event);
			callRequestDataCommand();
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}

		private function socketDataHandler(event:ProgressEvent):void {
			//trace("socketDataHandler: " + event);
			
			var dataTemp:ByteArray = new ByteArray();
			readBytes(dataTemp, 0, bytesAvailable);
			
			//read 4 begin bytes
			var headerSign:String = dataTemp.readUTFBytes(4);
			switch(headerSign) {
				case BODY_DATA_SIGN:
					isReading = true;
					_currentReadingData = headerSign;
					_data = new ByteArray();
					break;
				default:
					if (!isReading) {
						trace("Malfuntion data!");
						return;
					}
					break;
			}
			
			_data.writeBytes(dataTemp, 0, dataTemp.length);
			
			//check 4 end bytes
			var f4:ByteArray = new ByteArray();
			f4.writeBytes(_data, _data.length - 4, 4);
			if ((f4[0] == 0) && (f4[1] == 0) && (f4[2] == 0) && (f4[3] == 0)) {
				_data.position = 0;
				_data.writeBytes(_data, 4, _data.length - 4);
				_data.length = _data.length - 4;
				
				isReading = false;
				
				dispatchEvent(new Event(BODY_DATA_EVENT));
				callRequestDataCommand();
			} else {
				return;
			}
		}
		
		private function callRequestDataCommand():void {
			if (connected) {
				var object:Object = {
					"command":"requestData",
					"dataReceive":{
						"colorImage":false,
						"bodyIndexImage":false,
						"bodyData":true
					}
				};
				
				writeUTFBytes(JSON.stringify(object));
				flush();
			}
		}
		
		public function get data():ByteArray 
		{
			return _data;
		}
	}

}