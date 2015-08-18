package com.jokerbros.joker.game.scoresTable
{
import com.greensock.TweenMax;
import com.jokerbros.joker.game.Game;
import com.jokerbros.joker.user.ReportException;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import flash.display.MovieClip;
import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ValeriiT.Fedorov
	 */
	 
	public class ScoresTable extends scoresTable
	{
		private var _table			:MovieClip;
		private var _names			:MovieClip;
		private var _tablePartMC	:MovieClip;
		private var _partPoint		:MovieClip;
		
		private var _gameType		:int;
		private var _hand			:int;
		
		private var _gameTypeArr	:Array = [];
		
		private var _playerPlace	:Array = [];
		private var _game:Game;
		private var _results		:Vector.<String> = new Vector.<String>;
		private var _tablePartsVect	:Vector.<ScoreTablePart> = new Vector.<ScoreTablePart>;
		
		public var tableItemsVect	:Vector.<ScoreItem> = new Vector.<ScoreItem>;
		public var tableResultsVect	:Vector.<ResultItem> = new Vector.<ResultItem>;
		
		public function ScoresTable(game:Game):void
		{
			_game = game;
			_table = game.scoreTable;
			_partPoint = _table.pointPart;
		}
		
		public function init(type:int = 1, level:int = -1, placeIndex:int = 1, myIndex:int = 1, users:ISFSArray = null):void
		{
			_gameType = type;
			_hand = _game.currentHand;
			checkGameType();
			initPlayersPlace(placeIndex, myIndex, users);
			buildParts();
		}
		
		private function checkGameType():void
		{
			switch (_gameType)
			{
			case 1: 
				_gameTypeArr = TableConstants.GAME_TYPE_1;
				break;
			case 2: 
				_gameTypeArr = TableConstants.GAME_TYPE_2;
				break;
			case 3: 
				_gameTypeArr = TableConstants.GAME_TYPE_3;
				break;
			default: 
				_gameTypeArr = TableConstants.GAME_TYPE_1;
			}
		}
		
		private function initPlayersPlace(startIndex:int, myIndex:int, users:ISFSArray = null):void
		{
			try
			{
				_table.names["pl1_username"].text = 'Bros' + startIndex;
				_playerPlace[startIndex] = 1;
				for (var j:int = 2; j <= 4; j++)
				{
					if (startIndex == 4) startIndex = 1;
					else startIndex++
					
					_table.names["pl" + j + "_username"].text = 'Bros' + startIndex;
					_playerPlace[startIndex] = j;
				}
				
				_table.names["pl" + myIndex + "_username"].textColor = TableConstants.PLAYER_COLOR;
				
				if (users)
				{
					for (var i:int = 0; i < users.size(); i++)
					{
						_table.names["pl" + users.getSFSObject(i).getInt('index') + "_username"].text = users.getSFSObject(i).getUtfString('username');
					}
				}
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 128, 'PointTable');
			}
		}
		
		private function hideEmptyParts():void
		{
			var lastPart:int = 1;
			var currentPart:int = checkCurrentPart();
			
			for (var i:int = currentPart; i < TableConstants['TYPE_' + _gameType + '_PARTS_COUNT']; i++) 
			{
				if (currentPart < lastPart) 
				{
					currentPart = 2;
				}
				_tablePartsVect[i].visible = false;
			}
		}
		
		public function checkCurrentPart():int 
		{
			_hand = _game.currentHand;
			if (_gameType == TableConstants.TYPE_1)
			{
				if (_hand <= 8) 					return TableConstants.PART_1;
				else if(_hand > 8 && _hand<=12) 	return TableConstants.PART_2;
				else if(_hand > 12 && _hand <= 20) 	return TableConstants.PART_3;
				else 								return TableConstants.PART_4;
			}
			else
			{
				if (_hand <= 4) 					return TableConstants.PART_1;
				else if(_hand > 4 && _hand<=8)		return TableConstants.PART_2;
				else if(_hand > 8 && _hand <= 12) 	return TableConstants.PART_3;
				else 								return TableConstants.PART_4;
			}	

			
			return TableConstants.PART_1;
		}
		
		private function buildParts():void
		{
			var table:ScoreTablePart;
			
			var curPart:int = checkCurrentPart() - 1;
			var partY:Number = 0;
			for (var i:int = 0; i < TableConstants['TYPE_' + _gameType + '_PARTS_COUNT']; i++)
			{
				table = new ScoreTablePart(i, this, _gameTypeArr[i], partY);
				table.showLineNumbers(table.id == curPart);
				
				_partPoint.addChild(table);
				_tablePartsVect.push(table);
				
				partY += table.height + TableConstants.PARTS_SHIFT;
				
			}
		}
		
		public function setOrder(player:int, hand:int, order:int):void
		{
			try
			{
				tableItemsVect[hand - 1]['pl' + _playerPlace[player] + '_order'].text = (order == 0) ? '-' : order.toString();
			}
			catch (err:Error)
			{
				ReportException.send(err.message + 'player: ' + player, 281, 'PointTable');
			}
		}
		
		public function restore(params:ISFSObject, currenHand:int):void
		{
			for (var hand:int = 1; hand <= currenHand; hand++)
			{
				for (var i:int = 1; i <= 4; i++)
				{
					if (params.getSFSObject(i.toString()).getSFSObject(hand.toString()))
					{
						if (params.getSFSObject(i.toString()).getSFSObject(hand.toString()).containsKey('order'))
						{
							var order:int = params.getSFSObject(i.toString()).getSFSObject(hand.toString()).getInt('order');
							setOrder(i, hand, order);
						}
						
						if (params.getSFSObject(i.toString()).getSFSObject(hand.toString()).containsKey('score'))
						{
							var score:int = params.getSFSObject(i.toString()).getSFSObject(hand.toString()).getInt('score');
							
							if (score != 0)
							{
								tableItemsVect[hand - 1]['pl' + _playerPlace[i] + '_value'].text = score.toString();
								if (score > 0)
								{
									tableItemsVect[hand - 1]['pl' + _playerPlace[i] + '_value'].text = score.toString();
									
									if (params.getSFSObject(i.toString()).getSFSObject(hand.toString()).getBool('addled') == true)
									{
										tableItemsVect[hand - 1]['pl' + _playerPlace[i] + '_value'].textColor = TableConstants.ADDLED_COLOR;
									}
									
									if (params.getSFSObject(i.toString()).getSFSObject(hand.toString()).containsKey('premium'))
									{
										trace('premium restore');
										
										tableItemsVect[hand - 1]['pl' + _playerPlace[i] + '_value'].textColor = TableConstants.PREMIUM_COLOR;
									}
									
								}
								else
								{
									tableItemsVect[hand - 1]['line' + _playerPlace[i]].visible = true;
									tableItemsVect[hand - 1]['pl' + _playerPlace[i] + '_value'].visible = false;
								}
								//if (params.getSFSObject(i.toString()).getSFSObject(hand.toString()).containsKey('delete'))
								//{
									//tableItemsVect[hand - 1][['line' + _playerPlace[i]]].visible = true;			//проверить
									//tableItemsVect[hand - 1]['pl' + _playerPlace[i] + '_value'].visible = false;	//
								//}
							}
						}
					}
				}
			}
			
			var result:String;
			for (var j:int = 1; j <= 4; j++)
			{
				for (i = 1; i <= 4; i++)
				{
					if (params.getSFSObject(j.toString()).containsKey('sum_' + i.toString()))
					{
						var sum:int = params.getSFSObject(j.toString()).getInt('sum_' + i.toString());
						result = (Number(sum) / 100).toString();
						tableResultsVect[i - 1]['pl' + _playerPlace[j] + '_score'].text = result;
						_table.names['pl' + _playerPlace[j] + '_value'].text = result;
						
					}
				}
			}
		}
		
		public function setOrderResult(params:ISFSObject):void
		{
			var curUser:ISFSObject;
			
			for (var i:int = 1; i <= 4; i++)
			{
				curUser = params.getSFSObject(i.toString());
				
				if (curUser.getInt('score') >= 0)
				{
					tableItemsVect[curUser.getInt('hand') - 1]['pl' + _playerPlace[i] + '_value'].text = curUser.getInt('score').toString();
					
				}
				else
				{
					tableItemsVect[curUser.getInt('hand') - 1][['line' + _playerPlace[i]]].visible = true;
					tableItemsVect[curUser.getInt('hand') - 1]['pl' + _playerPlace[i] + '_value'].visible = false;
				}
				
				setPultkaSum(curUser.getInt('sum'), i, curUser.getInt('hand'));
				
				//if (curUser.containsKey('delete'))
				//{
					//tableItemsVect[curUser.getInt('hand') - 1][['line' + _playerPlace[i]]].visible = true;			//проверить
					//tableItemsVect[curUser.getInt('hand') - 1]['pl' + _playerPlace[i] + '_value'].visible = false;	//
				//}
				
				if (curUser.getBool('addled') == true)
				{
					tableItemsVect[curUser.getInt('hand') - 1]['pl' + _playerPlace[i] + '_value'].textColor = TableConstants.ADDLED_COLOR;
				}
				
				if (curUser.containsKey('premium'))
				{
					trace('premium');
					
					tableItemsVect[curUser.getInt('hand') - 1]['pl' + _playerPlace[i] + '_value'].textColor = TableConstants.PREMIUM_COLOR;
				}
				
			}
		}
		
		private function setPultkaSum(sum:int, index:int, hand:int):void
		{
			var plItem:int;
			
			if (_gameType == TableConstants.TYPE_1)
			{
				if (hand <= 8)				 		plItem = 0;
				else if (hand > 8 && hand <= 12) 	plItem = 1;
				else if (hand > 12 && hand <= 20) 	plItem = 2;
				else 								plItem = 3;
			}
			else
			{
				if (hand <= 4) 						plItem = 0;
				else if (hand > 4 && hand <= 8)		plItem = 1;
				else if (hand > 8 && hand <= 12) 	plItem = 2;
				else 								plItem = 3;
			}
			
			var result:String = (Number(sum) / 100).toString();
			
			tableResultsVect[plItem]['pl' + _playerPlace[index] + '_score'].text = result;
			_table.names['pl' + _playerPlace[index] + '_value'].text = result;
		}
	}

}