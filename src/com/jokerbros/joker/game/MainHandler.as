package com.jokerbros.joker.game
{
import com.jokerbros.joker.Facade.Facade;
import com.jokerbros.joker.events.GameEvent;
import com.jokerbros.joker.lobby.Lobby;
import com.jokerbros.joker.user.User;
import com.jokerbros.Parametrs;
import com.smartfoxserver.v2.entities.data.ISFSObject;

	public class MainHandler
	{
		private static var _lobby:Lobby;
		private static var _game:Game;
		private var _instance:MainHandler;

		public function get instance():MainHandler
		{
			if (!_instance)
			{
				_instance = new MainHandler();
			}

			return _instance;
		}

		public function MainHandler():void
		{
			if (!_instance)
			{
				_instance = this;
			}
			else
			{
				throw new Error('Use singleton instance');
			}
		}

		public static function initHandlerLobby(lobby:Lobby):void
		{
			_lobby = lobby;
		}
		public static function initHandlerGame( game:Game):void
		{
			_game = game;
		}

		public static function initLobby(params:ISFSObject):void
		{
			trace(params.getDump());
			_lobby.hidePreInitCashGame();
			_lobby.tournament.hide();
			_lobby.whiteGame.hide();

			if (_lobby.gameType == 0)
			{
				_lobby.gameType = params.getInt(Parametrs.PARAM_GAME_TYPE);

				_lobby._ChangeGameType.setActiveTab(_lobby.gameType);
			}
			else
			{
				_lobby.gameType = params.getInt(Parametrs.PARAM_GAME_TYPE)
			}

			if (_lobby.gameType == 1)
			{
				if (params.getSFSObject(Parametrs.PARAM_USER_INFO).getInt(Parametrs.PARAM_IS_SET_INFO) == 0)
				{
					_lobby.showPreInitCashGame(true ,params.getUtfString(Parametrs.PARAM_TITLE));
				}
				else if (params.getSFSObject(Parametrs.PARAM_USER_INFO).getInt(Parametrs.PARAM_IS_SET_INFO) == 1 && params.getBool(Parametrs.PARAM_ENABLE_GAME) == false)
				{
					_lobby.showPreInitCashGame(false, params.getUtfString(Parametrs.PARAM_TITLE));
				}
			}
			else  if (_lobby.gameType == 2)
			{
				if (params.getBool(Parametrs.PARAM_ENABLE_GAME) == false)
				{
					_lobby.showPreInitCashGame(false, params.getUtfString(Parametrs.PARAM_TITLE));
				}

				if (params.getInt(Parametrs.PARAM_LAST_TIME) > 0)
				{
					_lobby.whiteGame.show(params.getInt(Parametrs.PARAM_LAST_TIME));
				}
			}
			else if (_lobby.gameType == 3)
			{
				if (params.getSFSObject(Parametrs.PARAM_USER_INFO).getInt(Parametrs.PARAM_IS_SET_INFO) == 0)
				{
					_lobby.showPreInitCashGame(true ,params.getUtfString(Parametrs.PARAM_TITLE));
				}
				else
				{
					_lobby.tournament.initState(params.getSFSObject(Parametrs.PARAM_TOURNAMENT));
				}
			}

			_lobby._UserMenu.btnEnable(_lobby.gameType);

			_lobby.setUserInfo( params.getSFSObject(Parametrs.PARAM_USER_INFO));

			_lobby.joinPublicRoom.init(_lobby.gameType, params.getSFSArray(Parametrs.PARAM_ROOMS), params.getSFSObject(Parametrs.PARAM_MY_ACTIVE_ROOM));

			if(params.getSFSObject(Parametrs.PARAM_MY_ROOM))
			{
				_lobby.tableOfRooms.init( params.getSFSArray(Parametrs.PARAM_ROOMS_LIST), _lobby.gameType  );
			}
			_lobby._ChangeRoomType.setActiveTab(1);
			updateOnlinePlayers( params.getSFSObject(Parametrs.PARAM_USER_COUNT).getInt(Parametrs.PARAM_VALUE).toString());
			_lobby.hideProgress();
		}

		public static function updateOnlinePlayers(users:String):void
		{
			_lobby.mcOnlinePlayers.value.text = users;
		}

		public static function responseJoinRoom(params:ISFSObject):void
		{
			trace(params.getDump());
			var code:int = params.getInt(Parametrs.PARAM_CODE);

			if (_lobby.windEnterPass) // join private room
			{
				if (code == 4 || code == 5)
				{
					_lobby.hideWindEnterPass();

					var msg:String = (code == 4)?'?????? ???????????':'?????? ???????????';

					_lobby.showAlert(msg);
				}
				else
				{
					_lobby.windEnterPass.response(code);
				}

			}
			else // joinRoom public room
			{

				_lobby.hideProgress();

				switch( code )
				{
					case 1:   _lobby.showAlert('????? ?? ????? ????????? ????? ????????');    break;
					case 2:   _lobby.showAlert('????? ????????? ???????');    break;
					case 4:   _lobby.showAlert('?????? ???????????');    break;
					case 5:   _lobby.showAlert('?????? ???????????');    break;
				}
			}
		}

		public static function addRoom(param:ISFSObject):void
		{
			_lobby.tableOfRooms.add(param);
		}

		public static function removeRoom(param:ISFSObject):void
		{
			_lobby.tableOfRooms.remove(param);
		}

		public static function busyRoom(param:ISFSObject):void
		{
			_lobby.tableOfRooms.update(param, Parametrs.PARAM_BUSY);
		}

		public static function freeRoom(param:ISFSObject):void
		{
			_lobby.tableOfRooms.update(param, Parametrs.PARAM_FREE);
		}

		public static function updateGameHistory(param:ISFSObject):void
		{
			trace(param.getDump());
			if (_lobby.gameHistory)
			{
				_lobby.gameHistory.update(param);
			}
		}

		public static function updateRatingList(param:ISFSObject):void
		{
			trace(param.getDump());
			if (_lobby.windRating)
			{
				_lobby.windRating.update(param);
			}
		}

		public static function updateBlackList(param:ISFSObject):void
		{
			trace(param.getDump());
			if (_lobby.windBlackList)
			{
				_lobby.windBlackList.update(param);
			}
		}

		public static function takePlaceResponse(params:ISFSObject):void
		{
			trace(params.getDump());
			_lobby.hideProgress();

			if (params.containsKey(Parametrs.PARAM_FREE_PLACE))
			{
				var data:ISFSObject = params.getSFSObject(Parametrs.PARAM_FREE_PLACE);
				_lobby.joinPublicRoom.freePlace(data.getInt(Parametrs.PARAM_LEVEL), data.getUtfString(Parametrs.PARAM_TYPE), data.getInt(Parametrs.PARAM_COUNT));
			}

			if (params.containsKey(Parametrs.PARAM_CODE))
			{
				switch (params.getInt(Parametrs.PARAM_CODE))
				{
					case 1:	 _lobby.showAlert('????? ?? ????? ????????? ????? ????????'); 	break;
					case 2:	 _lobby.showAlert('????? ????????? ???????');	break;
				}
			}
			else
			{
				_lobby.joinPublicRoom.takePlace(params.getInt(Parametrs.PARAM_LEVEL), params.getUtfString(Parametrs.PARAM_TYPE), params.getInt(Parametrs.PARAM_COUNT));
			}
		}

		public static function freePlaceResponse(params:ISFSObject):void
		{
			trace(params.getDump());
			_lobby.hideProgress();
			_lobby.joinPublicRoom.freePlace(params.getInt(Parametrs.PARAM_LEVEL), params.getUtfString(Parametrs.PARAM_TYPE), params.getInt(Parametrs.PARAM_COUNT));
		}

		public static function userPlaceAction(params:ISFSObject):void
		{
			trace(params.getDump());
			_lobby.joinPublicRoom.placeIcon(params.getInt(Parametrs.PARAM_COUNT), params.getInt(Parametrs.PARAM_LEVEL), params.getUtfString(Parametrs.PARAM_TYPE));

			if (params.containsKey(Parametrs.PARAM_FREE_PLACE))
			{
				var data:ISFSObject = params.getSFSObject(Parametrs.PARAM_FREE_PLACE);
				_lobby.joinPublicRoom.placeIcon(data.getInt(Parametrs.PARAM_COUNT), data.getInt(Parametrs.PARAM_LEVEL), data.getUtfString(Parametrs.PARAM_TYPE));
			}
		}

		public static function responseCreateRoom(params:ISFSObject):void
		{
			trace(params.getDump());
			if (_lobby.createRoomPopUP) _lobby.createRoomPopUP.response(params);

			//add my room to table
			if (params.containsKey(Parametrs.PARAM_ROOM))
			{
				_lobby.tableOfRooms.add(params.getSFSObject(Parametrs.PARAM_ROOM));
			}
		}

		public static function startGame( params:ISFSObject ):void
		{
			trace(params.getDump());
			var isRestored:Boolean = GameProperties.restore;
			User.tableID 		= 	params.getSFSObject(Parametrs.PARAM_GAME_INFO).getUtfString(Parametrs.PARAM_ROOM_ID);
			User.username 		= 	params.getSFSObject(Parametrs.PARAM_CLIENT_INFO).getUtfString(Parametrs.PARAM_USERNAME);
			User.myIndex 		= 	params.getInt(Parametrs.PARAM_INDEX);

			User.balance     	=   params.getSFSObject(Parametrs.PARAM_CLIENT_INFO).getDouble(Parametrs.PARAM_BALANCE);
			User.gameType     	=   params.getInt(Parametrs.PARAM_GAME_TYPE);
			User.bet     		=   params.getSFSObject(Parametrs.PARAM_GAME_INFO).getInt(Parametrs.PARAM_BET);

			if (isRestored == false)
			{
				initGame(params);
			}
			else
			{
				restore( params );
			}
		}

		public static function initGame(params:ISFSObject):void
		{
			trace(params.getDump());
			if (params.getInt(Parametrs.PARAM_GAME_TYPE) != 2)
			{
				_game.mcChat.visible = false;
			}

			GameSound.play("startGame");

			_game.infoBar.updateBalance(User.balance);
			_game.infoBar.updateBet(params.getSFSObject(Parametrs.PARAM_GAME_INFO).getDouble(Parametrs.PARAM_BET));

			_game.gameType = params.getInt(Parametrs.PARAM_GAME_TYPE);

			if (params.containsKey(Parametrs.PARAM_USERS))
			{
				_game.manager.setPlayersIndex( params.getInt(Parametrs.PARAM_INDEX), params.getSFSArray(Parametrs.PARAM_USERS) ); // myindex
				_game.scoresTable.init(params.getSFSObject(Parametrs.PARAM_GAME_INFO).getInt(Parametrs.PARAM_TABLE_TYPE),params.getSFSObject(Parametrs.PARAM_GAME_INFO).getInt(Parametrs.PARAM_LEVEL), params.getSFSObject(Parametrs.PARAM_ATUZVA).getInt(Parametrs.PARAM_TABLE_INDEX), params.getInt(Parametrs.PARAM_INDEX), params.getSFSArray(Parametrs.PARAM_USERS))
			}
			else
			{
				_game.manager.setPlayersIndex( params.getInt(Parametrs.PARAM_INDEX) ); // myindex
				_game.scoresTable.init(params.getSFSObject(Parametrs.PARAM_GAME_INFO).getInt(Parametrs.PARAM_TABLE_TYPE),params.getSFSObject(Parametrs.PARAM_GAME_INFO).getInt(Parametrs.PARAM_LEVEL), params.getSFSObject(Parametrs.PARAM_ATUZVA).getInt(Parametrs.PARAM_TABLE_INDEX), params.getInt(Parametrs.PARAM_INDEX))
			}

			startHand(params.getSFSObject(Parametrs.PARAM_START_HAND));
			oppAction(params.getInt(Parametrs.PARAM_START_CLIENT));

			_game.infoBar.setInfo(params.getSFSObject(Parametrs.PARAM_GAME_INFO).getDouble(Parametrs.PARAM_BET), User.balance, _game.gameType);

			Facade.dispatcher.dispatch(GameEvent.GAME_INIT);
		}

		public static function startHand( params:ISFSObject ):void
		{
			trace(params.getDump());
			_game.updateHandStatus();

			var cards:Array = params.getUtfStringArray(Parametrs.PARAM_CARDS);
			var trump:String = (params.getUtfString(Parametrs.PARAM_TRUMP))?params.getUtfString(Parametrs.PARAM_TRUMP):'';

			_game.manager.resetAutoActionVars();
			_game.manager.distribute(cards, trump);

			if (params.getSFSObject(Parametrs.PARAM_ORDER) != null)
			{
				_game.setOrder( params.getSFSObject(Parametrs.PARAM_ORDER).getInt(Parametrs.PARAM_MAX), params.getSFSObject(Parametrs.PARAM_ORDER).getInt(Parametrs.PARAM_RESTRICT), params.getSFSObject(Parametrs.PARAM_ORDER).getInt(Parametrs.PARAM_FILL), params.getSFSObject(Parametrs.PARAM_ORDER).getInt(Parametrs.PARAM_AUTO_ORDER) );
			}
			else if (params.getSFSObject(Parametrs.PARAM_ORDER_TRUMP) != null)
			{
				_game.setOrderTrump(params.getSFSObject(Parametrs.PARAM_ORDER_TRUMP).getUtfString(Parametrs.PARAM_AUTO_ORDER_TRUMP));
			}

			_game.currentHand = params.getInt(Parametrs.PARAM_CURRENT_HAND);

			if (params.getSFSObject(Parametrs.PARAM_PART_ITEM))
			{
				_game.scoresTable.setOrderResult(params.getSFSObject(Parametrs.PARAM_PART_ITEM));
			}

			_game.manager.setDealer(params.getInt(Parametrs.PARAM_DEALER));
		}

		public static function endGame(params:ISFSObject):void
		{
			trace(params.getDump());
			if (params.getSFSObject(Parametrs.PARAM_PART_ITEM))
			{
				_game.scoresTable.setOrderResult(params.getSFSObject(Parametrs.PARAM_PART_ITEM));
			}

			_game.gameTimer.disable();

			_game.endGameAdd(params);
			User.balance = params.getDouble(Parametrs.PARAM_BALANCE);
			_game.infoBar.updateBalance(User.balance);
		}

		public static function oppMove(params:ISFSObject):void
		{
			trace(params.getDump());
			_game.gameTimer.disable();

			var index:int = params.getInt(Parametrs.PARAM_INDEX);
			var move:ISFSObject = params.getSFSObject(Parametrs.PARAM_MOVE);
			var card:ISFSObject = params.getSFSObject(Parametrs.PARAM_CARD);
			var starthand:ISFSObject = params.getSFSObject(Parametrs.PARAM_START_HAND);

			if (params.getBool(Parametrs.PARAM_OPP_MOVE))
			{
				_game.manager.oppMove(index, card);
			}

			if(move)
			{
				setMove( move.getUtfStringArray(Parametrs.PARAM_DISABLED_CARDS), move.getBool(Parametrs.PARAM_FIRST_MOVE), move.getSFSObject(Parametrs.PARAM_AUTO_MOVE_CARD));
			}

			if (params.containsKey(Parametrs.PARAM_WIN_INDEX))
			{
				var winIndex	:	int = params.getInt(Parametrs.PARAM_WIN_INDEX);
				var taken		:	int = params.getInt(Parametrs.PARAM_TAKEN);

				_game.manager.setCurrentOrder(taken, winIndex);
			}

			if (starthand)
			{
				startHand(starthand);
			}
		}

		public static function addMyBone(params:ISFSObject):void
		{
			trace(params.getDump());
		}

		public static function setMove(disabledCards:Array, firstMove:Boolean, autoMoveCard:ISFSObject = null):void
		{
			_game.gameTimer.enable();
			_game.manager.resetAutoActionVars();

			_game.manager.checkEndLocalHand();
			_game.manager.enableCards(disabledCards, firstMove, autoMoveCard); // aq chasamatebelia card objecti
		}

		public static function updateTaken(value:int, index:int):void
		{
			_game.manager.setCurrentOrder(value, index);
		}

		public static function switchUser(index:int, type:int):void
		{
			_game.manager.switchUser(index, type);
		}

		public static function addOppBone():void
		{

		}

		public static function endHand(params:ISFSObject):void
		{
			trace(params.getDump());
		}

		public static function restore(params:ISFSObject):void
		{
			trace(params.getDump());

			_game.gameType = params.getInt(Parametrs.PARAM_GAME_TYPE);

			if (params.getInt(Parametrs.PARAM_GAME_TYPE) != 2) _game.mcChat.visible = false;

			_game.currentHand = params.getInt(Parametrs.PARAM_CURRENT_HAND);

			if (params.containsKey(Parametrs.PARAM_USERS))
			{
				trace('resss');
				_game.manager.setPlayersIndex( params.getInt(Parametrs.PARAM_INDEX), params.getSFSArray(Parametrs.PARAM_USERS) ); // myindex
				_game.scoresTable.init(params.getSFSObject(Parametrs.PARAM_GAME_INFO).getInt(Parametrs.PARAM_TABLE_TYPE),params.getSFSObject(Parametrs.PARAM_GAME_INFO).getInt(Parametrs.PARAM_LEVEL), params.getInt(Parametrs.PARAM_TABLE_INDEX), params.getInt(Parametrs.PARAM_INDEX), params.getSFSArray(Parametrs.PARAM_USERS))
			}
			else
			{
				_game.manager.setPlayersIndex( params.getInt(Parametrs.PARAM_INDEX) ); // myindex
				_game.scoresTable.init(params.getSFSObject(Parametrs.PARAM_GAME_INFO).getInt(Parametrs.PARAM_TABLE_TYPE),params.getSFSObject(Parametrs.PARAM_GAME_INFO).getInt(Parametrs.PARAM_LEVEL), params.getInt(Parametrs.PARAM_TABLE_INDEX), params.getInt(Parametrs.PARAM_INDEX))
			}

			//_manager.setPlayersIndex( params.getInt(Parametrs.PARAM_INDEX) ); // myindex


			_game.scoresTable.restore(params.getSFSObject(Parametrs.PARAM_PARAM_RESULT_TABLE), _game.currentHand);

			_game.manager.distribute(params.getUtfStringArray(Parametrs.PARAM_CARDS), params.getUtfString(Parametrs.PARAM_TRUMP));
			_game.manager.restoreLastMoveCards(params.getSFSArray(Parametrs.PARAM_LAST_MOVE_CARDS));

			_game.manager.setDealer(params.getInt(Parametrs.PARAM_DEALER));

			_game.infoBar.setInfo(params.getSFSObject(Parametrs.PARAM_GAME_INFO).getDouble(Parametrs.PARAM_BET), User.balance, _game.gameType);

			/*********MOVED CARDS RESTORE*******************/
			for (var i:int = 0; i < params.getSFSArray(Parametrs.PARAM_OPP_MOVES).size(); i++)
			{
				var actionMoves:ISFSObject = params.getSFSArray(Parametrs.PARAM_OPP_MOVES).getSFSObject(i);

				if (actionMoves.getInt(Parametrs.PARAM_INDEX) != params.getInt(Parametrs.PARAM_INDEX))
				{
					_game.manager.oppMove(actionMoves.getInt(Parametrs.PARAM_INDEX), actionMoves.getSFSObject(Parametrs.PARAM_CARD));
				}
				else
				{
					_game.manager.oppMove(actionMoves.getInt(Parametrs.PARAM_INDEX), actionMoves.getSFSObject(Parametrs.PARAM_CARD));
				}
			}


			_game.updateHandStatus(params.getInt(Parametrs.PARAM_HAND_STATUS));


			/*****************BOARD ORDER RESTORE ***********/
			for (var index:int = 1; index <= 4; index++)
			{
				if (params.getSFSObject(index.toString()).containsKey(Parametrs.PARAM_ORDER) )
				{
					updateOrder(index , params.getSFSObject(index.toString()).getInt(Parametrs.PARAM_ORDER), null, null, params.getInt(Parametrs.PARAM_HAND_STATUS));
				}

				if (params.getSFSObject(index.toString()).getInt(Parametrs.PARAM_TAKEN))
				{
					_game.manager.setCurrentOrder(params.getSFSObject(index.toString()).getInt(Parametrs.PARAM_TAKEN), index);
				}

				if (params.getSFSObject(index.toString()).containsKey(Parametrs.PARAM_TYPE))
				{
					trace('tt:' + params.getSFSObject(index.toString()).getInt(Parametrs.PARAM_TYPE))
					switchUser(index, params.getSFSObject(index.toString()).getInt(Parametrs.PARAM_TYPE));
				}
			}


			/******MY ACTION RESTORE**********************/
			if (params.getSFSObject(Parametrs.PARAM_MOVE)) // svlis agdegan (minicheba)
			{
				var disCard:Array = params.getSFSObject(Parametrs.PARAM_MOVE).getUtfStringArray(Parametrs.PARAM_DISABLED_CARDS);
				var firstMove:Boolean = params.getSFSObject(Parametrs.PARAM_MOVE).getBool(Parametrs.PARAM_FIRST_MOVE);

				setMove(disCard, firstMove, params.getSFSObject(Parametrs.PARAM_MOVE).getSFSObject(Parametrs.PARAM_AUTO_MOVE_CARD));
			}
			else if (params.getSFSObject(Parametrs.PARAM_ORDER_TRUMP)) // kozeris cxadebis agdgena
			{
				_game.setOrderTrump(params.getSFSObject(Parametrs.PARAM_ORDER_TRUMP).getUtfString(Parametrs.PARAM_AUTO_ORDER_TRUMP));
			}
			else if (params.getSFSObject(Parametrs.PARAM_ORDER)) // cxadebis agdgena
			{
				var max:int = params.getSFSObject(Parametrs.PARAM_ORDER).getInt(Parametrs.PARAM_MAX);
				var restrict:int = params.getSFSObject(Parametrs.PARAM_ORDER).getInt(Parametrs.PARAM_RESTRICT);
				var fill:int = params.getSFSObject(Parametrs.PARAM_ORDER).getInt(Parametrs.PARAM_FILL);

				_game.setOrder( max, restrict, fill, params.getSFSObject(Parametrs.PARAM_ORDER).getInt(Parametrs.PARAM_AUTO_ORDER));
			}

			_game.gameTimer.restore(params.getInt(Parametrs.PARAM_TIMER), _game.manager.getPlayerPos( params.getInt(Parametrs.PARAM_ACTIVE_PLAYER) ) );

			Facade.dispatcher.dispatch(GameEvent.GAME_INIT);
		}

		public static function skipMove(state:int):void
		{

		}

		public static function oppAction(timer:int):void
		{
			_game.manager.checkEndLocalHand();
			_game.gameTimer.enable( _game.manager.getPlayerPos(timer) );
		}

		public static function updateScore(point:int, cur_point:int,isWin:Boolean):void
		{

		}

		public static function responseTourReg(param:ISFSObject):void
		{
			_lobby.tournament.registration.respRegistration(param);
		}

		public static function responseTourUnReg(param:ISFSObject):void
		{
			_lobby.tournament.registration.respUnRegistration(param);
		}

		public static function responseTourFindOpp(param:ISFSObject):void
		{
			_lobby.tournament.running.resPlay(param);
		}

		public static function responseTourCancelFindOpp(param:ISFSObject):void
		{
			_lobby.tournament.running.respCancelWhiteOpp(param);
		}

		public static function tourUpdateTopPlayers(param:ISFSObject):void
		{
			_lobby.tournament.running.updateTopPlayers(param);
		}

		public static function tourUpdateActiveUsers(param:ISFSObject):void
		{
			_lobby.tournament.running.updateOnlinePlayers(param.getInt(Parametrs.PARAM_ACTIVE_PLAYERS));
		}

		public static function tourUpdateList(param:ISFSObject):void
		{
			_lobby.tournament.list.updateTourList(param);
		}

		public static function tourInitState(param:ISFSObject):void
		{
			_lobby.tournament.initState(param);
		}

		public static function tourUpdateRegUsers(param:ISFSObject):void
		{
			_lobby.tournament.registration.updateRegUsers(param);
		}

		public static function gameToLobby():void
		{
			_game.gameToLobby();
		}

		public static function updateOrder(index:int, value:int, order:ISFSObject = null, move:ISFSObject = null, handStatus:int=0):void
		{
			if (order != null)
			{
				_game.setOrder( order.getInt(Parametrs.PARAM_MAX), order.getInt(Parametrs.PARAM_RESTRICT), order.getInt(Parametrs.PARAM_FILL), order.getInt(Parametrs.PARAM_AUTO_ORDER));
			}
			else if(move != null)
			{
				setMove( move.getUtfStringArray(Parametrs.PARAM_DISABLED_CARDS), move.getBool(Parametrs.PARAM_FIRST_MOVE), move.getSFSObject(Parametrs.PARAM_AUTO_MOVE_CARD)  );
			}

			_game.updateHandStatus(handStatus);

			_game.scoresTable.setOrder(index, _game.currentHand, value);
			_game.manager.setOrder(value,index);

		}

		public static function updateChatStatus(param:ISFSObject):void
		{
			_game.chat.updateChatStatus(param);
		}

		public static function updateChatMessage(utfString:String, ind:int = 0):void
		{
			_game.chat.updateChatMessage(utfString, ind);
		}

		public static function oppChangedBet(bet:Number, direction:int):void
		{

		}

		public static function responseContinueGame(code:int):void
		{

		}

		public static function respTourNextHand(param:ISFSObject):void
		{

		}

		public static function get lobby():Lobby {
			return _lobby;
		}

		public static function get game():Game {
			return _game;
		}
	}

}