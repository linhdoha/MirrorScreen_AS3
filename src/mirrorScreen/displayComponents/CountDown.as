package mirrorScreen.displayComponents 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class CountDown extends CountDownView 
	{
		public static const COUNT_COMPLETED:String = "countCompleted";
		public function CountDown() 
		{
			super();
			reset();
		}
		
		public function reset():void {
			visible = false;
			stop();
		}
		
		public function start():void {
			gotoAndPlay(1);
			visible = true;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) {
				reset();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				dispatchEvent(new Event(COUNT_COMPLETED));
			}
		}
		
	}

}