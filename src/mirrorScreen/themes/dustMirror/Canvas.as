package mirrorScreen.themes.dustMirror 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Canvas extends Sprite 
	{
		private var lines:Vector.<Line> = new Vector.<Line>;
		public function Canvas() 
		{
			super();
			graphics.lineStyle(2, 0xFF0000, 0);
			graphics.drawRect(0,0,1920,1080);
		}
		
		private function startDrawLine():uint {
			var lineTemp:Line = new Line();
			return (lines.push(lineTemp)-1);
			
		}
		
		private function lineTo(point:Point, lineId:uint):void {
			if (lines[lineId] != null) {
				lines[lineId].addPoint(point);
			}
		}
		
		public function interact(handPointer:HandPointer, position:Point,pressure:int=10):void {
			
			var currentLine:Line;
			for each(var line:Line in lines) {
				if (line.handPointer.bodyId == handPointer.bodyId && line.handPointer.hand == handPointer.hand && line.isCompleted == false) {
					currentLine = line;
				}
			}
			
			if (currentLine && currentLine.size == pressure) {
				currentLine.addPoint(position);
			} else {
				var newLine:Line = new Line();
				lines.push(newLine);
				newLine.handPointer = handPointer;
				newLine.size = pressure;
				newLine.addPoint(position);
				addChild(newLine);
			}
		}
		
		public function release(handPointer:HandPointer):void {
			var currentLine:Line;
			for each(var line:Line in lines) {
				if (line.handPointer.bodyId == handPointer.bodyId && line.handPointer.hand == handPointer.hand && line.isCompleted == false) {
					currentLine = line;
				}
			}
			
			if (currentLine) {
				currentLine.isCompleted = true;
			}
		}
	}

}