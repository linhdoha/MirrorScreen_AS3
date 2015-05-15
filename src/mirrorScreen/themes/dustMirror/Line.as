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
	public class Line extends Sprite 
	{
		private var pts:Array = new Array();
		private var canvas:Sprite;
		private var _handPointer:HandPointer;
		private var _isCompleted:Boolean = false;
		private var _size:int = 10;
		public function Line() 
		{
			super();
			canvas = this;
		}
		
		public function addPoint(point:Point):void {
			pts.push(point);
			if (pts.length>1) {
				draw();
			}
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
				g.lineStyle(_size,0x66FFFF,1);
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
		
		public function get handPointer():HandPointer 
		{
			return _handPointer;
		}
		
		public function set handPointer(value:HandPointer):void 
		{
			_handPointer = value;
		}
		
		public function get isCompleted():Boolean 
		{
			return _isCompleted;
		}
		
		public function set isCompleted(value:Boolean):void 
		{
			_isCompleted = value;
		}
		
		public function get size():int 
		{
			return _size;
		}
		
		public function set size(value:int):void 
		{
			_size = value;
		}
	}

}