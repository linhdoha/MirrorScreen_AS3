package com.nidlab.kinect 
{
	import flash.media.Camera;
	import mirrorScreen.Configuration;
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class KinectCameraManager 
	{
		static private var _instance:KinectCameraManager;
		
		public function KinectCameraManager() 
		{
			
		}
		
		public static function getInstance():KinectCameraManager {
			if (_instance == null) {
				_instance = new KinectCameraManager();
			}
			
			return _instance;
		}
		
		private function getCameraIndex(name:String):int {
			var returnIndex:int = -1;
			for (var i:int = 0; i < Camera.names.length; i++ ) {
				if (name == Camera.names[i]) {
					returnIndex = i;
				}
			}
			return returnIndex;
		}
		
		public function getColorCamera():Camera {
			return Camera.getCamera(String(getCameraIndex(KinectV2Description.COLOR_CAMERA_ID)));
		}
		
		public function getBodyIndexCamera():Camera {
			return Camera.getCamera(String(getCameraIndex(KinectV2Description.BODY_INDEX_CAMERA_ID)));
		}
	}

}