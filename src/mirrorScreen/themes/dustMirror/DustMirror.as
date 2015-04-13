package mirrorScreen.themes.dustMirror 
{
	import com.nidlab.kinect.BodyDataReader;
	import com.nidlab.kinect.BodyEvent;
	import com.nidlab.kinect.constant.HandStates;
	import com.nidlab.kinect.constant.Joints;
	import com.nidlab.kinect.KinectCameraManager;
	import com.nidlab.kinect.KinectV2Description;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import mirrorScreen.themes.ThemeBase;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class DustMirror extends ThemeBase 
	{
		private var view:DustMirrorView;
		private var _bodyDataReader:BodyDataReader;
		//private var canvasList:Vector.<Canvas>;
		private var canvasBodyMapper:Array = [];
		private var rightHandIsWriting:Boolean = false;
		
		public function DustMirror() 
		{
			super();
			view = new DustMirrorView();
			addChild(view);
			
			var kinectCamera:Camera = KinectCameraManager.getInstance().getColorCamera();
			kinectCamera.setMode(607, 1080, KinectV2Description.COLOR_CAMERA_FPS);
			
			var colorVideo:Video = new Video(kinectCamera.width, kinectCamera.height);
			colorVideo.attachCamera(kinectCamera);
			colorVideo.width = view.mirror.width;
			colorVideo.height = view.mirror.height;
			view.mirror.addChild(colorVideo);
			
			var colorVideo2:Video = new Video(kinectCamera.width, kinectCamera.height);
			colorVideo2.attachCamera(kinectCamera);
			colorVideo2.width = view.mirror2.width;
			colorVideo2.height = view.mirror2.height;
			view.mirror2.addChild(colorVideo2);
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
			/*if (_bodyDataReader.getRightHandState(e.trackingID) == HandStates.LASSO) {
				if (!rightHandIsWriting) {
					rightHandIsWriting = true;
					
					var canvasTemp:Canvas = new Canvas(e.trackingID, true);
					addChild(canvasTemp);
					
					canvasBodyMapper.push(new { canvas:canvasTemp, trackingID:e.trackingID, handRight:true } );
					
				} else {
					for each (var obj:Object in canvasBodyMapper) {
						if (obj.trackingID) {
							
						}
					}
				}
				
				
			} else if (rightHandIsWriting) {
				
			}*/
			
			
			
		}
		
		private function onBodyAdded(e:BodyEvent):void 
		{
			
		}
	}

}