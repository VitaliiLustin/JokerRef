package com.jokerbros.joker.managers 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	/**
	 * ...
	 * @author ValeriiT.Fedorov
	 */
	public class TextAlignManager 
	{
		public static function setTextCoordinates(text1:TextField, mc:MovieClip, delta:Number):void		
		{
			mc.x = text1.x + text1.textWidth + delta;
		}
	}

}