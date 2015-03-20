package mirrorScreen 
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
		static private var _instance:Configuration;
		
		public function Configuration() 
		{
			file = File.applicationDirectory.resolvePath(CONFIG_FILE_PATH);
			read();
		}
		
		public static function getInstance():Configuration {
			if (_instance == null) {
				_instance = new Configuration();
			}
			return _instance;
		}
		
		private function read():void {
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			config = XML(fs.readUTFBytes(fs.bytesAvailable));
			fs.close();
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
		
		public function get themeWidth():int {
			return int(config.theme.@width);
		}
		
		public function get themeHeight():int {
			return int(config.theme.@height);
		}
	}

}