package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class KinectViewer extends Sprite 
	{
		private var video:Video;
		private var camera:Camera;
		private var bodyData:BodyData;
		private var skeletonHolder:Sprite;
		private var skeletonDisplayerList:Vector.<SkeletonDisplayer>;
		
		public function KinectViewer(width:int, height:int) 
		{
			super();
			camera = Camera.getCamera("1");
			if (camera != null) {
				camera.setMode(width, height, 30);
				video = new Video(width, height);
				video.attachCamera(camera);
				addChild(video);
			} else {
				trace("Kinect camera not found.");
			}
			
			bodyData = new BodyData();
			bodyData.addEventListener(BodyData.DATA_CHANGED, onDataChanged);
			
			skeletonDisplayerList = new Vector.<SkeletonDisplayer>();
			
			skeletonHolder = new Sprite();
			addChild(skeletonHolder);
		}
		
		private function onDataChanged(e:Event):void 
		{
			for (var i:int = 0; i < bodyData.bodyCount; i++ ) {
				if (bodyData.getTrackingIDAt(i) != -1) {
					var foundSkeletonDisplayer:Boolean = false;
					for (var j:int = 0; j < skeletonDisplayerList.length; j++) {
						//nếu đã tồn tại thì cập nhật dữ liệu
						if ((skeletonDisplayerList[j] != null) && (bodyData.getTrackingIDAt(i) == skeletonDisplayerList[j].trackingID)) {
							skeletonDisplayerList[j].leftHandState = bodyData.getLeftHandStateAt(i);
							skeletonDisplayerList[j].leftHandPos = bodyData.getLeftHandPosAt(i);
							skeletonDisplayerList[j].leftHandDepth = bodyData.getLeftHandDepthAt(i);
							
							skeletonDisplayerList[j].rightHandState = bodyData.getRightHandStateAt(i);
							skeletonDisplayerList[j].rightHandPos = bodyData.getRightHandPosAt(i);
							skeletonDisplayerList[j].rightHandDepth = bodyData.getRightHandDepthAt(i);
							foundSkeletonDisplayer = true;
						}
					}
					//nếu chưa tồn tại thì tạo mới
					if (!foundSkeletonDisplayer) {
						var skeletonDisplayerTemp:SkeletonDisplayer = new SkeletonDisplayer();
						skeletonDisplayerTemp.trackingID = bodyData.getTrackingIDAt(i);
						
						skeletonDisplayerTemp.leftHandState = bodyData.getLeftHandStateAt(i);
						skeletonDisplayerTemp.leftHandPos = bodyData.getLeftHandPosAt(i);
						skeletonDisplayerTemp.leftHandDepth = bodyData.getLeftHandDepthAt(i);
						
						skeletonDisplayerTemp.rightHandState = bodyData.getRightHandStateAt(i);
						skeletonDisplayerTemp.rightHandPos = bodyData.getRightHandPosAt(i);
						skeletonDisplayerTemp.rightHandDepth = bodyData.getRightHandDepthAt(i);
						
						skeletonDisplayerList.push(skeletonDisplayerTemp);
						skeletonHolder.addChild(skeletonDisplayerTemp);
					}
				}
			}
			
			//quét dọn tất cả những cái bị mất
			for (var m:int = 0; m < skeletonDisplayerList.length; m++ ) {
				var foundOnBodyData:Boolean = false;
				for (var n:int = 0; n < bodyData.bodyCount; n++) {
					if ((skeletonDisplayerList[m] !=null) && (skeletonDisplayerList[m].trackingID == bodyData.getTrackingIDAt(n))) {
						foundOnBodyData = true;
					}
				}
				if ((!foundOnBodyData) && (skeletonDisplayerList[m] !=null)) {
					skeletonHolder.removeChild(skeletonDisplayerList[m]);
					skeletonDisplayerList[m] = null;
				}
			}
		}
		
		public function set data(s:String):void {
			bodyData.data= s;
		}
	}

}