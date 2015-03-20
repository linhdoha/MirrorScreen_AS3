package mirrorScreen.displayComponents 
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class FlickrBitmap extends Bitmap 
	{
		public static const FLICKR_COMPLETED:String = "flickrComplete";
		private var _white:int = 0;
		private var timeline:TimelineLite;
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
		
		public function flickr():void {
			timeline = new TimelineLite({onComplete:onFlickrComplete});
			timeline.append(new TweenLite(this, 0.2, { white:255 } ));
			timeline.append(new TweenLite(this, 1, { white:0 } ));
		}
		
		private function onFlickrComplete():void {
			dispatchEvent(new Event(FLICKR_COMPLETED));
		}
	}

}