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
		private var _playerOrder	:TextField;
		private var _playerValue	:TextField;
		
		public var lineNumber		:TextField;
		public var lineNumBack		:MovieClip;
		
		
		public function ScoreItem() 
		{
			_mc = this;
			hideLines();
		}
		
		private function hideLines():void
		{
			for (var i:int = 1; i <= TableConstants.PLAYERS_COUNT; i++) 
			{
				_mc['line' + i].visible = false;
			}
		}
		
		public function setNumber(visible:Boolean, num:int):void
		{
			//lineNumber.visible = visible;
			//lineNumber.text = String(num);
			//lineNumBack.visible = visible;
		}
		
		public function set data(data:Object):void
		{
			_data = data;
		}
		
	}

}