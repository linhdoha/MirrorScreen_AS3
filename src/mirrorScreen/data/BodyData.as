package mirrorScreen.data 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class BodyData extends EventDispatcher
	{
		public static const DATA_CHANGED:String = "dataChange";
		private var _bodyData:*;
		
		public function BodyData() 
		{
			
		}
		
		public function getSkeletonDataByTrackingID(trackingID:Number):void {
			
		}
		
		public function set data(s:String):void {
			try {
				_bodyData = JSON.parse(s);
				if ((_bodyData.BodyCount == 6) && (_bodyData.SkeletonList.length == 6)) {
					dispatchEvent(new Event(DATA_CHANGED));
				} else {
					trace("BodyData parse failed!");
				}
			} catch (e:Error) {
				trace("BodyData parse failed!");
				trace(e.message);
			}
		}
		
		public function get bodyCount():int {
			return int(_bodyData.BodyCount);
		}
		
		public function getLeftHandStateAt(i:int):Number {
			var _leftHandState:Number = -1;
			
			if (_bodyData.SkeletonList[i] != null) {
				_leftHandState = _bodyData.SkeletonList[i].HandLeftState;
			}
			
			return _leftHandState;
		}
		
		public function getLeftHandPosAt(i:int):Point {
			var _leftHandPos:Point = new Point();
			
			if (_bodyData.SkeletonList[i] != null) {
				_leftHandPos = new Point(_bodyData.SkeletonList[i].LeftHandPos.X, _bodyData.SkeletonList[i].LeftHandPos.Y);
			}
			
			return _leftHandPos;
		}
		
		public function getLeftHandDepthAt(i:int):Number {
			var _leftHandDepth:Number = -1;
			
			if (_bodyData.SkeletonList[i] != null) {
				_leftHandDepth = _bodyData.SkeletonList[i].LeftHandPos.Z;
			}
			
			return _leftHandDepth;
		}
		
		public function getRightHandStateAt(i:int):Number {
			var _rightHandState:Number = -1;
			
			if (_bodyData.SkeletonList[i] != null) {
				_rightHandState = _bodyData.SkeletonList[i].HandRightState;
			}
			
			return _rightHandState;
		}
		
		public function getRightHandPosAt(i:int):Point {
			var _rightHandPos:Point = new Point();
			
			if (_bodyData.SkeletonList[i] != null) {
				_rightHandPos = new Point(_bodyData.SkeletonList[i].RightHandPos.X, _bodyData.SkeletonList[i].RightHandPos.Y);
			}
			
			return _rightHandPos;
		}
		
		public function getRightHandDepthAt(i:int):Number {
			var _rightHandDepth:Number = -1;
			
			if (_bodyData.SkeletonList[i] != null) {
				_rightHandDepth = _bodyData.SkeletonList[i].RightHandPos.Z;
			}
			
			return _rightHandDepth;
		}
		
		public function getTrackingIDAt(i:int):Number {
			var _trackingID:Number = -1;
			
			if (_bodyData.SkeletonList[i] != null) {
				_trackingID = _bodyData.SkeletonList[i].TrackingId;
			}
			
			return _trackingID;
		}
	}
	
	
	
}