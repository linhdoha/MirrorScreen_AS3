
package mirrorScreen
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import flash.desktop.NativeProcess;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Camera;
	import flash.utils.ByteArray;
	import mirrorScreen.data.Configuration;
	import mirrorScreen.displayComponents.CountDown;
	import mirrorScreen.displayComponents.SkeletonDisplayer;
	import mirrorScreen.kinect.KinectFrame;
	import mirrorScreen.kinect.KinectSocket;
	import mirrorScreen.displayComponents.LiveVideoFeed;
	import mirrorScreen.kinect.KinectViewer;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Main extends Sprite
	{
		private var kinectSocket:KinectSocket;
		private var bodyFeed:LiveVideoFeed;
		private var kinectViewer:KinectViewer;
		private var colorCamera:Camera;
		private var bodyIndexCamera:Camera;
		private var countDown:CountDown;
		private var configuration:Configuration;
		
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
			} else {
				kinectViewer.attachColorImageSource(kinectSocket);
			}
			
			bodyIndexCamera = Camera.getCamera(configuration.kinectBodyIndexCameraID);
			if (bodyIndexCamera != null) {
				bodyIndexCamera.setMode(configuration.kinectBodyIndexCameraWidth, configuration.kinectBodyIndexCameraHeight, 30);
				kinectViewer.attachBodyIndexImageSource(bodyIndexCamera);
			} else {
				kinectViewer.attachColorImageSource(kinectSocket);
			}
			
			kinectSocket = new KinectSocket(configuration.kinectServerHost, configuration.kinectServerPort);
			kinectSocket.kinectFrame.addEventListener(KinectFrame.LOAD_FRAME_COMPLETE, onLoadFrameComplete);
			
			countDown = new CountDown();
			countDown.addEventListener(CountDown.COUNT_COMPLETED, onCountCompleted);
			countDown.x = stage.stageWidth / 2;
			countDown.y = stage.stageHeight / 2;
			addChild(countDown);
			
			var nativeProcess:NativeProcess;
			trace(NativeProcess.isSupported);
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
			var bitmapData:BitmapData = new BitmapData(kinectViewer.width, kinectViewer.height, false);
			bitmapData.draw(kinectViewer);
			
			var data:ByteArray;
			var fileExtension:String;
			if (configuration.imageFileType == "PNG") {
				data = PNGEncoder.encode(bitmapData);
				fileExtension = ".png";
			} else {
				var jpeg:JPGEncoder = new JPGEncoder(configuration.imageFileQuality);
				data = jpeg.encode(bitmapData);
				fileExtension = ".jpg";
			}
			
			var fs:FileStream = new FileStream();
			var targetFile:File = new File(configuration.storageDir);
			if (!targetFile.exists) {
				targetFile = File.desktopDirectory;
			}
			targetFile = targetFile.resolvePath(configuration.prenameOfImage+String(new Date().time + fileExtension));
			fs.open(targetFile, FileMode.WRITE);
			fs.writeBytes(data);
			fs.close();
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