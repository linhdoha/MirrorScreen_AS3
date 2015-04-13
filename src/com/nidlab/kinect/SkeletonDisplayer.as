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
		
		private var _trackingID:Number;
		private var color:uint;
		private var _leftHand:Hand;
		private var _rightHand:Hand;
		private var _debugMode:Boolean = false;
		
		public function SkeletonDisplayer()
		{
			super();
			color = ColorStyle.getInstance().randomColor();
			_leftHand = new Hand(color);
			addChild(_leftHand);
			_rightHand = new Hand(color);
			addChild(_rightHand);
			
			_leftHand.graphics.lineStyle(4, 0x00FFFF, 0.8);
			_leftHand.graphics.drawCircle(0, 0, 80);
			_rightHand.graphics.lineStyle(4, 0x00FFFF, 0.8);
			_rightHand.graphics.drawCircle(0, 0, 80);
		}
		
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
		
		/*public function get debugMode():Boolean
		{
			return _debugMode;
		}
		
		public function set debugMode(value:Boolean):void
		{
			_debugMode = value;
			
			if (_debugMode)
			{
				_leftHand.graphics.lineStyle(4, 0x00FFFF, 0.8);
				_leftHand.graphics.drawCircle(0, 0, 80);
				_rightHand.graphics.lineStyle(4, 0x00FFFF, 0.8);
				_rightHand.graphics.drawCircle(0, 0, 80);
			}
			else
			{
				_leftHand.graphics.clear();
				_rightHand.graphics.clear();
			}
		}*/
	}

}