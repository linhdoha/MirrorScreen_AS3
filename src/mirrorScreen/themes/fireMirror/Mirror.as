package mirrorScreen.themes.fireMirror 
{
	import com.nidlab.fx.BaseEffect;
	import com.nidlab.fx.FireEffect;
	import com.nidlab.kinect.Hand;
	import flash.events.Event;
	import flash.geom.Point;
	import com.nidlab.kinect.KinectViewer;
	import com.nidlab.kinect.SkeletonDisplayer;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Mirror extends KinectViewer 
	{
		public static const SNAP_COMMAND_EVENT:String = "snapCommandEvent";
		private var effectLayer:Sprite;
		public function Mirror() 
		{
			super();
			debugMode = false;
			
			effectLayer = new Sprite();
			addChild(effectLayer);
		}
		
		override protected function addSkeletonDisplayer(trackingID:Number, lHandState:Number, lHandPos:Point, lHandDepth:Number, rHandState:Number, rHandPos:Point, rHandDepth:Number):SkeletonDisplayer 
		{
			var currentSkeleton:SkeletonDisplayer = super.addSkeletonDisplayer(trackingID, lHandState, lHandPos, lHandDepth, rHandState, rHandPos, rHandDepth);
			
			var _leftHandEffect:BaseEffect;
			var _rightHandEffect:BaseEffect;
			
			_leftHandEffect = new FireEffect();
			_leftHandEffect.depth = currentSkeleton.leftHand.depth;
			_leftHandEffect.followee = currentSkeleton.leftHand;
			effectLayer.addChild(_leftHandEffect);
			
			_rightHandEffect = new FireEffect();
			_rightHandEffect.depth = currentSkeleton.rightHand.depth;
			_rightHandEffect.followee = currentSkeleton.rightHand;
			effectLayer.addChild(_rightHandEffect);
			
			currentSkeleton.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			currentSkeleton.addEventListener(Mirror.SNAP_COMMAND_EVENT, onSnapCommandEvent);
			return currentSkeleton;
		}
		
		private function onSnapCommandEvent(e:Event):void 
		{
			dispatchEvent(new Event(Mirror.SNAP_COMMAND_EVENT));
		}
		
		private function onEnterFrame(e:Event):void 
		{
			var currentSkeleton:SkeletonDisplayer = SkeletonDisplayer(e.currentTarget);
			
			
			//detect snap command
			if (currentSkeleton.leftHand.state == 4 && currentSkeleton.rightHand.state == 4) {
				currentSkeleton.dispatchEvent(new Event(SNAP_COMMAND_EVENT));
			}
			
			switch (currentSkeleton.leftHand.state) {
				case 2:
					getEffectByFollowee(currentSkeleton.leftHand).isRunning = true;
					break;
				case 3:
					getEffectByFollowee(currentSkeleton.leftHand).isRunning = false;
					break;
			}
			
			switch (currentSkeleton.rightHand.state) {
				case 2:
					getEffectByFollowee(currentSkeleton.rightHand).isRunning = true;
					break;
				case 3:
					getEffectByFollowee(currentSkeleton.rightHand).isRunning = false;
					break;
			}
			
			getEffectByFollowee(currentSkeleton.leftHand).depth = currentSkeleton.leftHand.depth;
			getEffectByFollowee(currentSkeleton.rightHand).depth = currentSkeleton.rightHand.depth;
		}
		
		override protected function removeSkeletonDisplayer(index:int):SkeletonDisplayer 
		{
			var currentSkeleton:SkeletonDisplayer = skeletonDisplayerList[index];
			
			for (var i:int = effectLayer.numChildren-1; i >= 0; i--) {
				var currentEffect:BaseEffect = BaseEffect(effectLayer.getChildAt(i));
				if ((currentEffect.followee == currentSkeleton.leftHand) || (currentEffect.followee == currentSkeleton.rightHand)) {
					effectLayer.removeChild(currentEffect);
				}
			}
			
			currentSkeleton.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			currentSkeleton.removeEventListener(Mirror.SNAP_COMMAND_EVENT, onSnapCommandEvent);
			return super.removeSkeletonDisplayer(index);
		}
		
		private function getEffectByFollowee(followee:Hand):BaseEffect {
			var returnEffect:BaseEffect;
			
			for (var i:int = 0; i < effectLayer.numChildren; i++ ) {
				if (BaseEffect(effectLayer.getChildAt(i)).followee == followee) {
					returnEffect = BaseEffect(effectLayer.getChildAt(i));
				}
			}
			
			return returnEffect;
		}
	}

}