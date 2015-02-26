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
			kinectSocket.kinectFrame.addEventListener(KinectFrame.LOAD_FRAME_COMPLETE, onLoadFrameComplete);
			
			colorFeed = new LiveVideoFeed();
			addChild(colorFeed);
			
			bodyFeed = new LiveVideoFeed();
			addChild(bodyFeed);
			bodyFeed.x = 300;
			bodyFeed.y = 100;
		}
		
		private function onLoadFrameComplete(e:Event):void 
		{
			if (kinectSocket.kinectFrame.colorImageFlag) colorFeed.bytes = kinectSocket.kinectFrame.colorImage;
			
			if (kinectSocket.kinectFrame.bodyIndexImageFlag) bodyFeed.bytes = kinectSocket.kinectFrame.bodyIndexImage;
			
			if (kinectSocket.kinectFrame.bodyDataFlag) {
				kinectSocket.kinectFrame.bodyData.position = 0;
				trace(kinectSocket.kinectFrame.bodyData.readUTFBytes(kinectSocket.kinectFrame.bodyData.bytesAvailable));
			}
		}
	}
	
}