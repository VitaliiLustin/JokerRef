package com.jokerbros.joker.game.scoresTable 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	/**
	 * ...
	 * @author ValeriiT.Fedorov
	 */
	public class ResultItem extends resultsItem 
	{
		private var _data			:Object;
		private var _mc				:MovieClip;
		private var _scoreTf		:TextField;
		
		public function ResultItem() 
		{
			_mc = this;
			
			setData();
		}
		
		public function setData(data:Object = null):void
		{
			_data = data;
			
			
			for (var i:int = 1; i <= TableConstants.PLAYERS_COUNT; i++) 
			{
				_scoreTf = _mc['pl' + i + '_score'];
			}
		}
		
	}

}