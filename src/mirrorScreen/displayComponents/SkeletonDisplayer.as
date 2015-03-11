package mirrorScreen.displayComponents
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import mirrorScreen.displayComponents.Hand;
	import com.nidlab.fx.BaseEffect;
	import com.nidlab.fx.FireEffect;
	import com.nidlab.utils.ColorStyle;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class SkeletonDisplayer extends Sprite 
	{
		public static const SNAP_COMMAND_EVENT:String = "snapCommandEvent";
		
		private var _trackingID:Number;
		private var color:uint;
		private var _leftHand:Hand;
		private var _rightHand:Hand;
		private var _leftHandEffect:BaseEffect;
		private var _rightHandEffect:BaseEffect;
		public function SkeletonDisplayer() 
		{
			super();
			color = ColorStyle.getInstance().randomColor();
			_leftHand = new Hand(color);
			addChild(_leftHand);
			_rightHand = new Hand(color);
			addChild(_rightHand);
			
			_leftHandEffect = new FireEffect();
			_leftHandEffect.depth = _leftHand.depth;
			_leftHandEffect.followee = _leftHand;
			addChild(_leftHandEffect);
			
			_rightHandEffect = new FireEffect();
			_rightHandEffect.depth = _rightHand.depth;
			_rightHandEffect.followee = _rightHand;
			addChild(_rightHandEffect);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			//detect snap command
			if (_leftHand.state == 4 && _rightHand.state == 4) {
				dispatchEvent(new Event(SNAP_COMMAND_EVENT));
			}
			
			switch (_leftHand.state) {
				case 2:
					_leftHandEffect.isRunning = true;
					break;
				case 3:
					_leftHandEffect.isRunning = false;
					break;
			}
			
			switch (_rightHand.state) {
				case 2:
					_rightHandEffect.isRunning = true;
					break;
				case 3:
					_rightHandEffect.isRunning = false;
					break;
			}
			
			_leftHandEffect.depth = _leftHand.depth;
			_rightHandEffect.depth = _rightHand.depth;
			
			
			/*var r:int = 10;
			for (var i:int=0;i<3;i++) {
				var pointTemp:Point = Point.polar(Math.round(Math.random()*r),Math.round(Math.random()*2*Math.PI));
				pointTemp = pointTemp.add(new Point(Hand(e.currentTarget).x,Hand(e.currentTarget).y));
				var tpTemp:TailParticle = new TailParticle();
				tpTemp.addEventListener(TailParticle.ANIMATION_END, onTailAnimationEnd);
				tpTemp.x = pointTemp.x;
				tpTemp.y = pointTemp.y;
				this.addChild(tpTemp);
			}*/
		}
		
		/*private function onTailAnimationEnd(e:Event):void 
		{
			TailParticle(e.currentTarget).removeEventListener(TailParticle.ANIMATION_END, onTailAnimationEnd);
			removeChild(TailParticle(e.currentTarget));
		}*/
		
		public function get trackingID():Number 
		{
			return _trackingID;
		}
		
		public function set trackingID(value:Number):void 
		{
			_trackingID = value;
		}
		
		public function get leftHand():Hand 
		{
			return _leftHand;
		}
		
		public function get rightHand():Hand 
		{
			return _rightHand;
		}
	}

}