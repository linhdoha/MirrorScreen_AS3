package mirrorScreen.themes.dustMirror 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Canvas extends Sprite 
	{
		private var pts:Array = new Array();
		private var canvas:Sprite;
		public function Canvas() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			
			var anchor:Point = new Point(mouseX, mouseY);
			pts.push(anchor);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			var anchor:Point = new Point(mouseX, mouseY);
			pts.push(anchor);
			draw();
		}
		
		private function draw():void {
			var g:Graphics = canvas.graphics;
			g.clear();
			var prevMidpt:Point = null;
			var l:Number = pts.length;
			for (var i:Number=1;i<l;i++) {
				var pt1:Point = pts[i-1];
				var pt2:Point = pts[i];
				
				// draw the straight lines:
				//g.lineStyle(0,0xBBBBBB,0.6);
				//g.moveTo(pt1.x,pt1.y);
				//g.lineTo(pt2.x,pt2.y);
				
				// draw the bisection:
				//g.lineStyle(0,0xBBBBBB,0.5);
				var midpt:Point = new Point(pt1.x+(pt2.x-pt1.x)/2,pt1.y+(pt2.y-pt1.y)/2);
				//var a:Number = Math.atan2(pt2.y-pt1.y,pt2.x-pt1.x);
				//g.moveTo(midpt.x+Math.cos(a+Math.PI/2)*8,midpt.y+Math.sin(a+Math.PI/2)*8);
				//g.lineTo(midpt.x-Math.cos(a+Math.PI/2)*8,midpt.y-Math.sin(a+Math.PI/2)*8);
				
				// draw the curves:
				g.lineStyle(2,0x66FFFF,1);
				if (prevMidpt) {
					g.moveTo(prevMidpt.x,prevMidpt.y);
					g.curveTo(pt1.x,pt1.y,midpt.x,midpt.y);
				} else {
					// draw start segment:
					g.moveTo(pt1.x,pt1.y);
					g.lineTo(midpt.x,midpt.y);
				}
				prevMidpt = midpt;
			}
			// draw end segment:
			g.lineTo(pt2.x,pt2.y);
		}
	}

}