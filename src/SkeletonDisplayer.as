package 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class SkeletonDisplayer extends Sprite 
	{
		private var _trackingID:Number;
		private var _leftHandState:Number;
		private var _leftHandPos:Point;
		private var _leftHandDepth:Number;
		private var _rightHandState:Number;
		private var _rightHandPos:Point;
		private var _rightHandDepth:Number;
		private var color:uint;
		private var leftHand:Hand;
		private var rightHand:Hand;
		public function SkeletonDisplayer() 
		{
			super();
			color = ColorStyle.getInstance().randomColor();
			leftHand = new Hand(color);
			addChild(leftHand);
			rightHand = new Hand(color);
			addChild(rightHand);
		}
		
		public function get trackingID():Number 
		{
			return _trackingID;
		}
		
		public function set trackingID(value:Number):void 
		{
			_trackingID = value;
		}
		
		public function get leftHandState():Number 
		{
			return _leftHandState;
		}
		
		public function set leftHandState(value:Number):void 
		{
			_leftHandState = value;
		}
		
		public function get leftHandPos():Point 
		{
			return _leftHandPos;
		}
		
		public function set leftHandPos(value:Point):void 
		{
			_leftHandPos = value;
			leftHand.x = _leftHandPos.x;
			leftHand.y = _leftHandPos.y;
		}
		
		public function get leftHandDepth():Number 
		{
			return _leftHandDepth;
		}
		
		public function set leftHandDepth(value:Number):void 
		{
			_leftHandDepth = value;
		}
		
		public function get rightHandState():Number 
		{
			return _rightHandState;
		}
		
		public function set rightHandState(value:Number):void 
		{
			_rightHandState = value;
		}
		
		public function get rightHandPos():Point 
		{
			return _rightHandPos;
		}
		
		public function set rightHandPos(value:Point):void 
		{
			_rightHandPos = value;
			rightHand.x = _rightHandPos.x;
			rightHand.y = _rightHandPos.y;
		}
		
		public function get rightHandDepth():Number 
		{
			return _rightHandDepth;
		}
		
		public function set rightHandDepth(value:Number):void 
		{
			_rightHandDepth = value;
		}
		
		
		
	}

}