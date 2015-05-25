package mirrorScreen.themes.LEMirror 
{
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class HandPointer 
	{
		private var _bodyId:Number;
		private var _hand:Boolean;
		private var _isDrawing:Boolean = false;
		private var _pressure:int = 10;
		public function HandPointer(bodyId:Number, hand:Boolean) 
		{
			_bodyId = bodyId;
			_hand = hand;
		}
		
		public function get hand():Boolean 
		{
			return _hand;
		}
		
		public function set hand(value:Boolean):void 
		{
			_hand = value;
		}
		
		public function get bodyId():Number 
		{
			return _bodyId;
		}
		
		public function set bodyId(value:Number):void 
		{
			_bodyId = value;
		}
		
		public function get isDrawing():Boolean 
		{
			return _isDrawing;
		}
		
		public function set isDrawing(value:Boolean):void 
		{
			_isDrawing = value;
		}
		
		public function get pressure():int 
		{
			return _pressure;
		}
		
		public function set pressure(value:int):void 
		{
			_pressure = value;
		}
		
		
	}

}