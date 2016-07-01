package mirrorScreen.themes.dustMirror 
{
	import com.nidlab.kinect.BodyDataReader;
	import com.nidlab.kinect.BodyEvent;
	import com.nidlab.kinect.constant.HandStates;
	import com.nidlab.kinect.constant.Joints;
	import com.nidlab.kinect.KinectCameraManager;
	import com.nidlab.kinect.KinectV2Description;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.Dictionary;
	import mirrorScreen.Configuration;
	import mirrorScreen.themes.ThemeBase;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class DustMirror extends ThemeBase 
	{
		private var view:DustMirrorView;
		private var _bodyDataReader:BodyDataReader;
		private var canvas:Canvas;
		private var handPointers:Vector.<HandPointer> = new Vector.<HandPointer>;
		
		public function DustMirror() 
		{
			super();
			view = new DustMirrorView();
			addChild(view);
			
			var kinectCamera:Camera = KinectCameraManager.getInstance().getColorCamera();
			kinectCamera.setMode(KinectV2Description.COLOR_CAMERA_WIDTH, KinectV2Description.COLOR_CAMERA_HEIGHT, KinectV2Description.COLOR_CAMERA_FPS);
			
			var colorVideo:Video = new Video(kinectCamera.width, kinectCamera.height);
			colorVideo.attachCamera(kinectCamera);
			colorVideo.height = Configuration.getInstance().themeHeight;
			colorVideo.scaleX = colorVideo.scaleY;
			colorVideo.scaleX = -colorVideo.scaleX;
			colorVideo.x = colorVideo.width / 2;
			colorVideo.y = -colorVideo.height / 2;
			view.mirror.addChild(colorVideo);
			
			var colorVideo2:Video = new Video(kinectCamera.width, kinectCamera.height);
			colorVideo2.attachCamera(kinectCamera);
			colorVideo2.height = Configuration.getInstance().themeHeight;
			colorVideo2.scaleX = colorVideo2.scaleY;
			colorVideo2.scaleX = -colorVideo2.scaleX;
			colorVideo2.x = colorVideo2.width / 2;
			colorVideo2.y = -colorVideo2.height / 2;
			view.mirror2.addChild(colorVideo2);
			
			canvas = new Canvas();
			canvas.height = Configuration.getInstance().themeHeight;
			canvas.scaleX = canvas.scaleY;
			canvas.x = -canvas.width / 2;
			canvas.y = -canvas.height / 2;
			view.addChild(canvas);
			
			canvas.cacheAsBitmap = true;
			canvas.filters = [new BlurFilter(0,0,1)];
			
			view.mirror2.cacheAsBitmap = true;
			view.mirror2.mask = canvas;
		}
		
		override public function set bodyDataReader(value:BodyDataReader):void 
		{
			super.bodyDataReader = value;
			_bodyDataReader = value;
			_bodyDataReader.addEventListener(BodyDataReader.DATA_CHANGED, onDataChanged);
			_bodyDataReader.addEventListener(BodyDataReader.ON_BODY_ADDED, onBodyAdded);
			_bodyDataReader.addEventListener(BodyDataReader.ON_BODY_UPDATED, onBodyUpdated);
			_bodyDataReader.addEventListener(BodyDataReader.ON_BODY_REMOVED, onBodyRemoved);
		}
		
		private function onDataChanged(e:Event):void 
		{
			
		}
		
		private function onBodyRemoved(e:BodyEvent):void 
		{
			
		}
		
		private function onBodyUpdated(e:BodyEvent):void 
		{
			for each(var handPointerTemp:HandPointer in handPointers) {
				if (handPointerTemp.bodyId == e.trackingID) {
					if (handPointerTemp.hand) {
						if (_bodyDataReader.getRightHandState(handPointerTemp.bodyId) == HandStates.LASSO && isRightHandRaising(handPointerTemp.bodyId)) {
							handPointerTemp.isDrawing = true;
							handPointerTemp.pressure = 10;
						} else if (_bodyDataReader.getRightHandState(handPointerTemp.bodyId) == HandStates.OPEN && isRightHandRaising(handPointerTemp.bodyId)) {
							handPointerTemp.pressure = 40;
							handPointerTemp.isDrawing = true;
						} else if (_bodyDataReader.getRightHandState(handPointerTemp.bodyId) == HandStates.CLOSED || !isRightHandRaising(handPointerTemp.bodyId)) {
							handPointerTemp.isDrawing = false;
							canvas.release(handPointerTemp);
						}
					} else {
						if (_bodyDataReader.getLeftHandState(handPointerTemp.bodyId) == HandStates.LASSO && isLeftHandRaising(handPointerTemp.bodyId)) {
							handPointerTemp.isDrawing = true;
							handPointerTemp.pressure = 10;
						} else if (_bodyDataReader.getLeftHandState(handPointerTemp.bodyId) == HandStates.OPEN && isLeftHandRaising(handPointerTemp.bodyId)) {
							handPointerTemp.pressure = 40;
							handPointerTemp.isDrawing = true;
						} else if (_bodyDataReader.getLeftHandState(handPointerTemp.bodyId) == HandStates.CLOSED || !isLeftHandRaising(handPointerTemp.bodyId)) {
							handPointerTemp.isDrawing = false;
							canvas.release(handPointerTemp);
						}
					}
					
					if (handPointerTemp.isDrawing) {
						if (handPointerTemp.hand) {
							canvas.interact(handPointerTemp, _bodyDataReader.getJointMappedPos(e.trackingID, Joints.HAND_TIP_RIGHT),handPointerTemp.pressure);
						} else {
							canvas.interact(handPointerTemp, _bodyDataReader.getJointMappedPos(e.trackingID, Joints.HAND_TIP_LEFT),handPointerTemp.pressure);
						}
						
					}
				}
			}
		}
		
		private function onBodyAdded(e:BodyEvent):void 
		{
			handPointers.push(new HandPointer(e.trackingID,true));
			handPointers.push(new HandPointer(e.trackingID,false));
		}
		
		private function isLeftHandRaising(trackingID:Number):Boolean {
			//return _bodyDataReader.getJoint3DPos(trackingID, Joints.WRIST_LEFT).y >= _bodyDataReader.getJoint3DPos(trackingID, Joints.ELBOW_LEFT).y;
			return true;//_bodyDataReader.getJoint3DPos(trackingID, Joints.SPINE_MID).z - _bodyDataReader.getJoint3DPos(trackingID, Joints.WRIST_LEFT).z >= 0.2 ;
		}
		
		private function isRightHandRaising(trackingID:Number):Boolean {
			//return _bodyDataReader.getJoint3DPos(trackingID, Joints.WRIST_RIGHT).y >= _bodyDataReader.getJoint3DPos(trackingID, Joints.ELBOW_RIGHT).y;
			return true;// _bodyDataReader.getJoint3DPos(trackingID, Joints.SPINE_MID).z - _bodyDataReader.getJoint3DPos(trackingID, Joints.WRIST_RIGHT).z >= 0.2 ;
		}
	}

}