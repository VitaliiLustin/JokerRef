package com.jokerbros.joker.game.scoresTable 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	/**
	 * ...
	 * @author ValeriiT.Fedorov
	 */
	public class LineNumber extends scoreNumber
	{
		private var _number			:TextField;
		
		public function LineNumber(id:int) 
		{
			lnumber.text = String(id);
		}		
	}

}