package com.nidlab.kinect 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class BodyEvent extends Event 
	{
		private var _trackingID:Number;
		
		public function BodyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,trackingID:Number=-1) 
		{ 
			super(type, bubbles, cancelable);
			_trackingID = trackingID;
		} 
		
		public override function clone():Event 
		{ 
			return new BodyEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("BodyEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get trackingID():Number 
		{
			return _trackingID;
		}
		
	}
	
}