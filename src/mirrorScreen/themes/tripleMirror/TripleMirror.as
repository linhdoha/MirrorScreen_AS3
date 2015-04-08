package mirrorScreen.themes.tripleMirror
{
	import com.nidlab.kinect.KinectCameraManager;
	import com.nidlab.kinect.KinectV2Description;
	import flash.events.Event;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.media.Camera;
	import flash.media.Video;
	import mirrorScreen.themes.ThemeBase;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class TripleMirror extends ThemeBase
	{
		private var view:TripleMirrorView;
		private var colorVideoL:Video;
		private var colorVideoC:Video;
		private var colorVideoR:Video;
		
		public function TripleMirror()
		{
			super();
			view = new TripleMirrorView();
			addChild(view);
			
			//setup camera
			var kinectCamera:Camera = KinectCameraManager.getInstance().getColorCamera();
			kinectCamera.setMode(view.mirrorC.mirror.width, view.mirrorC.mirror.height, KinectV2Description.COLOR_CAMERA_FPS);
			
			//attach camera to screen
			colorVideoC = new Video(kinectCamera.width, kinectCamera.height);
			colorVideoC.attachCamera(kinectCamera);
			view.mirrorC.mirror.addChild(colorVideoC);
			
			colorVideoL = new Video(kinectCamera.width, kinectCamera.height);
			colorVideoL.attachCamera(kinectCamera);
			view.mirrorL.mirror.addChild(colorVideoL);
			
			colorVideoR = new Video(kinectCamera.width, kinectCamera.height);
			colorVideoR.attachCamera(kinectCamera);
			view.mirrorR.mirror.addChild(colorVideoR);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			stage.addEventListener(Event.RESIZE, onStageResize);
		}
		
		private function onStageResize(e:Event):void
		{
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(0, 0);
			view.mirrorL.transform.perspectiveProjection = pp;
			view.mirrorR.transform.perspectiveProjection = pp;
		}
	}

}