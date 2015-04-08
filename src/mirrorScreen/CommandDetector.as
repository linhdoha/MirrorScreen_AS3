package mirrorScreen 
{
	import com.nidlab.kinect.BodyDataReader;
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
		}
		
		private function onDataChange(e:Event):void 
		{
			
			//snap command
			for (var i:int = 0; i < _bodyDataReader.bodyCount; i++ ) {
				if (_bodyDataReader.getLeftHandStateAt(i) == 4 && _bodyDataReader.getRightHandStateAt(i) == 4) {
					dispatchEvent(new Event(ON_SNAP_COMMAND));
					break;
				}
			}
			
			
		}
	}

}