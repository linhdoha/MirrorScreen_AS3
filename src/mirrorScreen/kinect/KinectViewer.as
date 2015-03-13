package mirrorScreen.kinect 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.ByteArray;
	import mirrorScreen.data.BodyData;
	import mirrorScreen.data.NBodyData;
	import mirrorScreen.displayComponents.LiveVideoFeed;
	import mirrorScreen.displayComponents.SkeletonDisplayer;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class KinectViewer extends Sprite 
	{
		public static const FIRE_EFFECT:String = "fireEffect";
		
		private var colorImageVideo:Video;
		private var colorImageVideoHolder:Sprite;
		
		private var colorFeed:LiveVideoFeed;
		
		private var _bodyData:NBodyData;
		
		private var skeletonHolder:Sprite;
		private var skeletonDisplayerList:Vector.<SkeletonDisplayer>;
		
		private var _mirror:Boolean = false;
		private var _colorImageSource:Camera;
		private var _bodyIndexImageSource:Camera;
		
		public function KinectViewer() 
		{
			super();
			
			colorImageVideoHolder = new Sprite();
			addChild(colorImageVideoHolder);
			
			_bodyData = new NBodyData();
			_bodyData.addEventListener(BodyData.DATA_CHANGED, onDataChanged);
			
			skeletonDisplayerList = new Vector.<SkeletonDisplayer>();
			
			skeletonHolder = new Sprite();
			addChild(skeletonHolder);
			
			colorFeed = new LiveVideoFeed();
			addChild(colorFeed);
		}
		
		private function onDataChanged(e:Event):void 
		{
			for (var i:int = 0; i < _bodyData.bodyCount; i++ ) {
				if (_bodyData.getTrackingIDAt(i) != -1) {
					var foundSkeletonDisplayer:Boolean = false;
					for (var j:int = 0; j < skeletonDisplayerList.length; j++) {
						//nếu đã tồn tại thì cập nhật dữ liệu
						if ((skeletonDisplayerList[j] != null) && (_bodyData.getTrackingIDAt(i) == skeletonDisplayerList[j].trackingID)) {
							skeletonDisplayerList[j].leftHand.state = _bodyData.getLeftHandStateAt(i);
							skeletonDisplayerList[j].leftHand.pos = _bodyData.getLeftHandPosAt(i);
							skeletonDisplayerList[j].leftHand.depth = _bodyData.getLeftHandDepthAt(i);
							
							skeletonDisplayerList[j].rightHand.state = _bodyData.getRightHandStateAt(i);
							skeletonDisplayerList[j].rightHand.pos = _bodyData.getRightHandPosAt(i);
							skeletonDisplayerList[j].rightHand.depth = _bodyData.getRightHandDepthAt(i);
							
							foundSkeletonDisplayer = true;
						}
					}
					//nếu chưa tồn tại thì tạo mới
					if (!foundSkeletonDisplayer) {
						var skeletonDisplayerTemp:SkeletonDisplayer = new SkeletonDisplayer();
						skeletonDisplayerTemp.addEventListener(SkeletonDisplayer.SNAP_COMMAND_EVENT, onSnapCommandEvent);
						skeletonDisplayerTemp.trackingID = _bodyData.getTrackingIDAt(i);
						
						skeletonDisplayerTemp.leftHand.state = _bodyData.getLeftHandStateAt(i);
						skeletonDisplayerTemp.leftHand.pos = _bodyData.getLeftHandPosAt(i);
						skeletonDisplayerTemp.leftHand.depth = _bodyData.getLeftHandDepthAt(i);
						
						skeletonDisplayerTemp.rightHand.state = _bodyData.getRightHandStateAt(i);
						skeletonDisplayerTemp.rightHand.pos = _bodyData.getRightHandPosAt(i);
						skeletonDisplayerTemp.rightHand.depth = _bodyData.getRightHandDepthAt(i);
						
						skeletonDisplayerList.push(skeletonDisplayerTemp);
						skeletonHolder.addChild(skeletonDisplayerTemp);
					}
				}
			}
			
			//quét dọn tất cả những cái bị mất
			for (var m:int = 0; m < skeletonDisplayerList.length; m++ ) {
				var foundOnBodyData:Boolean = false;
				for (var n:int = 0; n < _bodyData.bodyCount; n++) {
					if ((skeletonDisplayerList[m] !=null) && (skeletonDisplayerList[m].trackingID == _bodyData.getTrackingIDAt(n))) {
						foundOnBodyData = true;
					}
				}
				if ((!foundOnBodyData) && (skeletonDisplayerList[m] !=null)) {
					skeletonHolder.removeChild(skeletonDisplayerList[m]);
					skeletonDisplayerList[m] = null;
				}
			}
		}
		
		private function onSnapCommandEvent(e:Event):void 
		{
			dispatchEvent(new Event(SkeletonDisplayer.SNAP_COMMAND_EVENT));
		}
		
		public function attachColorImageSource(source:Camera):void {
			_colorImageSource = source;
			
			if (colorImageVideo != null) {
				colorImageVideoHolder.removeChild(colorImageVideo);
			}
			var cameraSource:Camera = Camera(_colorImageSource);
			colorImageVideo = new Video(cameraSource.width, cameraSource.height);
			colorImageVideo.attachCamera(cameraSource);
			colorImageVideoHolder.addChild(colorImageVideo);
			
		}
		
		public function attachBodyIndexImageSource(source:Camera):void {
			_bodyIndexImageSource = source;
			
		}
		
		public function set bodyData(s:String):void {
			_bodyData.data= s;
		}
		
		public function set colorData(d:ByteArray):void {
			
		}
		
		public function set mirror(m:Boolean):void {
			_mirror = m;
			if (_mirror) {
				colorImageVideoHolder.scaleX = -1;
				colorImageVideoHolder.x = colorImageVideoHolder.width;
			} else {
				colorImageVideoHolder.scaleX = 1;
				colorImageVideoHolder.x = 0;
			}
		}
		
		public function get mirror():Boolean 
		{
			return _mirror;
		}
	}

}