package com.nidlab.fx 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import mirrorScreen.themes.fireMirror.FSprite;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class FireEffect extends BaseEffect 
	{
		private var a:Array = new Array();
		private var i:int;
		public function FireEffect() 
		{
			super();
			this.filters = [new BlurFilter(8, 16, 1)];
		}
		
		public override function set followee(value:DisplayObject):void {
			super.followee = value;
		}
		
		public override function draw():void {
			super.draw();
			if (isRunning) {
				for(i=0;i<1;i++) {
					var s:FSprite = new FSprite();
					s.alpha = Math.random()*0.5+0.5;
					s.graphics.beginFill((Math.random()*0xffffff)&0x00FF00);
					var rnd:Number = (Math.random() * 20 + 10)/depth;
					s.graphics.drawCircle(0,0,rnd);
					s.graphics.endFill();
					s.blendMode = "add";
					this.addChild(s);
					s.x = followee.x + (Math.random()*20-10)/depth;
					s.y = followee.y + (Math.random()*20-10)/depth;
					a.push(s);
				}
			}
			
			
			for(i=0;i<a.length;i++){
				a[i].x += Math.random()*2-1;
				a[i].y -= 5;
				a[i].alpha -= 0.02;
				a[i].scaleX -= 0.02;
				a[i].scaleY -= 0.02;
				if(a[i].alpha<=0){
					this.removeChild(a[i]);
					a.splice(i,1);
				}
			}
		}
	}

}