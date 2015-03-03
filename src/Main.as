package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Main extends Sprite
	{
		private var kinectSocket:KinectSocket;
		private var colorFeed:LiveVideoFeed;
		private var bodyFeed:LiveVideoFeed;
		private var kinectViewer:KinectViewer;
		
		public function Main()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			kinectViewer = new KinectViewer(1920, 1080);
			addChild(kinectViewer);
			
			kinectSocket = new KinectSocket("localhost", 7001);
			kinectSocket.kinectFrame.addEventListener(KinectFrame.LOAD_FRAME_COMPLETE, onLoadFrameComplete);
			
			/*colorFeed = new LiveVideoFeed();
			addChild(colorFeed);*/
		}
		
		private function onLoadFrameComplete(e:Event):void
		{
			if (kinectSocket.kinectFrame.colorImageFlag)
				colorFeed.bytes = kinectSocket.kinectFrame.colorImage;
			
			if (kinectSocket.kinectFrame.bodyIndexImageFlag)
				bodyFeed.bytes = kinectSocket.kinectFrame.bodyIndexImage;
			
			if (kinectSocket.kinectFrame.bodyDataFlag)
			{
				kinectSocket.kinectFrame.bodyData.position = 0;
				kinectViewer.data = kinectSocket.kinectFrame.bodyData.readUTFBytes(kinectSocket.kinectFrame.bodyData.bytesAvailable);
				
				//kinectSocket.kinectFrame.bodyData.position = 0;
				trace("------------received!");
			}
		}
	}

}