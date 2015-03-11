package com.nidlab.utils 
{
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class ColorStyle 
	{
		static private var _instance:ColorStyle;
		private var colorRandom:Array = [0x0177a7,0xff173d,0xffc000,0xFFFFFF];
		
		public function ColorStyle() 
		{
			
		}
		
		public static function getInstance():ColorStyle {
			if (!_instance) {
				_instance = new ColorStyle();
			}
			return _instance;
		}
		
		public function randomColor():uint {
			return colorRandom[Math.round(Math.random() * (colorRandom.length-1))];
		}
		
	}

}