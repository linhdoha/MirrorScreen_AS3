
package mirrorScreen
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Camera;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import mirrorScreen.data.Configuration;
	import mirrorScreen.displayComponents.CountDown;
	import mirrorScreen.displayComponents.SkeletonDisplayer;
	import mirrorScreen.displayComponents.LiveVideoFeed;
	import mirrorScreen.kinect.KinectSocket;
	import mirrorScreen.kinect.KinectViewer;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Main extends Sprite
	{
		private var kinectSocketCompact:KinectSocket;
		
		private var kinectViewer:KinectViewer;
		
		private var colorCamera:Camera;
		private var bodyIndexCamera:Camera;
		
		private var countDown:CountDown;
		private var configuration:Configuration;
		private var saveImageWorker:Worker;
		private var wtm:MessageChannel;
		private var mtw:MessageChannel;
		private var fileExtension:String;
		private var bitmapData:BitmapData;
		private var data:ByteArray;
		private var imageBytes:ByteArray;
		private var process:NativeProcess;
		
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
			
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			
			kinectViewer = new KinectViewer();
			kinectViewer.addEventListener(SkeletonDisplayer.SNAP_COMMAND_EVENT, onSnapCommandEvent);
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
			
			kinectSocketCompact = new KinectSocket(configuration.kinectServerHost, configuration.kinectServerPort);
			kinectSocketCompact.addEventListener(KinectSocket.BODY_DATA_EVENT, onBodyDataEvent);
			
			countDown = new CountDown();
			countDown.addEventListener(CountDown.COUNT_COMPLETED, onCountCompleted);
			countDown.x = stage.stageWidth / 2;
			countDown.y = stage.stageHeight / 2;
			addChild(countDown);
			
			
			//Kinect Server Console
			var nativeProcess:NativeProcess;
			trace(NativeProcess.isSupported);
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			var file:File = File.applicationDirectory.resolvePath("KinectServerConsole.exe");
			nativeProcessStartupInfo.executable = file;
			
			process = new NativeProcess();
			process.start(nativeProcessStartupInfo);
			process.addEventListener(NativeProcessExitEvent.EXIT, onProcessExit);
			
			//Save Image Worker
			data = new ByteArray();
			data.shareable = true;
			
			imageBytes = new ByteArray();
			imageBytes.shareable = true;
			
			saveImageWorker = WorkerDomain.current.createWorker(Workers.SaveImageWorker,true);
			wtm = saveImageWorker.createMessageChannel(Worker.current);
			mtw = Worker.current.createMessageChannel(saveImageWorker);
			
			wtm.addEventListener(Event.CHANNEL_MESSAGE, onMessageFromWorker);
			
			saveImageWorker.setSharedProperty("wtm",wtm);
			saveImageWorker.setSharedProperty("mtw", mtw);
			saveImageWorker.setSharedProperty("sourceImage", imageBytes);
			saveImageWorker.setSharedProperty("data", data);
			saveImageWorker.start();
			
			stage.nativeWindow.addEventListener(Event.CLOSING, onAppClosing);
		}
		
		private function onAppClosing(e:Event):void 
		{
			e.preventDefault();
			if (process.running) {
				process.exit(true);
			}
		}
		
		private function onProcessExit(e:NativeProcessExitEvent):void 
		{
			trace("Process exit");
			NativeApplication.nativeApplication.exit();
		}
		
		private function onDoubleClick(e:MouseEvent):void 
		{
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			} else {
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		private function onCountCompleted(e:Event):void 
		{
			bitmapData = new BitmapData(kinectViewer.width, kinectViewer.height, false);
			bitmapData.draw(kinectViewer);
			imageBytes.length = 0;
			bitmapData.copyPixelsToByteArray(bitmapData.rect, imageBytes);
			
			if (configuration.imageFileType == "PNG") {
				fileExtension = ".png";
			} else {
				fileExtension = ".jpg";
			}
			
			var commandObj:Object = {
				command:"SAVE_IMAGE",
				width:bitmapData.rect.width,
				height:bitmapData.rect.height,
				encode:configuration.imageFileType,
				quality:configuration.imageFileQuality,
				filename:configuration.prenameOfImage+String(new Date().time + fileExtension),
				dir:configuration.storageDir
			}
			
			mtw.send(commandObj);
		}
		
		private function onMessageFromWorker(e:Event):void 
		{
			var messageReceived:* = wtm.receive();
			if (messageReceived == "ENCODE_COMPLETED") {
				trace("ENCODE_COMPLETED");
			}
		}
		
		private function onSnapCommandEvent(e:Event):void 
		{
			countDown.start();
		}
		
		private function onBodyDataEvent(e:Event):void {
			kinectSocketCompact.data.position = 0;
			kinectViewer.bodyData = kinectSocketCompact.data.readUTFBytes(kinectSocketCompact.data.bytesAvailable);
		}
	}

}