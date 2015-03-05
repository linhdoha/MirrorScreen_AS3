package mirrorScreen 
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
		public static const COLOR_IMAGE_SIGN:String = "+CLR";
		public static const BODY_INDEX_IMAGE_SIGN:String = "+BDY";
		public static const BODY_DATA_SIGN:String = "+BDD";
		
		private	var _data:ByteArray = new ByteArray();
		private var isReading:Boolean = false;
		private var _currentReadingData:String;
		private var _kinectFrame:KinectFrame;
		
		
		public function KinectSocket(host:String=null, port:int=0) 
		{
			super(host, port);
			configureListeners();
			if (host && port)  {
				super.connect(host, port);
			}
			
			_kinectFrame = new KinectFrame();
			_kinectFrame.addEventListener(KinectFrame.START_LOAD_FRAME, onStartLoadFrame);
		}
		
		private function onStartLoadFrame(e:Event):void 
		{
			callRequestDataCommand();
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
			//trace("connectHandler: " + event);
			_kinectFrame.colorImageFlag = false;
			_kinectFrame.bodyIndexImageFlag = false;
			_kinectFrame.bodyDataFlag = true;
			_kinectFrame.start();
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
				case COLOR_IMAGE_SIGN:
				case BODY_INDEX_IMAGE_SIGN:
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
				
				switch (_currentReadingData) {
					case COLOR_IMAGE_SIGN:
						_kinectFrame.colorImageReceived = true;
						_kinectFrame.colorImage = _data;
						break;
					case BODY_INDEX_IMAGE_SIGN:
						_kinectFrame.bodyIndexImageReceived = true;
						_kinectFrame.bodyIndexImage = _data;
						break;
					case BODY_DATA_SIGN:
						_kinectFrame.bodyDataReceived = true;
						_kinectFrame.bodyData = _data;
						break;
				}
			} else {
				return;
			}
		}
		
		private function callRequestDataCommand():void {
			if (connected) {
				if (_kinectFrame.colorImageFlag || _kinectFrame.bodyIndexImageFlag || _kinectFrame.bodyDataFlag) {
					var object:Object = {
						"command":"requestData",
						"dataReceive":{
							"colorImage":_kinectFrame.colorImageFlag,
							"bodyIndexImage":_kinectFrame.bodyIndexImageFlag,
							"bodyData":_kinectFrame.bodyDataFlag
						}
					};
					
					writeUTFBytes(JSON.stringify(object));
					flush();
					//trace("callRequestDataCommand: "+ JSON.stringify(object));
				}
				
				
			}
		}
		
		public function get currentReadingData():String 
		{
			return _currentReadingData;
		}
		
		public function get kinectFrame():KinectFrame 
		{
			return _kinectFrame;
		}
	}

}