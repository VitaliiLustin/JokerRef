package com.jokerbros.joker.game 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class InfoBar 
	{
		private var _bar:MovieClip;
		private var _type:int;
		
		public function InfoBar(bar:MovieClip) 
		{
			_bar = bar;
		}
	
		
		public function setInfo(bet:Number, balance:Number, type:int = 2):void
		{
			_type = type;
			
			var currency:String = (_type != 2)?'ლარი':'ქულა';
			
			updateBalance(balance);
			updateBet(bet);

		}
		
		public function updateBalance(balance:Number):void
		{
			_bar.balance.text = balance.toString();
		}
		
		public function updateBet(bet:Number):void
		{
			_bar.bet.text = bet.toString();
		}	
		

		
	}

}