package 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Hand extends Sprite 
	{
		
		public function Hand(color:uint) 
		{
			super();
			graphics.beginFill(color);
			graphics.drawCircle(0, 0, 20);
			graphics.endFill();
		}
		
	}

}