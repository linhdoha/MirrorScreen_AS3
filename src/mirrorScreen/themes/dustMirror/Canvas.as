package mirrorScreen.themes.dustMirror 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Canvas extends Sprite 
	{
		private var brushList:Vector.<BrushPointer> = new Vector.<BrushPointer>;
		public function Canvas() 
		{
			super();
			
		}
		
		public function addNewBrushPointer():int {
			var brushPointerTemp:BrushPointer = new BrushPointer();
			brushList.push(brushPointerTemp);
			
		}
		
	}

}