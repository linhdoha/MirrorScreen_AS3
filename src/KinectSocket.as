package 
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
		public static const GET_DATA_COMPLETE:String = "getDataComplete";
		public static const IS_READY:String = "isReady";
		public static const GET_COLOR_COMMAND:String = "+CLR";
		public static const GET_BODY_COMMAND:String = "+BDY";
		public static const GET_BODY_DATA_COMMAND:String = "+BDD";
		
		private	var _data:ByteArray = new ByteArray();
		private	var dataLength:ByteArray = new ByteArray();
		private	var dataPosition:int = new int();		
		private var dataLengthFlag:Boolean = new Boolean();
		private var dataLengthCounter:int = new int();
		private var dataPreviousPosition:int = new int();
		private var isReading:Boolean = false;
		private var _currentReadingCommand:String;
		
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
			dispatchEvent(new Event(IS_READY));
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}

		private function socketDataHandler(event:ProgressEvent):void {
			trace("socketDataHandler: " + event);
			
			var dataTemp:ByteArray = new ByteArray();
			readBytes(dataTemp, 0, bytesAvailable);
			
			//read 4 begin bytes
			var headerSign:String = dataTemp.readUTFBytes(4);
				switch(headerSign) {
					case GET_COLOR_COMMAND:
					case GET_BODY_COMMAND:
					case GET_BODY_DATA_COMMAND:
						trace("headerSign: "+headerSign);
						isReading = true;
						_currentReadingCommand = headerSign;
						_data = new ByteArray();
						break;
					default:
						if (!isReading) {
							trace("Malfuntion command!");
							return;
						}
						break;
				}
			
			_data.writeBytes(dataTemp, 0, dataTemp.length);
			
			//check 4 end bytes
			var f4:ByteArray = new ByteArray();
			f4.writeBytes(_data, _data.length - 4, 4);
			if ((f4[0] == 0) && (f4[1] == 0) && (f4[2] == 0) && (f4[3] == 0)) {
				trace("0000");
				_data.position = 0;
				_data.writeBytes(_data, 4, _data.length - 4);
				_data.length = _data.length - 4;
				trace(_data.length);
				isReading = false;
				
				dispatchEvent(new Event(GET_DATA_COMPLETE));
			} else {
				return;
			}
		}
		
		private function initReveiveBytes():void {
			_data = new ByteArray();
			dataLength =  new ByteArray();
			dataLengthFlag = false;
			dataPosition = new int();					
			dataLengthCounter = new int();
			dataPreviousPosition = new int();	
		}
		
		private function swap32(val:int):int {
			return ((val & 0xFF) << 24) | ((val & 0xFF00) << 8) | ((val >> 8) & 0xFF00) | ((val >> 24) & 0xFF);
		}
		
		public function callGetColorCommand():void 
		{
			if (connected) {
				initReveiveBytes();
				writeUTFBytes("GETCOLOR\0");
				flush();
			} else {
				trace("Socket's not connected.");
			}
		}
		
		public function callGetBodyCommand():void {
			if (connected) {
				initReveiveBytes();
				writeUTFBytes("GETBODY\0");
				flush();
			} else {
				trace("Socket's not connected.");
			}
		}
		
		public function callGetBodyDataCommand():void {
			if (connected) {
				initReveiveBytes();
				writeUTFBytes("GETBODYDATA\0");
				flush();
			} else {
				trace("Socket's not connected.");
			}
		}
		
		public function get data():ByteArray 
		{
			return _data;
		}
		
		public function get currentReadingCommand():String 
		{
			return _currentReadingCommand;
		}
	}

}