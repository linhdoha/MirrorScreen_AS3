package com.nidlab.kinect
{
	import com.nidlab.utils.ColorStyle;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class SkeletonDisplayer extends Sprite 
	{
		//public static const SNAP_COMMAND_EVENT:String = "snapCommandEvent";
		
		private var _trackingID:Number;
		private var color:uint;
		private var _leftHand:Hand;
		private var _rightHand:Hand;
		private var _debugMode:Boolean = false;
		/*private var _leftHandEffect:BaseEffect;
		private var _rightHandEffect:BaseEffect;*/
		public function SkeletonDisplayer() 
		{
			super();
			color = ColorStyle.getInstance().randomColor();
			_leftHand = new Hand(color);
			addChild(_leftHand);
			_rightHand = new Hand(color);
			addChild(_rightHand);
			
			/*_leftHandEffect = new FireEffect();
			_leftHandEffect.depth = _leftHand.depth;
			_leftHandEffect.followee = _leftHand;
			addChild(_leftHandEffect);
			
			_rightHandEffect = new FireEffect();
			_rightHandEffect.depth = _rightHand.depth;
			_rightHandEffect.followee = _rightHand;
			addChild(_rightHandEffect);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);*/
		}
		
		/*private function onEnterFrame(e:Event):void 
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
		
		public function get debugMode():Boolean 
		{
			return _debugMode;
		}
		
		public function set debugMode(value:Boolean):void 
		{
			_debugMode = value;
			
			if (_debugMode) {
				_leftHand.graphics.lineStyle(4, 0x00FFFF, 0.8);
				_leftHand.graphics.drawCircle(0, 0, 80);
				_rightHand.graphics.lineStyle(4, 0x00FFFF, 0.8);
				_rightHand.graphics.drawCircle(0, 0, 80);
			} else {
				_leftHand.graphics.clear();
				_rightHand.graphics.clear();
			}
		}
	}

}