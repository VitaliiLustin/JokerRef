package com.jokerbros.joker.game.scoresTable 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author ValeriiT.Fedorov
	 */
	public class ScoreTablePart extends tablePart
	{
		
		private var _data			:Object;
		
		private var _container		:MovieClip;
		private var _back			:MovieClip;
		private var _mask			:MovieClip;
		private var _numMask		:MovieClip;
		private var _numPoint		:MovieClip;
		private var _gameType		:int;
		private var _item			:ScoreItem;
		private var _lineNumber		:LineNumber;
		private var _resItem		:ResultItem;
		private var _orders			:Array = [];
		private var _values			:Array = [];
		private var _results		:Array = [];
		
		private var scoreTable:ScoresTable;
		public var id				:int;
		
		public var partHeight		:Number;
		
		public function ScoreTablePart(table:ScoresTable)
		{
			scoreTable = table;
		}
		
		public function setData(itemCount:int):void 
		{
			_container = 	this.itemsPoint;
			_back = 		this.back;
			_mask = 		this.maskL;
			_numPoint = 	this.numPoint;
			
			_numMask = 		this.numMask;
			showLineNumbers(false);
			buildItems(itemCount);
		}
		
		public function showLineNumbers(act:Boolean):void 
		{
			_numMask.x = act? -12:0;
		}
		
		public function showCurrentLineNumbers(act:Boolean):void 
		{
			_numMask.x = act? -12:0;
		}
		
		private function buildItems(itemCount:int):void 
		{
			var itemY:Number = 0;
			var label:String;
			for (var j:int = 0; j < itemCount; j++) 
			{
				label = j % 2 == 0 ? 'first': 'second';
				_item = new ScoreItem();
				_item.setData();
				_item.y = itemY;
				
				
				_item.gotoAndStop(label);
				_container.addChild(_item); 
				scoreTable.tableItemsVect.push(_item);
				
				
				_lineNumber = new LineNumber(j + 1);
				//_lineNumber.gotoAndStop(label);
				_numPoint.addChild(_lineNumber);
				_lineNumber.y = itemY;
				
				itemY += _item.height + 1;
			}
			
			_resItem = new ResultItem();
			_resItem.setData();
			_resItem.y = itemY;
			_container.addChild(_resItem); 
			scoreTable.tableResultsVect.push(_resItem);
			partHeight = TableConstants['BOARD_' + itemCount + '_HEIGHT'];
			_back.height = _mask.height = _numMask.height = partHeight;
			
		}
		
	}

}