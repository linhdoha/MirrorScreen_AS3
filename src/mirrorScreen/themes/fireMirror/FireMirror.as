package mirrorScreen.themes.fireMirror
{
	import mirrorScreen.Configuration;
	import mirrorScreen.themes.fireMirror.Mirror;
	import mirrorScreen.themes.ThemeBase;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class FireMirror extends ThemeBase
	{
		private var view:FireMirrorView;
		private var mirror:Mirror;
		
		public function FireMirror()
		{
			super();
			view = new FireMirrorView();
			addChild(view);
			
			mirror = new Mirror();
			mirror.debugMode = true;
			view.main.addChild(mirror);
			
			mirror.height = Configuration.getInstance().themeHeight;
			mirror.scaleX = mirror.scaleY;
			mirror.x = -mirror.width / 2;
			mirror.y = -mirror.height / 2;
		}
		
		override public function set bodyData(value:String):void
		{
			mirror.bodyData = value;
			super.bodyData = value;
		}
	}

}