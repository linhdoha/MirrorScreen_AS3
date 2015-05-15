package com.nidlab.kinect
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class BodyDataReader extends EventDispatcher
	{
		public static const DATA_CHANGED:String = "dataChanged";
		public static const ON_BODY_ADDED:String = "onBodyAdded";
		public static const ON_BODY_UPDATED:String = "onBodyUpdated";
		public static const ON_BODY_REMOVED:String = "onBodyRemoved";
		public static const ON_GESTURE_EVENT:String = "onGestureEvent";
		private var _bodyData:*;
		private var _bodyDataOld:*;
		
		public function BodyDataReader()
		{
		
		}
		
		public function set data(s:String):void
		{
			var dataObject:Object;
			//try
			//{
				dataObject = JSON.parse(s);
				if (dataObject.command == "bodyData")
				{
					_bodyData = dataObject;
					
					processData();
					dispatchEvent(new Event(DATA_CHANGED));
					_bodyDataOld = _bodyData;
				}
				else
				{
					trace("Wrong BodyData: " + dataObject.command);
				}
			//}
			//catch (e:Error)
			//{
				//trace(e.message);
				//trace(s);
			//}
		}
		
		private function processData():void
		{
			checkGesture();
			checkNewBody();
			checkUpdateBody();
			checkRemoveBody();
			
			/*if (_bodyData.bodies.length > 0)
			{
				for each (var body:Object in _bodyData.bodies) {
					for each (var gesture:Object in body.gesture) {
						trace("GESTURE: " + gesture.name+" progress: " + gesture.progress);
					}
				}
				
				// nếu trước đó không có dữ liệu gì thì _bodyData toàn là người mới
				if (_bodyDataOld == null || _bodyDataOld.bodies.length == 0)
				{
					for each (var body2:Object in _bodyData.bodies) {
						dispatchEvent(new BodyEvent(ON_BODY_ADDED, false, false, body2.trackingID));
					}
				}
				else
				{
					
					//phát hiện người mới
					for (var i:int = 0; i < bodyCount; i++)
					{
						var found:Boolean = false;
						for (var j:int = 0; j < _bodyDataOld.bodies.length; j++)
						{
							if (_bodyData.bodies[i].trackingID == _bodyDataOld.bodies[j].trackingID)
							{
								found = true;
							}
						}
						
						if (!found)
						{
							dispatchEvent(new BodyEvent(ON_BODY_ADDED, false, false, _bodyData.bodies[i].trackingID));
						}
					}
					
					//phát hiện người được cập nhật
					for (var m:int = 0; m < _bodyDataOld.bodies.length; m++)
					{
						var found2:Boolean = false;
						for (var n:int = 0; n < bodyCount; n++)
						{
							if (_bodyDataOld.bodies[m].trackingID == _bodyData.bodies[n].trackingID)
							{
								found2 = true;
							}
						}
						
						if (!found2)
						{
							dispatchEvent(new BodyEvent(ON_BODY_REMOVED, false, false, _bodyDataOld.bodies[m].trackingID));
						}
						else
						{
							dispatchEvent(new BodyEvent(ON_BODY_UPDATED, false, false, _bodyDataOld.bodies[m].trackingID));
						}
					}
					
				}
			} else if (_bodyData.bodies.length == 0 && _bodyDataOld != null && _bodyDataOld.bodies.length !=0) {
				for (var p:int = 0; p < _bodyDataOld.bodies.length; p++ ) {
					dispatchEvent(new BodyEvent(ON_BODY_REMOVED, false, false, _bodyDataOld.bodies[p].trackingID));
				}
			}*/
		
		}
		
		public function get bodyCount():int
		{
			return int(_bodyData.bodies.length);
		}
		
		private function checkGesture():void {
			if (_bodyData.bodies.length > 0) {
				for each (var body:Object in _bodyData.bodies) {
					for each (var gesture:Object in body.gesture) {
						dispatchEvent(new GestureEvent(ON_GESTURE_EVENT, false, false, body.trackingID, gesture.name, gesture.progress));
					}
				}
			}
		}
		
		private function checkNewBody():void {
			if (_bodyData.bodies.length > 0) {
				if (_bodyDataOld == null || _bodyDataOld.bodies.length == 0) {
					for each (var bodyInNew:Object in _bodyData.bodies) {
						dispatchEvent(new BodyEvent(ON_BODY_ADDED, false, false, bodyInNew.trackingID));
					}
				} else {
					for each (var bodyInNew2:Object in _bodyData.bodies) {
						var found:Boolean = false;
						for each (var bodyInOld2:Object in _bodyDataOld.bodies) {
							if (bodyInNew2.trackingID == bodyInOld2.trackingID) found = true;
						}
						
						if (!found) dispatchEvent(new BodyEvent(ON_BODY_ADDED, false, false, bodyInNew2.trackingID));
					}
				}
			}
		}
		
		private function checkUpdateBody():void {
			if (_bodyData.bodies.length > 0 && _bodyDataOld && _bodyDataOld.bodies.length > 0) {
				for each (var bodyInNew:Object in _bodyData.bodies) {
					for each (var bodyInOld:Object in _bodyDataOld.bodies) {
						if (bodyInNew.trackingID == bodyInOld.trackingID) {
							dispatchEvent(new BodyEvent(ON_BODY_UPDATED, false, false, bodyInOld.trackingID));
							break;
						}
					}
				}
			}
		}
		
		private function checkRemoveBody():void {
			if (_bodyData.bodies.length == 0 && _bodyDataOld != null && _bodyDataOld.bodies.length >0) {
				for each (var bodyInOld:Object in _bodyDataOld.bodies) {
					dispatchEvent(new BodyEvent(ON_BODY_REMOVED, false, false, bodyInOld.trackingID));
				}
			} else if (_bodyData.bodies.length > 0 && _bodyDataOld != null && _bodyDataOld.bodies.length > 0) {
				for each (var bodyInOld2:Object in _bodyDataOld.bodies) {
					var found:Boolean = false;
					for each (var bodyInNew:Object in _bodyData.bodies) {
						if (bodyInOld2.trackingID == bodyInNew.trackingID) found = true;
					}
					
					if (!found) dispatchEvent(new BodyEvent(ON_BODY_REMOVED, false, false, bodyInOld2.trackingID));
				}
			}
		}
		
		public function getTrackingIDAt(index:int):Number
		{
			var _trackingID:Number = -1;
			
			if (_bodyData.bodies[index] != null)
			{
				_trackingID = _bodyData.bodies[index].trackingID;
			}
			return _trackingID;
		}
		
		public function getIndexByTrackingID(trackingID:Number):int {
			var returnVal:int = -1;
			if (_bodyData) {
				for (var i:int = 0; i < _bodyData.bodies.length; i++) {
					if (trackingID == _bodyData.bodies[i].trackingID) {
						returnVal = i;
					}
				}
			}
			return returnVal;
		}
		
		public function getLeftHandStateByIndex(index:int):int
		{
			var returnVal:int = -1;
			if (_bodyData.bodies[index] != null)
			{
				returnVal = _bodyData.bodies[index].handLeftState;
			}
			return returnVal;
		}
		
		public function getRightHandStateByIndex(index:int):int
		{
			var returnVal:int = -1;
			if (_bodyData.bodies[index] != null)
			{
				returnVal = _bodyData.bodies[index].handRightState;
			}
			return returnVal;
		}
		
		public function getLeftHandState(trackingID:Number):int {
			return getLeftHandStateByIndex(getIndexByTrackingID(trackingID));
		}
		
		public function getRightHandState(trackingID:Number):int {
			return getRightHandStateByIndex(getIndexByTrackingID(trackingID));
		}
		
		public function getJoint3DPosByIndex(index:int, joint:String):Vector3D
		{
			var returnVal:Vector3D = new Vector3D();
			
			if (_bodyData.bodies[index] != null)
			{
				for (var i:int = 0; i < _bodyData.bodies[index].joints.length; i++)
				{
					if (_bodyData.bodies[index].joints[i].name == joint)
					{
						returnVal.x = _bodyData.bodies[index].joints[i].X;
						returnVal.y = _bodyData.bodies[index].joints[i].Y;
						returnVal.z = _bodyData.bodies[index].joints[i].z;
					}
				}
			}
			
			return returnVal;
		}
		
		public function getJoint3DPos(trackingID:Number, joint:String):Vector3D {
			return getJoint3DPosByIndex(getIndexByTrackingID(trackingID),joint);
		}
		
		public function getJointMappedPosByIndex(index:int, joint:String):Point
		{
			var returnVal:Point = new Point();
			
			if (_bodyData.bodies[index] != null)
			{
				for (var i:int = 0; i < _bodyData.bodies[index].joints.length; i++)
				{
					if (_bodyData.bodies[index].joints[i].name == joint)
					{
						returnVal.x = _bodyData.bodies[index].joints[i].mappedX;
						returnVal.y = _bodyData.bodies[index].joints[i].mappedY;
					}
				}
			}
			
			return returnVal;
		}
		
		public function getJointMappedPos(trackingID:Number, joint:String):Point {
			return getJointMappedPosByIndex(getIndexByTrackingID(trackingID), joint);
		}
	}

}