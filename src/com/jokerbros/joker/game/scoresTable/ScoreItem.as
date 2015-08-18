package com.jokerbros.joker.game.scoresTable 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	/**
	 * ...
	 * @author ValeriiT.Fedorov
	 */
	public class ScoreItem extends scoresItem
	{
		private var _data			:Object;
		private var _mc				:MovieClip;
		private var _line			:MovieClip;
		private var _playerOrder	:TextField;
		private var _playerValue	:TextField;
		
		public var lineNumber		:TextField;
		public var lineNumBack		:MovieClip;
		
		
		public function ScoreItem() 
		{
			_mc = this;
			setData();
		}
		
		public function setNumber(visible:Boolean, num:int):void
		{
			//lineNumber.visible = visible;
			//lineNumber.text = String(num);
			//lineNumBack.visible = visible;
		}
		
		public function setData(data:Object = null):void
		{
			_data = data;
			
			for (var i:int = 1; i <= TableConstants.PLAYERS_COUNT; i++) 
			{
				_line = _mc['line' + i];
				_line.visible = false;
			}
		}
		
	}

}