package com.nidlab.kinect
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
		
		private var _byteData:ByteArray = new ByteArray();
		private var isReading:Boolean = false;
		private var _currentReadingData:String;
		private var _gestureDatabaseFiles:Array = new Array();
		
		public function KinectSocket(port:int = 7001)
		{
			super("localhost", port);
			configureListeners();
			if (port)
			{
				super.connect("localhost", port);
			}
		}
		
		private function configureListeners():void
		{
			addEventListener(Event.CLOSE, closeHandler);
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		private function closeHandler(event:Event):void
		{
			trace("closeHandler: " + event);
		}
		
		private function connectHandler(event:Event):void
		{
			trace("connectHandler: " + event);
			callRequestDataCommand();
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			trace("ioErrorHandler: " + event);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			trace("securityErrorHandler: " + event);
		}
		
		private function socketDataHandler(event:ProgressEvent):void
		{
			//trace("socketDataHandler: " + event);
			
			var dataTemp:ByteArray = new ByteArray();
			readBytes(dataTemp, 0, bytesAvailable);
			
			//read 4 begin bytes
			var headerSign:String = dataTemp.readUTFBytes(4);
			switch (headerSign)
			{
				case BODY_DATA_SIGN: 
					isReading = true;
					_currentReadingData = headerSign;
					_byteData = new ByteArray();
					break;
				default: 
					if (!isReading)
					{
						trace("Malfuntion data!");
						return;
					}
					break;
			}
			
			_byteData.writeBytes(dataTemp, 0, dataTemp.length);
			
			//check 4 end bytes
			var f4:ByteArray = new ByteArray();
			f4.writeBytes(_byteData, _byteData.length - 4, 4);
			if ((f4[0] == 0) && (f4[1] == 0) && (f4[2] == 0) && (f4[3] == 0))
			{
				_byteData.position = 0;
				_byteData.writeBytes(_byteData, 4, _byteData.length - 4);
				_byteData.length = _byteData.length - 4;
				
				isReading = false;
				
				dispatchEvent(new Event(BODY_DATA_EVENT));
				callRequestDataCommand();
			}
			else
			{
				return;
			}
		}
		
		private function callRequestDataCommand():void
		{
			if (connected)
			{
				var object:Object = {"command": "requestData", "dataReceive": {"colorImage": false, "bodyIndexImage": false, "bodyData": true}, "gestureDatabase": []};
				
				for (var i:int = 0; i < _gestureDatabaseFiles.length; i++)
				{
					var gestureDBArray:Array = object.gestureDatabase as Array;
					gestureDBArray.push(_gestureDatabaseFiles[i]);
				}
				
				writeUTFBytes(JSON.stringify(object));
				flush();
			}
		}
		
		public function get data():String
		{
			_byteData.position = 0;
			return _byteData.readUTFBytes(_byteData.bytesAvailable);
		}
		
		public function get gestureDatabaseFiles():Array
		{
			return _gestureDatabaseFiles;
		}
		
		public function set gestureDatabaseFiles(value:Array):void
		{
			_gestureDatabaseFiles = value;
		}
	}

}