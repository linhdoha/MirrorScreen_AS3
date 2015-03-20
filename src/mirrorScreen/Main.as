
package mirrorScreen
{
	import com.nidlab.kinect.KinectConsole;
	import com.nidlab.kinect.KinectSocket;
	import com.nidlab.kinect.KinectV2Description;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mirrorScreen.Configuration;
	import mirrorScreen.displayComponents.ScreenViewer;
	import mirrorScreen.displayComponents.SnapShooter;
	import mirrorScreen.themes.fireMirror.Mirror;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Main extends Sprite
	{
		private var kinectSocket:KinectSocket;
		private var screenViewer:ScreenViewer;
		private var appConfig:Configuration;
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
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			stage.addEventListener(Event.RESIZE, onStageResize);
			//stage.addEventListener(FullScreenEvent.FULL_SCREEN, onStageResize);
			stage.nativeWindow.addEventListener(Event.CLOSING, onAppClosing);
			
			appConfig = Configuration.getInstance();
			
			screenViewer = new ScreenViewer();
			screenViewer.addEventListener(Mirror.SNAP_COMMAND_EVENT, onSnapCommandEvent);
			screenViewer.mouseChildren = false;
			screenViewer.doubleClickEnabled = true;
			screenViewer.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			addChild(screenViewer);
			
			screenViewer.theme = ScreenViewer.FIRE_THEME;
			
			kinectSocket = new KinectSocket(appConfig.kinectPort);
			kinectSocket.addEventListener(KinectSocket.BODY_DATA_EVENT, onBodyDataEvent);
			kinectSocket.addEventListener(Event.CLOSE, onSocketClose);
			
			kinectConsole = new KinectConsole(appConfig.kinectPort);
			kinectConsole.addEventListener(KinectConsole.PROCESS_EXIT, onConsoleExit);
			
			snapShooter = new SnapShooter();
			snapShooter.target = screenViewer;
			snapShooter.imageFileType = appConfig.imageFileType;
			snapShooter.imageFileQuality = appConfig.imageFileQuality;
			snapShooter.prenameOfImage = appConfig.prenameOfImage;
			snapShooter.storageDir = appConfig.storageDir;
			addChild(snapShooter);
		}
		
		private function onStageResize(e:Event):void
		{
			redraw();
		}
		
		private function redraw():void
		{
			screenViewer.redraw();
			snapShooter.redraw();
		}
		
		private function onConsoleExit(e:Event):void
		{
			trace("Console exited");
			checkToExit();
		}
		
		private function onAppClosing(e:Event):void
		{
			e.preventDefault();
			if (kinectConsole.running)
			{
				kinectConsole.exit();
			}
			if (kinectSocket.connected)
			{
				kinectSocket.close();
			}
		}
		
		private function onSocketClose(e:Event):void
		{
			trace("Socket closed");
			checkToExit();
		}
		
		private function checkToExit():void
		{
			if (!kinectConsole.running && !kinectSocket.connected)
			{
				NativeApplication.nativeApplication.exit();
			}
		}
		
		private function onDoubleClick(e:MouseEvent):void
		{
			if (stage.displayState == StageDisplayState.NORMAL)
			{
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
			else
			{
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		private function onSnapCommandEvent(e:Event):void
		{
			snapShooter.startCount();
		}
		
		private function onBodyDataEvent(e:Event):void
		{
			screenViewer.bodyData = kinectSocket.data;
		}
	}

}