package com.jokerbros 
{
	import flash.display.MovieClip;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Vitalii
	 */
	public class TxtHelper 
	{
		public static var arial			:String = new Arial().fontName;
		public static var bpgarial		:String = new BGPArial().fontName;
		public static var handel		:String = new Hanndel().fontName;
		public static var handelRegular	:String = new HandelRegular().fontName;
		
		public static function setTxtParams(txt:TextField, fontName:String, isEmbedFonts:Boolean = true, isSelectable:Boolean = false, antiAliasType:String = 'advanced'):void
		{
			txt.embedFonts = isEmbedFonts;
			txt.selectable = isSelectable;
			txt.antiAliasType = antiAliasType;
			txt.setTextFormat( new TextFormat(fontName) );
		}
		
	}

}