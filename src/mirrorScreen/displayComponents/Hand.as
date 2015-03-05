package mirrorScreen.displayComponents 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Hand extends Sprite 
	{
		private var _state:Number;
		private var _pos:Point;
		private var _depth:Number;
		
		public function Hand(color:uint) 
		{
			super();
			//graphics.lineStyle(4, 0x00FFFF, 0.8);
			//graphics.drawCircle(0, 0, 100);
		}
		
		public function get state():Number 
		{
			return _state;
		}
		
		public function set state(value:Number):void 
		{
			_state = value;
		}
		
		public function get pos():Point 
		{
			return _pos;
		}
		
		public function set pos(value:Point):void 
		{
			_pos = value;
			x = _pos.x;
			y = _pos.y;
		}
		
		public function get depth():Number 
		{
			if (isNaN(_depth)) {
				_depth = 1;
			}
			return _depth;
		}
		
		public function set depth(value:Number):void 
		{
			_depth = value;
		}
		
	}

}