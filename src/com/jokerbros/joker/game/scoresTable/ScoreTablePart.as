package com.jokerbros.joker.game.scoresTable 
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ValeriiT.Fedorov
	 */
	public class ScoreTablePart extends tablePart
	{
		private var _gameType		:int;
		private var _item			:ScoreItem;
		private var _lineNumber		:LineNumber;
		private var _resItem		:ResultItem;
		private var _orders			:Array = [];
		private var _values			:Array = [];
		private var _results		:Array = [];
		
		private var scoreTable:ScoresTable;
		private var _id				:int;
		
		private var _startX		:Number;
		private var _startY		:Number;
		private var _startWidth	:Number;
		private var _startHeight:Number;
		
		public function ScoreTablePart(id:int, table:ScoresTable, itemCount:int, posY:Number)
		{
			_id = id;
			
			scoreTable = table;
			showLineNumbers(false);
			buildItems(itemCount);
			
			mouseChildren = false;
			
			y = posY;
			
			saveDefaulParams();
			
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		private function saveDefaulParams():void 
		{
			_startX = x;
			_startY = y;
			_startWidth = width;
			_startHeight = height;
		}
		
		private function onOver(e:MouseEvent):void
		{
			TweenMax.to( this, TableConstants.TWEEN_TIME, {
				x:_startX + (_startWidth - _startWidth * TableConstants.MAX_SCALE) * .5, 
				y: _startY + (_startHeight - _startHeight * TableConstants.MAX_SCALE) * .5, 
				scaleX: TableConstants.MAX_SCALE, 
				scaleY: TableConstants.MAX_SCALE, 
				alpha: 1 } );
				
			showLineNumbers(true);
		}
		
		private function onOut(e:MouseEvent = null):void
		{
			TweenMax.to( this, .5, {
				x: _startX, 
				y: _startY, 
				scaleX: TableConstants.NORMAL_SCALE, 
				scaleY: TableConstants.NORMAL_SCALE, 
				alpha: 1 } );
		
			mouseEnabled = true;
			
			showLineNumbers(id == scoreTable.checkCurrentPart() - 1);
		}
		
		public function showLineNumbers(act:Boolean):void 
		{
			numMask.x = act? -12:0;
		}
		
		public function showCurrentLineNumbers(act:Boolean):void 
		{
			numMask.x = act? -12:0;
		}
		
		private function buildItems(itemCount:int):void 
		{
			var itemY:Number = 0;
			var label:String;
			for (var j:int = 0; j < itemCount; j++) 
			{
				label = j % 2 == 0 ? 'first': 'second';
				_item = new ScoreItem();
				_item.y = itemY;
				
				
				_item.gotoAndStop(label);
				itemsPoint.addChild(_item); 
				scoreTable.tableItemsVect.push(_item);
				
				
				_lineNumber = new LineNumber(j + 1);
				numPoint.addChild(_lineNumber);
				_lineNumber.y = itemY;
				
				itemY += _item.height + 1;
			}
			
			_resItem = new ResultItem();
			_resItem.y = itemY;
			itemsPoint.addChild(_resItem); 
			scoreTable.tableResultsVect.push(_resItem);
			
			back.height = maskL.height = numMask.height = TableConstants['BOARD_' + itemCount + '_HEIGHT'];
			
		}
		
		public function get id():int 
		{
			return _id;
		}
		
	}

}