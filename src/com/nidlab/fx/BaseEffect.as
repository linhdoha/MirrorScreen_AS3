package com.nidlab.fx 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class BaseEffect extends Sprite 
	{
		private var _isRunning:Boolean = false;
		private var _followee:DisplayObject;
		private var _depth:Number = 1;
		public function BaseEffect() 
		{
			super();
			
		}
		
		public function get isRunning():Boolean 
		{
			return _isRunning;
		}
		
		public function set isRunning(value:Boolean):void 
		{
			if (_followee != null) {
				_isRunning = value;
			}
		}
		
		public function get followee():DisplayObject 
		{
			return _followee;
		}
		
		public function set followee(value:DisplayObject):void 
		{
			_followee = value;
			_isRunning = true;
			this.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		public function set depth(value:Number):void {
			_depth = value;
		}
		
		public function get depth():Number 
		{
			return _depth;
		}
		
		private function onFrame(e:Event):void 
		{
			draw();
		}
		
		public function draw():void {
			
		}
	}

}