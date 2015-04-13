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
		private var _bodyData:*;
		private var _bodyDataOld:*;
		
		public function BodyDataReader()
		{
		
		}
		
		public function set data(s:String):void
		{
			trace(s);
			var dataObject:Object;
			try
			{
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
			}
			catch (e:Error)
			{
				trace(e.message);
				trace(s);
			}
		}
		
		private function processData():void
		{
			if (_bodyData.bodies.length != 0)
			{
				if (_bodyDataOld == null || _bodyDataOld.bodies.length == 0)
				{
					for (var o:int = 0; o < bodyCount; o++)
					{
						dispatchEvent(new BodyEvent(ON_BODY_ADDED, false, false, _bodyData.bodies[o].trackingID));
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
			}
		
		}
		
		public function get bodyCount():int
		{
			return int(_bodyData.bodies.length);
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