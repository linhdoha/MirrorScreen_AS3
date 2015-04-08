package mirrorScreen.themes.fireMirror
{
	import com.nidlab.kinect.BodyDataReader;
	import flash.events.Event;
	import mirrorScreen.Configuration;
	import mirrorScreen.themes.fireMirror.EffectMirror;
	import mirrorScreen.themes.ThemeBase;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class FireMirror extends ThemeBase
	{
		private var view:FireMirrorView;
		private var mirror:EffectMirror;
		
		public function FireMirror()
		{
			super();
			view = new FireMirrorView();
			addChild(view);
			
			mirror = new EffectMirror();
			view.main.addChild(mirror);
			
			mirror.height = Configuration.getInstance().themeHeight;
			mirror.scaleX = mirror.scaleY;
			mirror.x = -mirror.width / 2;
			mirror.y = -mirror.height / 2;
		}
		
		override public function set bodyDataReader(value:BodyDataReader):void 
		{
			super.bodyDataReader = value;
			mirror.bodyDataReader = value;
		}
	}

}