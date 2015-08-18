package com.jokerbros.joker.game 
{
	import com.jokerbros.joker.events.GameEvent;
	import com.jokerbros.joker.events.GameManagerEvent;
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.user.ReportException;
	import com.jokerbros.joker.game.CardManager;
	import com.smartfoxserver.v2.entities.match.RoomProperties;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.jokerbros.joker.events.PanelEvent;
	import com.jokerbros.joker.game.GameActionWindow.*;
	
	import com.smartfoxserver.v2.entities.data.*;
	/**
	 * ...
	 * @author 13
	 */
	public class GameManager extends Sprite
	{
		
		private var _autoMoveCardObject		:ISFSObject;
		private var _autoOrderVal			:int;
		private var _autoOrderTrumpVal		:String;
		private var _dealer					:MovieClip;
		private var _dealerPoints			:Vector.<MovieClip>;
		private var _board					:MovieClip;
		private var _lastCards				:MovieClip;
		private var _order					:Order;
		private var _orderTrump				:OrderTrump;
		private var _jokerAction			:JokerAction;
	
		private var _players 				:Vector.<Player>;
		
		private var _myIndex				:int;
		
		private var _selectJoker			:Card;
		
		private var _isFirstMove			:Boolean;
		private var _disCards				:Array;
		
		private var _trump					:Card;
		private var _trumpMask				:Sprite;
		private var _moveCount				:int;

		private var _lastMoveCards			:Array;
		private var _showLastMoveCards		:Array;
		
		private var _cardManager		    :CardManager;
		private var _game 	:MovieClip;
		private var GAME	:Game;
		private var _actionPanel			:ActionPanel;
		private var _actionPanelCont		:MovieClip;
		public function GameManager(game:MovieClip) 
		{
			_autoMoveCardObject 	= null;
			_autoOrderVal 			= -1;
			_autoOrderTrumpVal 		= '';
			Facade.gameManager 		= this;
			try 
			{
				_game = game;
				_board = _game.mcBoard;
				_actionPanelCont 	= _game.actionPanel;
				_actionPanel 		= new ActionPanel(_game.actionPanel);
				_lastCards = _game.mcLastMoveCards;
								
				_players 	= new Vector.<Player>(GameConstants.MAX_PLAYERS);
				_dealerPoints		= new Vector.<MovieClip>(GameConstants.MAX_PLAYERS);
				_lastMoveCards = new Array();
				
				_showLastMoveCards = new Array();
				
				_moveCount 	= 0;
				
				_cardManager = new CardManager();
				_dealer 			= _game.mcDealer;
				for (var i:int = 1; i <= GameConstants.MAX_PLAYERS; i++)
				{
					_dealerPoints[i] = _game['dp'+i];
				}
				initLastMoveCards();	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 76, 'GameManager' );
			}
		}
		
		/**
		 * anawilebs motamasheebs, serveridan momdis chemi rogiti nomeri
		 * @param	ind
		 */ 
		public function setPlayersIndex(ind:int, users:ISFSArray = null):void
		{

				var index:Array = new Array();
				var tmpInd:int = 1;
				
				_myIndex = ind;

				_players[ind] = new Player(Player.BOTTOM, _game.playerBottom, _game.cards4);
							
				for (var i:int = 0; i < 3; i++) 
				{
					if (ind < 4) { ind ++; index.push(ind) }
					else { index.push(tmpInd); tmpInd++; }	
				}
				
				_players[index[0]] = new Player(Player.LEFT,_game.playerLeft, _game.cards1);
				_players[index[1]] = new Player(Player.TOP,_game.playerTop, _game.cards2);
				_players[index[2]] = new Player(Player.RIGHT,_game.playerRight, _game.cards3);

				if (users)
				{
					for (var j:int = 0; j < users.size(); j++) 
					{
						_players[users.getSFSObject(j).getInt('index')].userBox.mcUserInfo.username.text = users.getSFSObject(j).getUtfString('username');
						
					}
				}
				
			
		}
		
		public function setDealer(plIndex:int):void
		{
			_dealer.x = _dealerPoints[getPlayerPos(plIndex)].x;
			_dealer.y = _dealerPoints[getPlayerPos(plIndex)].y;
			_dealer.visible = true;
		}
		
		/*momxareblis nacxadebi mnishneloba*/
		  
		public function setOrder(value:int, index:int = -1):void
		{
			var ind:int = (index > -1)?index:this._myIndex;
			_players[ind].setOrder(value);
		}
		
		/*mimdinare xelis agebuli vziatkebi*/
		  
		public function setCurrentOrder(value:int, index:int = -1):void
		{
			var ind:int = (index > -1)?index:this._myIndex;
			_players[ind].setCurrentOrder(value);
		}
		
		
		/**
		 * kartebis darigeba
		 */ 
		public function distribute(cards:Array, trump:String):void
		{
			this.resetAllCards();
			
			this.setTrump(trump);
			
			try 
			{
				cards = sortCards(cards);
				
				for (var i:int = 1; i <= 4; i++) 
				{
					_players[i].cardsLength = cards.length; // parametri kartebis poziciebistvis
					
					for (var j:int = 0; j < cards.length; j++) 
					{
						var cardName:String = (_players[i].owner == Player.BOTTOM)?cards[j]:'cardBack';
						
						_players[i].cards[j] = new Card(cardName);
						
						_players[i].setCardPosition(j);
						_board.addChild(_players[i].cards[j]);
					}
					
					// clear user cur and order value
					setOrder(-1,i);
					setCurrentOrder(-1,i)
				}
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 284, 'GameManager' );
			}
		}
		
		/**
		 * koziris gamochena dafaze
		 */
		private function setTrump(trump:String):void
		{
			try
			{
				if (trump != '')
				{
					_trump = new Card(trump);
					_trump.scaleX = 0.64;
					_trump.scaleY = 0.64;
					_trump.rotation = 31;
					_trump.x = 768.2;
					_trump.y = 336.8;
					_trump.active();
					_board.addChild(_trump);
					
					_trumpMask = new mcTrumpMask;
					_trumpMask.x = 326.6;
					_trumpMask.y = 290.15;
					_board.addChild(_trumpMask);
					
					_trump.mask = _trumpMask;
				}	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 308, 'GameManager' );
			}
		}
		
		/**
		 * koziris ganuleba, washla magididan
		 */
		private function resetTrump():void 
		{
			try 
			{
				if (_trump != null)
				{
					_board.removeChild(_trump);
					_board.removeChild(_trumpMask);
					_trump = null;
					_trumpMask = null;
				}	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 327, 'GameManager' );
			}
		}
		
		
		/*******CARDS MENEGER*****************************************************************************************/
		private function resetAllCards():void
		{
			try 
			{
				for (var i:int = 1; i <= 4; i++) 
				{
					for (var j:int = 0; j < _players[i].cards.length; j++) 
					{
						try 
						{
							if (_board.contains( _players[i].cards[j] )) _board.removeChild(_players[i].cards[j]);
						}
						catch (err:Error)
						{
							trace('catch Remove Card from Stage: ' + err);
						}
						
						try 
						{
							_players[i].cards[j].destroy();
							
							_players[i].cards[j] = null;
						
							//_players[i].cards.splice(j, 1);
						}
						catch (err:Error)
						{
							trace('catch Reset Object: ' + err);
						}
					}
					
					_players[i].cards = new Vector.<Card>;
					
				}	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 378, 'GameManager' );
			}
			
			this.resetTrump();
			this.resetLastMoveCards();
		}
		
		private function resetMoveCards():void
		{
			try 
			{
				for (var i:int = 1; i <= 4; i++) 
				{
					for (var j:int = 0; j < _players[i].cards.length; j++) 
					{
						if (_players[i].cards[j].state == Card.CARD_MOVED)
						{
							try 
							{
								if (_board.contains(_players[i].cards[j])) _board.removeChild(_players[i].cards[j]);
								
								_players[i].cards[j] = null;
								
								_players[i].cards.splice(j, 1);
							}
							catch (err:Error)
							{
								ReportException.send(err.message, 382, 'GameManager' );
							}
							
						}
					}
				}	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 392, 'GameManager' );
			}
		}
		
		
		
		private function resetLastMoveCards():void
		{
			try 
			{
				for (var j:int = 1; j <= 4; j++) 
				{
					if (_showLastMoveCards[j] != null)
					{
						_lastCards.mcContent.removeChild(_showLastMoveCards[j].card)
						
						_showLastMoveCards[j] = null;
					}
				}
				
				_showLastMoveCards = new Array();	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 408, 'GameManager' );
			}
		}
		
		
		private function updateLastMoveCards():void
		{
			
			try 
			{
				resetLastMoveCards();

				_showLastMoveCards = _lastMoveCards;
			
				for (var i:int = 1; i <= 4; i++) 
				{
					_showLastMoveCards[i].card.x 		= _players[_showLastMoveCards[i].index].lastCardParam.x;
					_showLastMoveCards[i].card.y 		= _players[_showLastMoveCards[i].index].lastCardParam.y;
					_showLastMoveCards[i].card.width 	= _players[_showLastMoveCards[i].index].lastCardParam.width;
					_showLastMoveCards[i].card.height 	= _players[_showLastMoveCards[i].index].lastCardParam.height;
					
					_showLastMoveCards[i].card.active();
					_lastCards.mcContent.addChild(_showLastMoveCards[i].card);
				}
				
				_lastMoveCards = new Array();	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 440, 'GameManager' );
			}
			
		}
		
		private function addLastMoveCard(card:String, index:int):void
		{
			try 
			{
				var data:Object = {index:index, card:new Card(card)}
				
				_lastMoveCards[_moveCount+1] =  data;	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 455, 'GameManager' );
			}
		}
		
		public function restoreLastMoveCards(params:ISFSArray = null):void
		{
			try 
			{
				if (params)
				{
					_showLastMoveCards = new Array();
					
					for (var i:int = 0; i < params.size(); i++) 
					{
						var data:Object = { index:null, card:null }
						
						data.index = params.getSFSObject(i).getInt('index');
						data.card = new Card(params.getSFSObject(i).getUtfString('card'))
						
						_showLastMoveCards[i+1] = data;
						
						_showLastMoveCards[i+1].card.x 		= _players[_showLastMoveCards[i+1].index].lastCardParam.x;
						_showLastMoveCards[i+1].card.y 		= _players[_showLastMoveCards[i+1].index].lastCardParam.y;
						_showLastMoveCards[i+1].card.width 	= _players[_showLastMoveCards[i+1].index].lastCardParam.width;
						_showLastMoveCards[i+1].card.height = _players[_showLastMoveCards[i+1].index].lastCardParam.height;
						
						_lastCards.mcContent.addChild(_showLastMoveCards[i + 1].card)
						
					}
				}	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 489, 'GameManager' );
			}
		}
		
		
		public function enableCards(disCards:Array, firstMove:Boolean, autoMoveCard:ISFSObject = null):void
		{
			_autoMoveCardObject = autoMoveCard;
			
			try 
			{
				_isFirstMove = firstMove;
				_disCards = disCards;
				
				for (var i:int = 0; i < _players[_myIndex].cards.length; i++) 
				{
					var ind:String = _players[_myIndex].cards[i].cardName;

					if (disCards.indexOf(ind) == -1 || disCards == null)
					{
						_players[_myIndex].cards[i].addEventListener(MouseEvent.CLICK, onMove);	
						_players[_myIndex].cards[i].buttonMode = true;
						_players[_myIndex].cards[i].active();
							
					}
				}	
			}
			catch (err:Error)
			{
				var errorString:String = err.message;
					errorString += 'Myindex: ' + _myIndex.toString();
					errorString += 'cards length: ' + _players[_myIndex].cards.length.toString();
					errorString += 'I-index: ' + i.toString();
					errorString += 'firstMove: ' + firstMove.toString();
					
				ReportException.send(errorString, 519, 'GameManager' );
			}
		}
		
		public function disableCards():void
		{
			try 
			{
				for (var i:int = 0; i < _players[_myIndex].cards.length; i++) 
				{
					_players[_myIndex].cards[i].removeEventListener(MouseEvent.CLICK, onMove);	
					_players[_myIndex].cards[i].buttonMode = false;
					_players[_myIndex].cards[i].deActive();
				}	
			}
			catch (err:Error)
			{
				var errorString:String = err.message;
					errorString += 'Myindex: ' + _myIndex.toString();
					errorString += 'cards length: ' + _players[_myIndex].cards.length.toString();
					errorString += 'I-index: ' + i.toString();
				
				ReportException.send(errorString, 539, 'GameManager' );
			}

		}

		/*******CARD ACTION*****************************************************************************************/
		public function oppMove(userIndex:int, cardObject:ISFSObject):void 
		{
			
			GameSound.play('moveCard');
			
			var cardIndex:int;
			var cardName:String = cardObject.getUtfString('value');
			
			try 
			{
				if (userIndex == _myIndex)
				{
					for (var j:int = 0; j < _players[userIndex].cards.length; j++) 
					{
						if (_players[userIndex].cards[j].cardName == cardName)
						{
							if (_board.contains(_players[userIndex].cards[j]))
							{
								 _board.removeChild(_players[userIndex].cards[j])
								 _board.addChild(_players[userIndex].cards[j])
							}
							cardIndex = j;
							break;
						}
					}
				}
				else
				{
					cardIndex = 0; // oponents yovetvis unda hqondes nulovani elementi
					
					// save opp card position
					var tmpX:Number = _players[userIndex].cards[cardIndex].x;
					var tmpY:Number = _players[userIndex].cards[cardIndex].y;
					var tmpR:Number	= _players[userIndex].cards[cardIndex].rotation;

					// remove opp back card from stage
					if (_board.contains(_players[userIndex].cards[cardIndex])) _board.removeChild(_players[userIndex].cards[cardIndex]);
					
					_players[userIndex].cards[cardIndex].destroy();		
					_players[userIndex].cards[cardIndex] = null;
					_players[userIndex].cards[cardIndex] = new Card(cardName);
							
					_players[userIndex].cards[cardIndex].x = tmpX;
					_players[userIndex].cards[cardIndex].y = tmpY;
					_players[userIndex].cards[cardIndex].rotation = tmpR;
							
					_board.addChild(_players[userIndex].cards[cardIndex]);
					
				}	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 582, 'GameManager' );
			}
			
			try 
			{
				// kartis chamosvla 
				_players[userIndex].cards[cardIndex].state = Card.CARD_MOVED;
				
				_cardManager.animateMoveCard(_players[userIndex].cards[cardIndex],getPlayerPos(userIndex));
				_players[userIndex].updateCardPosition();	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 614, 'GameManager' );
			}
			
			try 
			{
				if (cardName == 'JB' || cardName == 'JR')
				{
					var data:Object = new Object();
						data["action"] = cardObject.getInt('action');		
					
					_players[userIndex].cards[cardIndex].jokerAction = data["action"];
					
					if (cardObject.getUtfString('order')) 
					{
						data["order"] = cardObject.getUtfString('order');
						_players[userIndex].cards[cardIndex].jokerActionValue = data["order"];
					}
					
					_players[userIndex].cards[cardIndex].addChild(new JokerActionLabel( data, _players[userIndex].param.jokerActionX, _players[userIndex].param.jokerActionY))
				}
				
				
				addLastMoveCard(_players[userIndex].cards[cardIndex].cardName, userIndex);

				_moveCount ++; // unda gamiozxebodas addLastMoveCard-is mere!!!
				
				_players[userIndex].cards[cardIndex].moveCount = _moveCount;
				_players[userIndex].cards[cardIndex].ownerIndex = userIndex;
				
				if (cardObject.containsKey('winIndex'))
				{
					isEndLocalHand(cardObject.getInt('winIndex'));	
				}
				else
				{
					isEndLocalHand();
				}
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 654, 'GameManager' );
			}
			
		}
		
		
		
		private function myMoveCard(card:Card, action:Object = null):void 
		{
			GameSound.play('moveCard');
			
			try 
			{
				addLastMoveCard(card.cardName, _myIndex);
				
				// chenge index
				_board.removeChild(card);
				_board.addChild(card);
				
				card.state = Card.CARD_MOVED;
				_cardManager.animateMoveCard(card, Player.BOTTOM);
				_players[_myIndex].updateCardPosition();
				
				var data:Object = new Object();
					data['card'] = card.cardName;
				
				if (action != null)
				{
					data['action'] = action.action;
					card.jokerAction = action.action;
					
					if (action.order)
					{
						card.jokerActionValue = action.order;
						data['order'] = action.order;
					}
				}
					
				dispatchEvent(new GameManagerEvent(GameManagerEvent.MOVE, data));	
				
				_moveCount ++;
				
				card.moveCount = _moveCount;
				card.ownerIndex = _myIndex;
				
				isEndLocalHand();				
				
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 708, 'GameManager' );
			}
		}
		
		/*********CARD ACTION HANDLES*****************************************************************************************/
		private function onMove(e:MouseEvent):void 
		{
			disableCards();
			
			var currentCard:Card = e.currentTarget as Card;
			
			try 
			{
				
				if (e.currentTarget.cardName == 'JB' || e.currentTarget.cardName == 'JR')
				{
					try 
					{
						_jokerAction = new JokerAction(_isFirstMove);
						_jokerAction.addEventListener(PanelEvent.MOVE_JOKER_ACTION, onJokerAction);
						_board.addChild(_jokerAction)
						
						_selectJoker = currentCard;	
					}
					catch (err:Error)
					{
						ReportException.send(err.message, 741, 'GameManager' );
					}
					
				}
				else
				{
					try 
					{
						this.myMoveCard(currentCard);	
					}
					catch (err:Error)
					{
						ReportException.send(err.message + 'Current Card: ' + currentCard.cardName, 753, 'GameManager' );
					}
				}	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 736, 'GameManager' );
			}
		}
		
		private function onJokerAction(e:PanelEvent):void 
		{
			try 
			{
				this.clearJokerAction();

				if (e.data != null)
				{
					myMoveCard(_selectJoker, e.data as Object);
					_selectJoker.addChild(new JokerActionLabel( e.data as Object, _players[_myIndex].param.jokerActionX, _players[_myIndex].param.jokerActionY ));
				}
				else 
				{
					this.enableCards(_disCards, _isFirstMove);
				}	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 758, 'GameManager' );
			}
		}
		
		public function clearJokerAction():void
		{
			try 
			{
				if (_jokerAction != null)
				{
					_jokerAction.removeEventListener(PanelEvent.MOVE_JOKER_ACTION, onJokerAction);
					if(_board.contains(_jokerAction))_board.removeChild(_jokerAction);
					_jokerAction = null;
				}	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 775, 'GameManager' );
			}
		}
		
		/**
		 * funcqcia gamoizaxeba yoveli kartis tarebis dros (oppMoveCardshi da MymoveCarshi)
		 * tu chamosulia 4 karti shlis am kartebs da inaxavs LastMove Cardshi
		 */
		public function checkEndLocalHand():void
		{
			if (_moveCount == 4)
			{
				_moveCount = 0;
				
				resetMoveCards();
				updateLastMoveCards();
			}
		}
		
		/*
		 * funqcia gamoizaxeba opp moves dros
		 * an my movis dros
		 * tu chamosulia 4 karti iwyebs wasvlis animacias
		 * 
		 * */
		private function isEndLocalHand(winnerIndex:int = -1):void
		{
			var paramXY:Object = { };
			try 
			{
				if (_moveCount == GameConstants.MAX_PLAYERS)
				{
					var index:int;
					
					if (winnerIndex == -1)
					{
						try 
						{
							var moveCard:Vector.<Card> = new Vector.<Card>();
								moveCard[0] = null;
								
								
							for (var i:int = 1; i <= GameConstants.MAX_PLAYERS; i++) 
							{
								for (var j:int = 0; j < _players[i].cards.length; j++) 
								{
									if (_players[i].cards[j].state == Card.CARD_MOVED)
									{
										moveCard[i] = 	_players[i].cards[j];
										break;
									}
								}
							}	
						}
						catch (err:Error)
						{
							var errorString:String = err.message;
								errorString += 'iiii: ' + i.toString();
								errorString += 'jjjj: ' + j.toString();
								errorString += 'myind: ' + _myIndex.toString();
								
							ReportException.send(errorString,868, 'GameManager' );
						}
						
						
						try 
						{
							var win_index:int = WinPlayer.factory(moveCard, _trump.type);
							paramXY = calcAnimXY( win_index );
							//index = win_index;
						}
						catch (err:Error)
						{
							
							var error_msg:String;
								error_msg = 'ERROR: ' + err.message + '; ';
								error_msg += 'WIN INDEX: ' + win_index.toString() + '; ';
								error_msg += 'TRUMP: ' + _trump.type + '; ';
								
							for (var k:int = 0; k < moveCard.length; k++) 
							{
								if (moveCard[k] != null) 
								{
									if (moveCard[k].cardName == 'JB' || moveCard[k].cardName == 'JR')
									{
										error_msg += moveCard[k].cardName + '-> ACT: ' + moveCard[k].jokerAction + ' ->VAL: ' + moveCard[k].jokerActionValue + '-';
									}
									else
									{
										error_msg += moveCard[k].cardName + '-';	
									}
								}
							}	
							
							ReportException.send(error_msg,877, 'GameManager' );
						}
					}
					
					else
					{
						try
						{
							//index = winnerIndex;
							paramXY = calcAnimXY(winnerIndex);
						}
						catch (err:Error)
						{
							ReportException.send(err.message + 'WinnerIndex: ' +winnerIndex + 'playPOS!!!',893, 'GameManager' );
						}
					}
					try 
					{
						for (i=1; i <= GameConstants.MAX_PLAYERS; i++) 
						{
							for ( j = 0; j < _players[i].cards.length; j++) 
							{
								if (winnerIndex == -1) 
								{
									winnerIndex = 4;
								}
								if (_players[i].cards[j].state == Card.CARD_MOVED)
								{				
									_cardManager.clearMovedCard(_players[i].cards[j], getPlayerPos(winnerIndex));
								}
							}
						}	
					}
					catch (err:Error)
					{
						ReportException.send(err.message ,915, 'GameManager' );
					}
				}	
			}
			catch (err:Error)
			{
				var errorString1:String = err.message;
					errorString1 += '_moveCount: ' + _moveCount.toString();
					errorString1 += 'winnerIndex: ' + winnerIndex.toString();
					
				ReportException.send(errorString1, 925, 'GameManager' );
			}
		}
		
		public function calcAnimXY(plIndex:int):Object
		{
			var data:Object = {xx:0, yy:0};
			var pos:int = getPlayerPos(plIndex);
			
			data.xx = _board['out' + pos].x;
			data.yy = _board['out' + pos].y;
			
			return data;
		}
		
		/**
		 * mibrunebs momxareblis pozicias, gamoizaxeba Game Classhi Timerebistvis
		 */
		public  function getPlayerPos(index:int):int
		{
			return _players[index].owner;
		}
		
		
		/*******ORDERS*****************************************************************************************/
		public function showOrder(maxOrder:int, access:int = -1, fill:int=-1, autoOrder:int = -1):void
		{
			_autoOrderVal = autoOrder;

			try
			{
				_actionPanel.setOrderData(maxOrder, access, fill, autoOrder);
				_actionPanel.show(ActionPanel.ORDER, true);
				Facade.dispatcher.addEventListener(GameEvent.SET_ORDER, onOrder);
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 900, 'GameManager' );
			}
		}
		
		private function onOrder(e:GameEvent):void
		{
			Facade.dispatcher.removeEventListener(GameEvent.SET_ORDER, onOrder);
			clearOrder();
			dispatchEvent(new GameManagerEvent(GameManagerEvent.SET_ORDER, e.data));
		}
		
		public function clearOrder():void
		{
			try
			{
				_actionPanel.show(ActionPanel.ORDER, false);
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 923, 'GameManager' );
			}
		}
		
		public function showOrderTrump(autoTrum:String = ''):void
		{
			_autoOrderTrumpVal = autoTrum;
			try
			{
				Facade.dispatcher.addEventListener(GameEvent.SET_ORDER_TRUMP, onOrderTrump);
				_actionPanel.show(ActionPanel.ORDER_TRUMP, true);
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 940, 'GameManager' );
			}
		}

		private function onOrderTrump(e:GameEvent):void
		{
			Facade.dispatcher.removeEventListener(GameEvent.SET_ORDER_TRUMP, onOrderTrump);
			clearOrderTrump();
			dispatchEvent(new GameManagerEvent(GameManagerEvent.SET_ORDER_TRUMP,e.data));
		}

		public function clearOrderTrump():void
		{
			try
			{
				_actionPanel.show(ActionPanel.ORDER_TRUMP, false);
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 963, 'GameManager' );
			}
		}
		
		private function initLastMoveCards():void
		{
			try 
			{
				this._lastCards.mcBtn.visible = true;
				this._lastCards.mcContent.visible = false;
				
				this._lastCards.mcBtn.buttonMode = true;
				this._lastCards.mcBtn.addEventListener(MouseEvent.CLICK, onShowCards)
				this._lastCards.mcBtn.addEventListener(MouseEvent.MOUSE_OUT, onHideCards);	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 1006, 'GameManager' );
			}
		}
		
		private function onShowCards(e:MouseEvent):void 
		{
			this._lastCards.mcContent.visible = !this._lastCards.mcContent.visible;
		}
		
		private function onHideCards(e:MouseEvent):void 
		{
				this._lastCards.mcContent.visible = false;
		}
		
		/**
		 * 
		 * @param	index players index
		 * @param	type  0 Bot To User || 1 User To Bot
		 */	
		public function switchUser(index:int, type:int):void
		{	
			try 
			{
				if (type == 0)
				{
					//_players[index].userBox.username.text = 'Bros' + index;
					_players[index].userBox.mcUserInfo.username.textColor = 0xFFFFFF;
				}
				else
				{
					_players[index].userBox.mcUserInfo.username.text = _players[index].userBox.mcUserInfo.username.text + ' Bot';
					_players[index].userBox.mcUserInfo.username.textColor = 0x700000;
				}	
			}
			catch (err:Error)
			{
					ReportException.send('Eror dump', 1043, 'GameManager' );	
			}
			
		}
		
		
		private function sortCards(cards:Array):Array 
		{
			try 
			{
				cards = cards.sort();
			   
			   var cardType:Array = [ "H", "C", "D", "S", "J"];
			   var newCards:Array = new Array();
			   
			   for (var j:int = 0; j < cardType.length; j++) 
			   {
				for (var i:int = 0; i < cards.length; i++) 
				{
				 if (cardType[j] == cards[i].substring(0, 1)) {
				  newCards.push(cards[i]);
				 }
				}
			   }
			   
			   var tmpcard:String = "";   
			   for(var cardsind:int =  newCards.length-1; cardsind >=0; cardsind--)
				{
				 for(var k:int = 0; k < newCards.length-1; k++)
				 {
				  
				  if(newCards[k].substring(0, 1) == newCards[k+1].substring(0, 1))
				  {
				   if( (int)(newCards[k].substring(1)) < (int)(newCards[k+1].substring(1)) )
				   {
					tmpcard = newCards[k];
					newCards[k] = newCards[k+1];
					newCards[k+1] = tmpcard;
				   }
				  }
				 }   
				} 
			   
			   return newCards;	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 1092, 'GameManager' );
			}
			
			return newCards;	
		}
		
		public function autoMyAction():void
		{
			var data:Object = new Object();
							
			if (_autoMoveCardObject)
			{
				this.autoMyMoveCard( _autoMoveCardObject );
				
				_autoMoveCardObject = null
			}
			else if (_autoOrderTrumpVal != '')
			{
				data['trump'] = _autoOrderTrumpVal;
				data['auto'] = true;
				
				dispatchEvent(new GameManagerEvent(GameManagerEvent.SET_ORDER_TRUMP, data));
				
				_autoOrderTrumpVal = ''
			}
			else if (_autoOrderVal != -1)
			{
				data['value'] = _autoOrderVal;
				data['auto'] = true;
				
				dispatchEvent(new GameManagerEvent(GameManagerEvent.SET_ORDER, data));
				_autoOrderVal = -1
			}
			else
			{
				ReportException.send('Fatal Error', 1253, 'GameManager');
			}
		}
		
		private function autoMyMoveCard( cardObject:ISFSObject ):void
		{
			this.oppMove(_myIndex, cardObject);

			var cardName:String = cardObject.getUtfString('value');
		
			var data:Object = new Object();
				data['card'] = cardName;
				data['auto'] = true;
				
			if (cardName == 'JB' || cardName == 'JR')
			{
				data["action"] = cardObject.getInt('action');	
				
				if (cardObject.getUtfString('order')) 
				{
					data["order"] = cardObject.getUtfString('order');
				}
			}
			dispatchEvent(new GameManagerEvent(GameManagerEvent.MOVE, data));	
		}
		
		public function resetAutoActionVars():void
		{
			_autoMoveCardObject = null;
			_autoOrderTrumpVal = '';
			_autoOrderVal = -1;
		}
		
		public function get game():MovieClip 
		{
			return _game;
		}
		
	}
}