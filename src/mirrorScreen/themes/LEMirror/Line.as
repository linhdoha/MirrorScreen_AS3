package mirrorScreen.themes.LEMirror 
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
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		public function addPoint(point:Point):void {
			pts.push({point:point, time:new Date().getTime()});
			/*if (pts.length>1) {
				draw();
			}*/
		}
		
		private function draw():void {
			var g:Graphics = canvas.graphics;
			g.clear();
			var prevMidpt:Point = null;
			var l:Number = pts.length;
			var mark:Number = -1;
			for (var i:Number=1;i<l;i++) {
				var pt1:Point = pts[i-1].point;
				var pt2:Point = pts[i].point;
				
				var midpt:Point = new Point(pt1.x+(pt2.x-pt1.x)/2,pt1.y+(pt2.y-pt1.y)/2);
				
				var d:Number = new Date().getTime() - pts[i].time;
				var a:Number = 0;
				if (d <= 5000) {
					a = -0.0002 * d + 1;
				} else {
					mark = i;
				}
				
				g.lineStyle(_size,0xFFFFFF,a);
				
				
				if (prevMidpt) {
					g.moveTo(prevMidpt.x,prevMidpt.y);
					g.curveTo(pt1.x,pt1.y,midpt.x,midpt.y);
				} else {
					g.moveTo(pt1.x,pt1.y);
					g.lineTo(midpt.x,midpt.y);
				}
				prevMidpt = midpt;
			}
			
			if (mark != -1) {
				pts = pts.slice(mark + 1);
			}
			
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
		
		private function onFrame(e:Event):void 
		{
			if (new Date().getTime() - pts[pts.length - 1].time > 5000) {
				canvas.graphics.clear();
				removeEventListener(Event.ENTER_FRAME, onFrame);
			} else {
				if (pts.length>1) {
					draw();
				}
			}
			
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