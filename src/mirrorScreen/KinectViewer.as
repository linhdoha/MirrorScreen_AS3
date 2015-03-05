package mirrorScreen 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.ByteArray;
	import mirrorScreen.displayComponents.LiveVideoFeed;
	import mirrorScreen.KinectSocket;
	import mirrorScreen.data.BodyData;
	import mirrorScreen.displayComponents.SkeletonDisplayer;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class KinectViewer extends Sprite 
	{
		private var video:Video;
		private var camera:Camera;
		private var videoHolder:Sprite;
		
		private var colorFeed:LiveVideoFeed;
		
		private var _bodyData:BodyData;
		
		private var skeletonHolder:Sprite;
		private var skeletonDisplayerList:Vector.<SkeletonDisplayer>;
		
		private var _mirror:Boolean = false;
		private var _colorImageSource:Object;
		
		public function KinectViewer() 
		{
			super();
			
			videoHolder = new Sprite();
			addChild(videoHolder);
			
			_bodyData = new BodyData();
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
		
		public function attachColorImageSource(source:Object):void {
			_colorImageSource = source;
			if (_colorImageSource is Camera) {
				if (video != null) {
					videoHolder.removeChild(video);
				}
				var cameraSource:Camera = Camera(_colorImageSource);
				video = new Video(cameraSource.width, cameraSource.height);
				video.attachCamera(cameraSource);
				videoHolder.addChild(video);
			} else if (_colorImageSource is KinectSocket) {
				var colorImageKinectSocket:KinectSocket = KinectSocket(_colorImageSource);
				colorImageKinectSocket.kinectFrame.addEventListener(KinectFrame.LOAD_FRAME_COMPLETE, onLoadFrameComplete);
			} else {
				trace("Source unknown!");
			}
		}
		
		private function onLoadFrameComplete(e:Event):void
		{
			if (KinectSocket(_colorImageSource).kinectFrame.colorImageFlag) colorFeed.bytes = KinectSocket(_colorImageSource).kinectFrame.colorImage;
		}
		
		public function set bodyData(s:String):void {
			_bodyData.data= s;
		}
		
		public function set colorData(d:ByteArray):void {
			
		}
		
		public function set mirror(m:Boolean):void {
			_mirror = m;
			if (_mirror) {
				videoHolder.scaleX = -1;
				videoHolder.x = videoHolder.width;
			} else {
				videoHolder.scaleX = 1;
				videoHolder.x = 0;
			}
		}
		
		public function get mirror():Boolean 
		{
			return _mirror;
		}
	}

}