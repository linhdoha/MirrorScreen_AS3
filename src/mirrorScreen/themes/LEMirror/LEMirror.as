package mirrorScreen.themes.LEMirror
{
	import com.nidlab.kinect.BodyDataReader;
	import com.nidlab.kinect.BodyEvent;
	import com.nidlab.kinect.constant.HandStates;
	import com.nidlab.kinect.constant.Joints;
	import com.nidlab.kinect.KinectCameraManager;
	import com.nidlab.kinect.KinectV2Description;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.media.Camera;
	import flash.media.Video;
	import mirrorScreen.Configuration;
	import mirrorScreen.themes.ThemeBase;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class LEMirror extends ThemeBase
	{
		private var view:LEMirrorView;
		private var _bodyDataReader:BodyDataReader;
		private var canvas:Canvas;
		private var handPointers:Vector.<HandPointer> = new Vector.<HandPointer>;
		
		public function LEMirror()
		{
			super();
			view = new LEMirrorView();
			addChild(view);
			
			var kinectCamera:Camera = KinectCameraManager.getInstance().getColorCamera();
			kinectCamera.setMode(KinectV2Description.COLOR_CAMERA_WIDTH, KinectV2Description.COLOR_CAMERA_HEIGHT, KinectV2Description.COLOR_CAMERA_FPS);
			
			var colorVideo:Video = new Video(kinectCamera.width, kinectCamera.height);
			colorVideo.attachCamera(kinectCamera);
			colorVideo.height = Configuration.getInstance().themeHeight;
			colorVideo.scaleX = colorVideo.scaleY;
			colorVideo.x = -colorVideo.width / 2;
			colorVideo.y = -colorVideo.height / 2;
			view.mirror.addChild(colorVideo);
			
			canvas = new Canvas();
			canvas.height = Configuration.getInstance().themeHeight;
			canvas.scaleX = canvas.scaleY;
			canvas.x = -canvas.width / 2;
			canvas.y = -canvas.height / 2;
			view.addChild(canvas);
			
			canvas.cacheAsBitmap = true;
			canvas.filters = [new GlowFilter(0x0000ff, 1, 5, 5, 5), new BlurFilter(2, 2, 1)];
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
			for each (var handPointerTemp:HandPointer in handPointers)
			{
				if (handPointerTemp.bodyId == e.trackingID)
				{
					
					if (handPointerTemp.hand)
					{
						canvas.interact(handPointerTemp, _bodyDataReader.getJointMappedPos(e.trackingID, Joints.HAND_TIP_RIGHT), handPointerTemp.pressure);
					}
					else
					{
						canvas.interact(handPointerTemp, _bodyDataReader.getJointMappedPos(e.trackingID, Joints.HAND_TIP_LEFT), handPointerTemp.pressure);
					}
					
				}
			}
		}
		
		private function onBodyAdded(e:BodyEvent):void
		{
			handPointers.push(new HandPointer(e.trackingID, true));
			handPointers.push(new HandPointer(e.trackingID, false));
		}
		
		private function isLeftHandRaising(trackingID:Number):Boolean
		{
			//return _bodyDataReader.getJoint3DPos(trackingID, Joints.WRIST_LEFT).y >= _bodyDataReader.getJoint3DPos(trackingID, Joints.ELBOW_LEFT).y;
			return true; //_bodyDataReader.getJoint3DPos(trackingID, Joints.SPINE_MID).z - _bodyDataReader.getJoint3DPos(trackingID, Joints.WRIST_LEFT).z >= 0.2 ;
		}
		
		private function isRightHandRaising(trackingID:Number):Boolean
		{
			//return _bodyDataReader.getJoint3DPos(trackingID, Joints.WRIST_RIGHT).y >= _bodyDataReader.getJoint3DPos(trackingID, Joints.ELBOW_RIGHT).y;
			return true; // _bodyDataReader.getJoint3DPos(trackingID, Joints.SPINE_MID).z - _bodyDataReader.getJoint3DPos(trackingID, Joints.WRIST_RIGHT).z >= 0.2 ;
		}
	}

}