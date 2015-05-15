package com.nidlab.kinect 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class GestureEvent extends Event 
	{
		private var _trackingID:Number;
		private var _gestureName:String;
		private var _progress:Number;
		
		public function GestureEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, trackingID:Number = -1, gestureName:String="", progress:Number=0) 
		{ 
			super(type, bubbles, cancelable);
			_trackingID = trackingID;
			_gestureName = gestureName;
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
		
		public function get gestureName():String 
		{
			return _gestureName;
		}
		
		public function get trackingID():Number 
		{
			return _trackingID;
		}
		
	}
	
}