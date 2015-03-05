
package mirrorScreen
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.media.Camera;
	import mirrorScreen.displayComponents.CountDown;
	import mirrorScreen.displayComponents.SkeletonDisplayer;
	import mirrorScreen.KinectSocket;
	import mirrorScreen.displayComponents.LiveVideoFeed;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Main extends Sprite
	{
		private var kinectSocket:KinectSocket;
		private var bodyFeed:LiveVideoFeed;
		private var kinectViewer:KinectViewer;
		private var camera:Camera;
		private var countDown:CountDown;
		
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
			
			kinectViewer = new KinectViewer();
			kinectViewer.addEventListener(SkeletonDisplayer.SNAP_COMMAND_EVENT, onSnapCommandEvent);
			addChild(kinectViewer);
			
			camera = Camera.getCamera("1");
			if (camera != null) {
				camera.setMode(1920, 1080, 30);
				kinectViewer.attachColorImageSource(camera);
				kinectViewer.mirror = true;
			} else {
				kinectViewer.attachColorImageSource(kinectSocket);
			}
			
			kinectSocket = new KinectSocket("localhost", 7001);
			kinectSocket.kinectFrame.addEventListener(KinectFrame.LOAD_FRAME_COMPLETE, onLoadFrameComplete);
			
			countDown = new CountDown();
			countDown.x = stage.stageWidth / 2;
			countDown.y = stage.stageHeight / 2;
			addChild(countDown);
		}
		
		private function onSnapCommandEvent(e:Event):void 
		{
			countDown.start();
		}
		
		private function onLoadFrameComplete(e:Event):void
		{
			//if (kinectSocket.kinectFrame.colorImageFlag)
			//	colorFeed.bytes = kinectSocket.kinectFrame.colorImage;
			
			//if (kinectSocket.kinectFrame.bodyIndexImageFlag)
			//	bodyFeed.bytes = kinectSocket.kinectFrame.bodyIndexImage;
			
			if (kinectSocket.kinectFrame.bodyDataFlag)
			{
				kinectSocket.kinectFrame.bodyData.position = 0;
				kinectViewer.bodyData = kinectSocket.kinectFrame.bodyData.readUTFBytes(kinectSocket.kinectFrame.bodyData.bytesAvailable);
			}
		}
	}

}