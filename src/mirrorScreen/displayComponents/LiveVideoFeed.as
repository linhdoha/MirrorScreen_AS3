package mirrorScreen.displayComponents 
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class LiveVideoFeed extends Sprite 
	{
		public static const URL_LOADER_MODE:String = "urlLoaderMode";
		public static const BYTES_LOADER_MODE:String = "bytesLoaderMode";
		public static const BYTES_LOAD_COMPLETED:String = "bytesLoadCompleted";
		
		private var _url:String;
		private var loader1:Loader;
		private var loader2:Loader;
		private var isLoader1Viewing:Boolean = false;
		private var _mode:String = URL_LOADER_MODE;
		public function LiveVideoFeed() 
		{
			super();
			loader1 = new Loader();
			loader1.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			loader1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			addChild(loader1);
			
			loader2 = new Loader();
			loader2.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			loader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			addChild(loader2);
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			if (mode == URL_LOADER_MODE) {
				Loader(getChildAt(0)).load(new URLRequest(_url));
			} else if (mode == BYTES_LOADER_MODE) {
				dispatchEvent(new Event(BYTES_LOAD_COMPLETED));
			}
			
		}
		
		private function onLoaderComplete(e:Event):void 
		{
			// đưa lên trên
			swapChildren(LoaderInfo(e.currentTarget).loader, getChildAt(1));
			
			if (mode == URL_LOADER_MODE) {
				Loader(getChildAt(0)).load(new URLRequest(_url));
			} else if (mode == BYTES_LOADER_MODE) {
				dispatchEvent(new Event(BYTES_LOAD_COMPLETED));
			}
		}
		
		public function get url():String 
		{
			return _url;
		}
		
		public function set url(value:String):void 
		{
			_url = value;
			mode = URL_LOADER_MODE;
			Loader(getChildAt(0)).load(new URLRequest(_url));
		}
		
		
		public function set bytes(b:ByteArray):void {
			mode = BYTES_LOADER_MODE;
			Loader(getChildAt(0)).loadBytes(b);
		}
		
		public function get mode():String 
		{
			return _mode;
		}
		
		public function set mode(value:String):void 
		{
			_mode = value;
		}
		
	}

}