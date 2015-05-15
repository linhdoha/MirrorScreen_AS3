package com.nidlab.kinect 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class GestureEvent extends Event 
	{
		private var _progress:Number;
		
		public function GestureEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, progress:Number=0) 
		{ 
			super(type, bubbles, cancelable);
			_progress = progress;
		} 
		
		public override function clone():Event 
		{ 
			return new GestureEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GestureEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get progress():Number 
		{
			return _progress;
		}
		
	}
	
}