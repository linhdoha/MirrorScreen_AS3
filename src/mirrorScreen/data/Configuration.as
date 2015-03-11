package mirrorScreen.data 
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Configuration 
	{
		private const CONFIG_FILE_PATH:String = "config.xml";
		private var file:File;
		private var config:XML;
		
		public function Configuration() 
		{
			file = File.applicationDirectory.resolvePath(CONFIG_FILE_PATH);
			read();
		}
		
		private function read():void {
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			config = XML(fs.readUTFBytes(fs.bytesAvailable));
			fs.close();
		}
		
		public function get kinectCameraID():String {
			return config.kinectCamera.@id;
		}
		
		public function get kinectCameraMirror():Boolean {
			return config.kinectCamera.@mirror == "true";
		}
		
		public function get kinectCameraWidth():int {
			return int(config.kinectCamera.@width);
		}
		
		public function get kinectCameraHeight():int {
			return int(config.kinectCamera.@height);
		}
		
		public function get kinectBodyIndexCameraID():String {
			return config.kinectCameraBodyIndex.@id;
		}
		
		public function get kinectBodyIndexCameraWidth():int {
			return int(config.kinectCameraBodyIndex.@width);
		}
		
		public function get kinectBodyIndexCameraHeight():int {
			return int(config.kinectCameraBodyIndex.@height);
		}
		
		public function get kinectServerHost():String {
			return config.kinectServer.@host;
		}
		
		public function get kinectServerPort():int {
			return int(config.kinectServer.@port);
		}
		
		public function get storageDir():String {
			return config.storageDir.@path;
		}
		
		public function get prenameOfImage():String {
			return config.imageFile.@prename;
		}
		
		public function get imageFileType():String {
			return config.imageFile.@type;
		}
		
		public function get imageFileQuality():int {
			return int(config.imageFile.@quality);
		}
	}

}