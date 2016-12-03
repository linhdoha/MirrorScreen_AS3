package mirrorScreen 
{
	import com.nidlab.kinect.BodyDataReader;
	import com.nidlab.kinect.constant.Joints;
	import com.nidlab.kinect.GestureEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class CommandDetector extends EventDispatcher
	{
		public static const ON_SNAP_COMMAND:String = "onSnapCommand";
		
		private var _bodyDataReader:BodyDataReader;
		public function CommandDetector() 
		{
			
		}
		
		public function get bodyDataReader():BodyDataReader 
		{
			return _bodyDataReader;
		}
		
		public function set bodyDataReader(value:BodyDataReader):void 
		{
			_bodyDataReader = value;
			_bodyDataReader.addEventListener(BodyDataReader.DATA_CHANGED, onDataChange);
			_bodyDataReader.addEventListener(BodyDataReader.ON_GESTURE_END, onGestureEvent);
		}
		
		private function onGestureEvent(e:GestureEvent):void 
		{
			trace("Gesture: " + e.gestureName +" progress: " + e.progress);
			switch (e.gestureName) {
				case "TakeSnap":
					var leftHandOverHead:Boolean = _bodyDataReader.getJoint3DPos(e.trackingID, Joints.HEAD).y < _bodyDataReader.getJoint3DPos(e.trackingID, Joints.THUMB_LEFT).y ;
					var rightHandOverHead:Boolean = _bodyDataReader.getJoint3DPos(e.trackingID, Joints.HEAD).y < _bodyDataReader.getJoint3DPos(e.trackingID, Joints.THUMB_RIGHT).y ;
					var leftHandRaising:Boolean = _bodyDataReader.getJoint3DPos(e.trackingID, Joints.SPINE_MID).z - _bodyDataReader.getJoint3DPos(e.trackingID, Joints.WRIST_LEFT).z >= 0.2 ;
					var rightHandRaising:Boolean = _bodyDataReader.getJoint3DPos(e.trackingID, Joints.SPINE_MID).z - _bodyDataReader.getJoint3DPos(e.trackingID, Joints.WRIST_RIGHT).z >= 0.2 ;
					
					if (!leftHandOverHead && !rightHandOverHead && leftHandRaising && rightHandRaising) {
						dispatchEvent(new Event(ON_SNAP_COMMAND));
					}
					break;
				
				case "WaveHand":
					dispatchEvent(new Event(ON_SNAP_COMMAND));
					break;
			}
		}
		
		private function onDataChange(e:Event):void 
		{
			
			/*//snap command
			for (var i:int = 0; i < _bodyDataReader.bodyCount; i++ ) {
				if (_bodyDataReader.getLeftHandStateByIndex(i) == 4 && _bodyDataReader.getRightHandStateByIndex(i) == 4) {
					dispatchEvent(new Event(ON_SNAP_COMMAND));
					break;
				}
			}*/
			
			
		}
	}

}