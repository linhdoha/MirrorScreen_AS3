package mirrorScreen 
{
	import flash.utils.ByteArray;
	
	public class Workers
	{
		
		[Embed(source="../../workerswfs/MirrorScreenSaveImageWorkersAS3.swf", mimeType="application/octet-stream")]
		private static var SaveImageWorker_ByteClass:Class;
		public static function get SaveImageWorker():ByteArray
		{
			return new SaveImageWorker_ByteClass();
		}
		
	}

}