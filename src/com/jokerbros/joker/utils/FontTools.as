package com.jokerbros.joker.utils 
{
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author jb.ge
	 */
	public class FontTools 
	{
		
		public static var bpgarial:String = new BGPArial().fontName;
		public static var arial:String = new Arial().fontName;
		public static var handel:String = new Hanndel().fontName;
		public static var handelRegular:String = new HandelRegular().fontName;
		
		public function FontTools() 
		{
			
		}
		
		public static function embed(txt:TextField, font:String):void
		{
			txt.embedFonts = true;
			txt.selectable = false;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.setTextFormat( new TextFormat(font) );
		}
		
	}

}