package mirrorScreen.displayComponents 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class CountDown extends CountDownView 
	{
		
		public function CountDown() 
		{
			super();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			reset();
		}
		
		public function reset():void {
			visible = false;
			stop();
		}
		
		public function start():void {
			gotoAndPlay(1);
			visible = true;
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) {
				reset();
			}
		}
		
	}

}