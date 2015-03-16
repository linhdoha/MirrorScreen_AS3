package mirrorScreen.displayComponents 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class FlickrBitmap extends Bitmap 
	{
		private var _white:int = 0;
		public function FlickrBitmap(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false) 
		{
			super(bitmapData, pixelSnapping, smoothing);
			
		}
		
		public function get white():int 
		{
			return _white;
		}
		
		public function set white(value:int):void 
		{
			_white = value;
			transform.colorTransform = new ColorTransform(1, 1, 1, 1, value, value, value, 0);
		}
		
	}

}