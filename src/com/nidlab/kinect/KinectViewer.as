package com.nidlab.kinect 
{
	import com.nidlab.kinect.constant.Joints;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.media.Camera;
	import flash.media.Video;
	import com.nidlab.kinect.BodyDataReader;
	import com.nidlab.kinect.SkeletonDisplayer;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class KinectViewer extends Sprite 
	{
		private var colorVideo:Video;
		private var colorVideoHolder:Sprite;
		private var skeletonHolder:Sprite;
		private var _skeletonDisplayerList:Vector.<SkeletonDisplayer>;
		protected var _bodyDataReader:BodyDataReader;
		private var _debugMode:Boolean = false;
		
		public function KinectViewer() 
		{
			super();
			
			graphics.beginFill(0x000000,0.2);
			graphics.drawRoundRect(0, 0, KinectV2Description.COLOR_CAMERA_WIDTH, KinectV2Description.COLOR_CAMERA_HEIGHT, 20, 20);
			graphics.endFill();
			
			var kinectCamera:Camera = KinectCameraManager.getInstance().getColorCamera();
			kinectCamera.setMode(KinectV2Description.COLOR_CAMERA_WIDTH, KinectV2Description.COLOR_CAMERA_HEIGHT, KinectV2Description.COLOR_CAMERA_FPS);
			colorVideo = new Video(kinectCamera.width,kinectCamera.height);
			colorVideo.attachCamera(kinectCamera);
			colorVideo.scaleX = -colorVideo.scaleX;
			colorVideo.x = colorVideo.width;
			
			colorVideoHolder = new Sprite();
			colorVideoHolder.addChild(colorVideo);
			addChild(colorVideoHolder);
			
			_skeletonDisplayerList = new Vector.<SkeletonDisplayer>();
			skeletonHolder = new Sprite();
			addChild(skeletonHolder);
			skeletonHolder.visible = _debugMode;
		}
		
		protected function addSkeletonDisplayer(trackingID:Number, lHandState:int, lHandPos:Point, lHandDepth:Number, rHandState:int, rHandPos:Point, rHandDepth:Number):SkeletonDisplayer {
			var skeletonDisplayerTemp:SkeletonDisplayer = new SkeletonDisplayer();
			skeletonDisplayerTemp.trackingID = trackingID;
			
			skeletonDisplayerTemp.leftHand.state = lHandState;
			skeletonDisplayerTemp.leftHand.pos = lHandPos;
			skeletonDisplayerTemp.leftHand.depth = lHandDepth;
			
			skeletonDisplayerTemp.rightHand.state = rHandState;
			skeletonDisplayerTemp.rightHand.pos = rHandPos;
			skeletonDisplayerTemp.rightHand.depth = rHandDepth;
			
			//skeletonDisplayerTemp.debugMode = _debugMode;
			
			_skeletonDisplayerList.push(skeletonDisplayerTemp);
			skeletonHolder.addChild(skeletonDisplayerTemp);
			
			return skeletonDisplayerTemp;
		}
		
		protected function updateSkeletonDisplayer(trackingID:Number, lHandState:int, lHandPos:Point, lHandDepth:Number, rHandState:int, rHandPos:Point, rHandDepth:Number):SkeletonDisplayer {
			var skeletonDisplayerTemp:SkeletonDisplayer = null;
			for (var j:int = 0; j < _skeletonDisplayerList.length; j++) {
				if ((_skeletonDisplayerList[j] != null) && (trackingID == _skeletonDisplayerList[j].trackingID)) {
					_skeletonDisplayerList[j].leftHand.state = lHandState;
					_skeletonDisplayerList[j].leftHand.pos = lHandPos;
					_skeletonDisplayerList[j].leftHand.depth = lHandDepth;
					
					_skeletonDisplayerList[j].rightHand.state = rHandState;
					_skeletonDisplayerList[j].rightHand.pos = rHandPos;
					_skeletonDisplayerList[j].rightHand.depth = rHandDepth;
					
					skeletonDisplayerTemp = _skeletonDisplayerList[j];
				}
			}
			return skeletonDisplayerTemp;
		}
		
		protected function removeSkeletonDisplayer(trackingID:Number):SkeletonDisplayer {
			var currentSkeletonDisplayer:SkeletonDisplayer = null;
			for (var i:int = 0; i < _skeletonDisplayerList.length; i++ ) {
				if ((_skeletonDisplayerList[i] != null) && (trackingID == _skeletonDisplayerList[i].trackingID)) {
					currentSkeletonDisplayer = _skeletonDisplayerList[i];
					skeletonHolder.removeChild(currentSkeletonDisplayer);
					_skeletonDisplayerList[i] = null;
				}
			}
			
			return currentSkeletonDisplayer;
		}
		
		public function get debugMode():Boolean 
		{
			return _debugMode;
		}
		
		public function set debugMode(value:Boolean):void 
		{
			_debugMode = value;
			
			/*for (var i:int = 0; i < _skeletonDisplayerList.length; i++ ) {
				_skeletonDisplayerList[i].debugMode = _debugMode;
			}*/
			
			skeletonHolder.visible = _debugMode;
		}
		
		public function get skeletonDisplayerList():Vector.<SkeletonDisplayer> 
		{
			return _skeletonDisplayerList;
		}
		
		public function set skeletonDisplayerList(value:Vector.<SkeletonDisplayer>):void 
		{
			_skeletonDisplayerList = value;
		}
		
		public function get bodyDataReader():BodyDataReader 
		{
			return _bodyDataReader;
		}
		
		public function set bodyDataReader(value:BodyDataReader):void 
		{
			_bodyDataReader = value;
			_bodyDataReader.addEventListener(BodyDataReader.ON_BODY_ADDED, onBodyAdded);
			_bodyDataReader.addEventListener(BodyDataReader.ON_BODY_UPDATED, onBodyUpdated);
			_bodyDataReader.addEventListener(BodyDataReader.ON_BODY_REMOVED, onBodyRemoved);
		}
		
		private function onBodyRemoved(e:BodyEvent):void 
		{
			var trackingID:Number = e.trackingID;
			removeSkeletonDisplayer(trackingID);
		}
		
		private function onBodyUpdated(e:BodyEvent):void 
		{
			var trackingID:Number = e.trackingID;
			var leftHandState:int = _bodyDataReader.getLeftHandState(trackingID);
			var leftHandPos:Point = _bodyDataReader.getJointMappedPos(trackingID,Joints.HAND_LEFT);
			var leftHand3DPos:Vector3D = _bodyDataReader.getJoint3DPos(trackingID,Joints.HAND_LEFT);
			
			var rightHandState:int = _bodyDataReader.getRightHandState(trackingID);
			var rightHandPos:Point = _bodyDataReader.getJointMappedPos(trackingID,Joints.HAND_RIGHT);
			var rightHand3DPos:Vector3D = _bodyDataReader.getJoint3DPos(trackingID,Joints.HAND_RIGHT);
			
			updateSkeletonDisplayer(trackingID, leftHandState, leftHandPos, leftHand3DPos.z, rightHandState, rightHandPos, rightHand3DPos.z);
		}
		
		private function onBodyAdded(e:BodyEvent):void 
		{
			var trackingID:Number = e.trackingID;
			var leftHandState:int = _bodyDataReader.getLeftHandState(trackingID);
			var leftHandPos:Point = _bodyDataReader.getJointMappedPos(trackingID,Joints.HAND_LEFT);
			var leftHand3DPos:Vector3D = _bodyDataReader.getJoint3DPos(trackingID,Joints.HAND_LEFT);
			
			var rightHandState:int = _bodyDataReader.getRightHandState(trackingID);
			var rightHandPos:Point = _bodyDataReader.getJointMappedPos(trackingID,Joints.HAND_RIGHT);
			var rightHand3DPos:Vector3D = _bodyDataReader.getJoint3DPos(trackingID,Joints.HAND_RIGHT);
			
			addSkeletonDisplayer(trackingID, leftHandState, leftHandPos, leftHand3DPos.z, rightHandState, rightHandPos, rightHand3DPos.z);
		}
	}

}