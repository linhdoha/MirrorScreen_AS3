package com.nidlab.kinect 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class BodyDataReader extends EventDispatcher
	{
		public static const DATA_CHANGED:String = "dataChange";
		private var _bodyData:*;
		
		public function BodyDataReader() 
		{
			
		}
		
		public function set data(s:String):void {
			try {
				_bodyData = JSON.parse(s);
				if (_bodyData.command == "bodyData") {
					dispatchEvent(new Event(DATA_CHANGED));
				} else {
					trace("Wrong BodyData: "+_bodyData.command);
				}
			} catch (e:Error) {
				trace(e.message);
			}
		}
		
		public function get bodyCount():int {
			return int(_bodyData.bodies.length);
		}
		
		public function getBodyByTrackingID(trackingID:Number):Object {
			var bodyReturn:Object;
			for (var i:int; i < _bodyData.bodies.lenght; i++ ) {
				if (_bodyData.bodies[i].trackingID == trackingID) {
					bodyReturn = _bodyData.bodies[i];
				}
			}
			return bodyReturn;
		}
		
		public function getBodyAt(index:Number):Object {
			return _bodyData.bodies[index];
		}
		
		public function getTrackingIDAt(index:Number):Number {
			var _trackingID:Number = -1;
			
			if (_bodyData.bodies[index] != null) {
				_trackingID = _bodyData.bodies[index].trackingID;
			}
			return _trackingID;
		}
		
		public function getLeftHandStateAt(index:int):Number {
			var returnVal:Number = -1;
			if (_bodyData.bodies[index] != null) {
				returnVal = _bodyData.bodies[index].handLeftState;
			}
			return returnVal;
		}
		
		public function getRightHandStateAt(index:int):Number {
			var returnVal:Number = -1;
			if (_bodyData.bodies[index] != null) {
				returnVal = _bodyData.bodies[index].handRightState;
			}
			return returnVal;
		}
		
		public function getLeftHandPosAt(index:int):Point {
			var returnVal:Point = new Point();
			if (_bodyData.bodies[index] != null) {
				for (var i:int = 0; i < _bodyData.bodies[index].joints.length; i++ ) {
					if (_bodyData.bodies[index].joints[i].name == "handleft") {
						returnVal.x = _bodyData.bodies[index].joints[i].mappedX;
						returnVal.y = _bodyData.bodies[index].joints[i].mappedY;
					}
				}
			}
			return returnVal;
		}
		
		public function getRightHandPosAt(index:int):Point {
			var returnVal:Point = new Point();
			if (_bodyData.bodies[index] != null) {
				for (var i:int = 0; i < _bodyData.bodies[index].joints.length; i++ ) {
					if (_bodyData.bodies[index].joints[i].name == "handright") {
						returnVal.x = _bodyData.bodies[index].joints[i].mappedX;
						returnVal.y = _bodyData.bodies[index].joints[i].mappedY;
					}
				}
			}
			return returnVal;
		}
		
		public function getLeftHandDepthAt(index:int):Number {
			var returnVal:Number = -1;
			
			if (_bodyData.bodies[index] != null) {
				for (var i:int = 0; i < _bodyData.bodies[index].joints.length; i++ ) {
					if (_bodyData.bodies[index].joints[i].name == "handleft") {
						returnVal = _bodyData.bodies[index].joints[i].z;
					}
				}
			}
			
			return returnVal;
		}
		
		public function getRightHandDepthAt(index:int):Number {
			var returnVal:Number = -1;
			
			if (_bodyData.bodies[index] != null) {
				for (var i:int = 0; i < _bodyData.bodies[index].joints.length; i++ ) {
					if (_bodyData.bodies[index].joints[i].name == "handright") {
						returnVal = _bodyData.bodies[index].joints[i].z;
					}
				}
			}
			
			return returnVal;
		}
	}

}