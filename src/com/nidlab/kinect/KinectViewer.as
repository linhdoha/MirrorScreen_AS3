package com.nidlab.kinect 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
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
		private var _bodyData:BodyDataReader;
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
			
			colorVideoHolder = new Sprite();
			colorVideoHolder.addChild(colorVideo);
			addChild(colorVideoHolder);
			
			_skeletonDisplayerList = new Vector.<SkeletonDisplayer>();
			skeletonHolder = new Sprite();
			addChild(skeletonHolder);
			
			_bodyData = new BodyDataReader();
			_bodyData.addEventListener(BodyDataReader.DATA_CHANGED, onDataChanged);
		}
		
		protected function addSkeletonDisplayer(trackingID:Number, lHandState:Number, lHandPos:Point, lHandDepth:Number, rHandState:Number, rHandPos:Point, rHandDepth:Number):SkeletonDisplayer {
			var skeletonDisplayerTemp:SkeletonDisplayer = new SkeletonDisplayer();
			//skeletonDisplayerTemp.addEventListener(SkeletonDisplayer.SNAP_COMMAND_EVENT, onSnapCommandEvent);
			skeletonDisplayerTemp.trackingID = trackingID;
			
			skeletonDisplayerTemp.leftHand.state = lHandState;
			skeletonDisplayerTemp.leftHand.pos = lHandPos;
			skeletonDisplayerTemp.leftHand.depth = lHandDepth;
			
			skeletonDisplayerTemp.rightHand.state = rHandState;
			skeletonDisplayerTemp.rightHand.pos = rHandPos;
			skeletonDisplayerTemp.rightHand.depth = rHandDepth;
			
			skeletonDisplayerTemp.debugMode = _debugMode;
			
			_skeletonDisplayerList.push(skeletonDisplayerTemp);
			skeletonHolder.addChild(skeletonDisplayerTemp);
			
			return skeletonDisplayerTemp;
		}
		
		protected function updateSkeletonDisplayer(trackingID:Number, lHandState:Number, lHandPos:Point, lHandDepth:Number, rHandState:Number, rHandPos:Point, rHandDepth:Number):SkeletonDisplayer {
			var skeletonDisplayerTemp:SkeletonDisplayer = null;
			for (var j:int = 0; j < _skeletonDisplayerList.length; j++) {
				if ((_skeletonDisplayerList[j] != null) && (trackingID == _skeletonDisplayerList[j].trackingID)) {
					_skeletonDisplayerList[j].leftHand.state = lHandState;
					_skeletonDisplayerList[j].leftHand.pos = lHandPos;
					_skeletonDisplayerList[j].leftHand.depth = lHandDepth;
					
					_skeletonDisplayerList[j].rightHand.state = rHandState;
					_skeletonDisplayerList[j].rightHand.pos = rHandPos;
					_skeletonDisplayerList[j].rightHand.depth = rHandDepth;
					_skeletonDisplayerList[j].debugMode = _debugMode;
					
					skeletonDisplayerTemp = _skeletonDisplayerList[j];
				}
			}
			return skeletonDisplayerTemp;
		}
		
		protected function removeSkeletonDisplayer(index:int):SkeletonDisplayer {
			var currentSkeletonDisplayer:SkeletonDisplayer = _skeletonDisplayerList[index];
			skeletonHolder.removeChild(currentSkeletonDisplayer);
			_skeletonDisplayerList[index] = null;
			
			return currentSkeletonDisplayer;
		}
		
		public function set bodyData(s:String):void {
			_bodyData.data= s;
		}
		
		public function get debugMode():Boolean 
		{
			return _debugMode;
		}
		
		public function set debugMode(value:Boolean):void 
		{
			_debugMode = value;
			
			for (var i:int = 0; i < _skeletonDisplayerList.length; i++ ) {
				_skeletonDisplayerList[i].debugMode = _debugMode;
			}
		}
		
		public function get skeletonDisplayerList():Vector.<SkeletonDisplayer> 
		{
			return _skeletonDisplayerList;
		}
		
		public function set skeletonDisplayerList(value:Vector.<SkeletonDisplayer>):void 
		{
			_skeletonDisplayerList = value;
		}
		
		private function onDataChanged(e:Event):void 
		{
			for (var i:int = 0; i < _bodyData.bodyCount; i++ ) {
				if (_bodyData.getTrackingIDAt(i) != -1) {
					var foundSkeletonDisplayer:Boolean = false;
					//cập nhật dữ liệu
					foundSkeletonDisplayer = (updateSkeletonDisplayer(_bodyData.getTrackingIDAt(i), _bodyData.getLeftHandStateAt(i), _bodyData.getLeftHandPosAt(i), _bodyData.getLeftHandDepthAt(i), _bodyData.getRightHandStateAt(i), _bodyData.getRightHandPosAt(i), _bodyData.getRightHandDepthAt(i)) != null);
					
					//nếu chưa tồn tại thì tạo mới
					if (!foundSkeletonDisplayer) {
						addSkeletonDisplayer(_bodyData.getTrackingIDAt(i), _bodyData.getLeftHandStateAt(i), _bodyData.getLeftHandPosAt(i), _bodyData.getLeftHandDepthAt(i), _bodyData.getRightHandStateAt(i), _bodyData.getRightHandPosAt(i), _bodyData.getRightHandDepthAt(i));
					}
				}
			}
			
			//quét dọn tất cả những cái bị mất
			for (var m:int = 0; m < _skeletonDisplayerList.length; m++ ) {
				var foundOnBodyData:Boolean = false;
				for (var n:int = 0; n < _bodyData.bodyCount; n++) {
					if ((_skeletonDisplayerList[m] !=null) && (_skeletonDisplayerList[m].trackingID == _bodyData.getTrackingIDAt(n))) {
						foundOnBodyData = true;
					}
				}
				if ((!foundOnBodyData) && (_skeletonDisplayerList[m] !=null)) {
					removeSkeletonDisplayer(m);
				}
			}
		}
		
		/*private function onSnapCommandEvent(e:Event):void 
		{
			dispatchEvent(new Event(SkeletonDisplayer.SNAP_COMMAND_EVENT));
		}*/
	}

}