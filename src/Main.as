package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.net.URLLoader;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Main extends Sprite {	
		private var debugTxt:TextField;
		private var kinectSocket:KinectSocket;
		private var colorFeed:LiveVideoFeed;
		private var bodyFeed:LiveVideoFeed;
		
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			kinectSocket = new KinectSocket("localhost", 7001);
			kinectSocket.addEventListener(KinectSocket.IS_READY, onKinectSocketReady);
			kinectSocket.addEventListener(KinectSocket.GET_DATA_COMPLETE, onKinectSocketGetDataComplete);
			
			colorFeed = new LiveVideoFeed();
			colorFeed.addEventListener(LiveVideoFeed.BYTES_LOAD_COMPLETED, onColorFeedLoadComplete);
			addChild(colorFeed);
			
			bodyFeed = new LiveVideoFeed();
			bodyFeed.addEventListener(LiveVideoFeed.BYTES_LOAD_COMPLETED, onBodyFeedLoadComplete);
			
			debugTxt = new TextField();
			//addChild(debugTxt);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			kinectSocket.callGetBodyDataCommand();
		}
		
		private function onKinectSocketGetDataComplete(e:Event):void 
		{
			switch(kinectSocket.currentReadingCommand) {
				case KinectSocket.GET_COLOR_COMMAND:
					colorFeed.bytes = kinectSocket.data;
					break;
				case KinectSocket.GET_BODY_COMMAND:
					bodyFeed.bytes = kinectSocket.data;
					break;
				case KinectSocket.GET_BODY_DATA_COMMAND:					
					trace(kinectSocket.data.readUTF());
					break;
			}
		}
		
		private function onKinectSocketReady(e:Event):void 
		{
			kinectSocket.callGetColorCommand();
		}
		
		private function onBodyFeedLoadComplete(e:Event):void 
		{
			kinectSocket.callGetBodyCommand();
		}
		
		private function onColorFeedLoadComplete(e:Event):void 
		{
			kinectSocket.callGetColorCommand();
		}
	}
	
}