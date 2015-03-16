
package mirrorScreen
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import mirrorScreen.data.Configuration;
	import mirrorScreen.displayComponents.SkeletonDisplayer;
	import mirrorScreen.displayComponents.SnapShooter;
	import mirrorScreen.kinect.KinectConsole;
	import mirrorScreen.kinect.KinectSocket;
	import mirrorScreen.kinect.KinectViewer;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Main extends Sprite
	{
		private var kinectSocket:KinectSocket;
		private var kinectViewer:KinectViewer;
		private var colorCamera:Camera;
		private var bodyIndexCamera:Camera;
		private var configuration:Configuration;
		private var snapShooter:SnapShooter;
		private var kinectConsole:KinectConsole;
		
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
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			stage.align = StageAlign.TOP_LEFT;
			
			
			
			kinectViewer = new KinectViewer();
			kinectViewer.addEventListener(SkeletonDisplayer.SNAP_COMMAND_EVENT, onSnapCommandEvent);
			kinectViewer.mouseChildren = false;
			kinectViewer.doubleClickEnabled = true;
			kinectViewer.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			addChild(kinectViewer);
			
			configuration = new Configuration();
			
			colorCamera = Camera.getCamera(configuration.kinectCameraID);
			if (colorCamera != null) {
				colorCamera.setMode(configuration.kinectCameraWidth, configuration.kinectCameraHeight, 30);
				kinectViewer.attachColorImageSource(colorCamera);
				kinectViewer.mirror = configuration.kinectCameraMirror;
			}
			
			bodyIndexCamera = Camera.getCamera(configuration.kinectBodyIndexCameraID);
			if (bodyIndexCamera != null) {
				bodyIndexCamera.setMode(configuration.kinectBodyIndexCameraWidth, configuration.kinectBodyIndexCameraHeight, 30);
				kinectViewer.attachBodyIndexImageSource(bodyIndexCamera);
			}
			
			kinectSocket = new KinectSocket(configuration.kinectServerHost, configuration.kinectServerPort);
			kinectSocket.addEventListener(KinectSocket.BODY_DATA_EVENT, onBodyDataEvent);
			
			kinectConsole = new KinectConsole();
			kinectConsole.addEventListener(KinectConsole.PROCESS_EXIT, onConsoleExit);
			stage.nativeWindow.addEventListener(Event.CLOSING, onAppClosing);
			
			snapShooter = new SnapShooter();
			snapShooter.target = kinectViewer;
			snapShooter.imageFileType = configuration.imageFileType;
			snapShooter.imageFileQuality = configuration.imageFileQuality;
			snapShooter.prenameOfImage = configuration.prenameOfImage;
			snapShooter.storageDir = configuration.storageDir;
			addChild(snapShooter);
		}
		
		private function onConsoleExit(e:Event):void 
		{
			trace("Console exit");
			NativeApplication.nativeApplication.exit();
		}
		
		private function onAppClosing(e:Event):void 
		{
			e.preventDefault();
			if (kinectConsole.running) {
				kinectConsole.exit();
			}
		}
		
		private function onDoubleClick(e:MouseEvent):void 
		{
			trace("double click");
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			} else {
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		private function onSnapCommandEvent(e:Event):void 
		{
			snapShooter.startCount();
		}
		
		private function onBodyDataEvent(e:Event):void {
			kinectSocket.data.position = 0;
			kinectViewer.bodyData = kinectSocket.data.readUTFBytes(kinectSocket.data.bytesAvailable);
		}
	}

}