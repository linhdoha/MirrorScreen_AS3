package mirrorScreen.displayComponents
{
	import com.nidlab.kinect.BodyDataReader;
	import com.nidlab.kinect.KinectV2Description;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import mirrorScreen.Configuration;
	import mirrorScreen.themes.dustMirror.DustMirror;
	import mirrorScreen.themes.fireMirror.FireMirror;
	import mirrorScreen.themes.fireMirror.EffectMirror;
	import mirrorScreen.themes.LEMirror.LEMirror;
	import mirrorScreen.themes.ThemeBase;
	import mirrorScreen.themes.tripleMirror.TripleMirror;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class ScreenViewer extends Sprite
	{
		public static const TRIPLE_MIRROR_THEME:String = "tripleMirror";
		public static const FIRE_THEME:String = "fire";
		public static const DUST_MIRROR_THEME:String = "dustMirror";
		public static const LE_MIRROR_THEME:String = "LEMirror";
		
		private var appConfig:Configuration;
		private var _theme:String = TRIPLE_MIRROR_THEME;
		private var themeView:ThemeBase;
		private var themeHolder:Sprite;
		private var _bodyDataReader:BodyDataReader;
		
		public function ScreenViewer()
		{
			super();
			
			appConfig = Configuration.getInstance();
			
			graphics.beginFill(0x000000, 0.2);
			graphics.drawRoundRect(0, 0, KinectV2Description.COLOR_CAMERA_WIDTH, KinectV2Description.COLOR_CAMERA_HEIGHT, 20, 20);
			graphics.endFill();
			
			themeHolder = new Sprite();
			addChild(themeHolder);
		}
		
		public function redraw():void
		{
			if (themeView != null && stage != null)
			{
				themeView.scaleX = themeView.scaleY = stage.stageHeight / appConfig.themeHeight;
				
				themeView.x = KinectV2Description.COLOR_CAMERA_WIDTH / 2;
				themeView.y = KinectV2Description.COLOR_CAMERA_HEIGHT / 2;
			}
			
			if (stage != null)
			{
				var cropRect:Rectangle = new Rectangle();
				cropRect.width = stage.stageWidth;
				cropRect.height = stage.stageHeight;
				cropRect.x = KinectV2Description.COLOR_CAMERA_WIDTH / 2 - cropRect.width / 2;
				cropRect.y = KinectV2Description.COLOR_CAMERA_HEIGHT / 2 - cropRect.height / 2;
				this.scrollRect = cropRect;
			}
		
		}
		
		private function applyTheme():void
		{
			if (themeView != null)
			{
				themeHolder.removeChild(themeView);
			}
			
			switch (_theme)
			{
				case TRIPLE_MIRROR_THEME: 
					themeView = new TripleMirror();
					break;
				case FIRE_THEME: 
					themeView = new FireMirror();
					break;
				case DUST_MIRROR_THEME:
					themeView = new DustMirror();
					break;
				case LE_MIRROR_THEME:
					themeView = new LEMirror();
					break;
			}
			
			if (_bodyDataReader) {
				themeView.bodyDataReader = _bodyDataReader;
			}
			
			themeHolder.addChild(themeView);
			redraw();
		}
		
		public function get theme():String
		{
			return _theme;
		}
		
		public function set theme(value:String):void
		{
			_theme = value;
			applyTheme();
		}
		
		public function get bodyDataReader():BodyDataReader 
		{
			return _bodyDataReader;
		}
		
		public function set bodyDataReader(value:BodyDataReader):void 
		{
			_bodyDataReader = value;
			if (themeView) {
				themeView.bodyDataReader = value;
			}
			
		}
	}

}