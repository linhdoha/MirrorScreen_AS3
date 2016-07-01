
package mirrorScreen
{
	import com.nidlab.kinect.BodyDataReader;
	import com.nidlab.kinect.GestureEvent;
	import com.nidlab.kinect.KinectConsole;
	import com.nidlab.kinect.KinectSocket;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mirrorScreen.CommandDetector;
	import mirrorScreen.Configuration;
	import mirrorScreen.displayComponents.ScreenViewer;
	import mirrorScreen.displayComponents.SnapShooter;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class SelfieMirror extends Sprite
	{
		private var kinectSocket:KinectSocket;
		private var screenViewer:ScreenViewer;
		private var appConfig:Configuration;
		private var snapShooter:SnapShooter;
		private var kinectConsole:KinectConsole;
		private var bodyDataReader:BodyDataReader;
		private var commandDetector:CommandDetector;
		
		public function SelfieMirror()
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
			stage.nativeWindow.addEventListener(Event.CLOSING, onAppClosing);
			
			appConfig = Configuration.getInstance();
			
			bodyDataReader = new BodyDataReader();
			
			kinectConsole = new KinectConsole(appConfig.kinectPort,false);
			kinectConsole.addEventListener(KinectConsole.PROCESS_EXIT, onConsoleExit);
			
			kinectSocket = new KinectSocket(appConfig.kinectPort);
			kinectSocket.gestureDatabaseFiles.push("database/TakeSnap.gba");
			kinectSocket.gestureDatabaseFiles.push("database/WaveHand.gba");
			
			kinectSocket.addEventListener(KinectSocket.BODY_DATA_EVENT, onBodyDataEvent);
			kinectSocket.addEventListener(Event.CLOSE, onSocketClose);
			
			commandDetector = new CommandDetector();
			commandDetector.bodyDataReader = bodyDataReader;
			commandDetector.addEventListener(CommandDetector.ON_SNAP_COMMAND, onSnapCommandEvent);
			
			screenViewer = new ScreenViewer();
			screenViewer.mouseChildren = false;
			screenViewer.doubleClickEnabled = true;
			screenViewer.bodyDataReader = bodyDataReader;
			screenViewer.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			addChild(screenViewer);
			
			screenViewer.theme = ScreenViewer.FIRE_THEME;
			
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
			bodyDataReader.data = kinectSocket.data;
		}
	}

}