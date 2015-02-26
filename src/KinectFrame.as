package 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class KinectFrame extends EventDispatcher
	{
		public static const START_LOAD_FRAME:String = "startLoadFrame";
		public static const LOAD_FRAME_COMPLETE:String = "loadFrameComplete";
		
		private var _colorImageFlag:Boolean = false;
		private var _bodyIndexImageFlag:Boolean = false;
		private var _bodyDataFlag:Boolean = false;
		private var _isRunning:Boolean = false;
		private var _colorImageReceived:Boolean = false;
		private var _bodyIndexImageReceived:Boolean = false;
		private var _bodyDataReceived:Boolean = false;
		private var _colorImage:ByteArray;
		private var _bodyIndexImage:ByteArray;
		private var _bodyData:ByteArray;
		
		public function KinectFrame() 
		{
			
		}
		
		public function start():void {
			_isRunning = true;
			startNewFrame();
		}
		
		public function stop():void {
			_isRunning = false;
		}
		
		public function get colorImageFlag():Boolean 
		{
			return _colorImageFlag;
		}
		
		public function set colorImageFlag(value:Boolean):void 
		{
			_colorImageFlag = value;
		}
		
		public function get bodyIndexImageFlag():Boolean 
		{
			return _bodyIndexImageFlag;
		}
		
		public function set bodyIndexImageFlag(value:Boolean):void 
		{
			_bodyIndexImageFlag = value;
		}
		
		public function get bodyDataFlag():Boolean 
		{
			return _bodyDataFlag;
		}
		
		public function set bodyDataFlag(value:Boolean):void 
		{
			_bodyDataFlag = value;
		}
		
		public function get colorImageReceived():Boolean 
		{
			return _colorImageReceived;
		}
		
		public function set colorImageReceived(value:Boolean):void 
		{
			_colorImageReceived = value;
			checkFrameDataReceivedComplete();
		}
		
		public function get bodyIndexImageReceived():Boolean 
		{
			return _bodyIndexImageReceived;
		}
		
		public function set bodyIndexImageReceived(value:Boolean):void 
		{
			_bodyIndexImageReceived = value;
			checkFrameDataReceivedComplete();
		}
		
		public function get bodyDataReceived():Boolean 
		{
			return _bodyDataReceived;
		}
		
		public function set bodyDataReceived(value:Boolean):void 
		{
			_bodyDataReceived = value;
			checkFrameDataReceivedComplete();
		}
		
		public function get colorImage():ByteArray 
		{
			return _colorImage;
		}
		
		public function set colorImage(value:ByteArray):void 
		{
			_colorImage = value;
		}
		
		public function get bodyIndexImage():ByteArray 
		{
			return _bodyIndexImage;
		}
		
		public function set bodyIndexImage(value:ByteArray):void 
		{
			_bodyIndexImage = value;
		}
		
		public function get bodyData():ByteArray 
		{
			return _bodyData;
		}
		
		public function set bodyData(value:ByteArray):void 
		{
			_bodyData = value;
		}
		
		private function checkFrameDataReceivedComplete():void {
			if ((!_colorImageFlag || _colorImageReceived) && (!_bodyIndexImageFlag || _bodyIndexImageReceived) && (!_bodyDataFlag || _bodyDataReceived)) {
				dispatchEvent(new Event(LOAD_FRAME_COMPLETE));
				startNewFrame();
			}
		}
		
		private function startNewFrame():void {
			if (_isRunning) {
				colorImageReceived = false;
				bodyIndexImageReceived = false;
				bodyDataReceived = false;
				
				dispatchEvent(new Event(START_LOAD_FRAME));
			}
		}
	}

}