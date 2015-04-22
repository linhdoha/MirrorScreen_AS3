package mirrorScreen.themes.dustMirror 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class BrushPointer extends EventDispatcher 
	{
		public static const UPDATE_POSITION:String = "updatePosition";
		private var _x:Number;
		private var _y:Number;
		
		public function BrushPointer() 
		{
			
		}
		
		public function get x():Number 
		{
			return _x;
		}
		
		public function set x(value:Number):void 
		{
			_x = value;
			dispatchEvent(new Event(UPDATE_POSITION));
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function set y(value:Number):void 
		{
			_y = value;
			dispatchEvent(new Event(UPDATE_POSITION));
		}
		
		
	}

}