package com.jokerbros.joker.game
{
import com.jokerbros.joker.Facade.Facade;
import com.jokerbros.joker.events.GameEvent;
import com.jokerbros.joker.lobby.Lobby;
import com.jokerbros.joker.user.User;
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
				_lobby.gameType = params.getInt('gameType');

				_lobby._ChangeGameType.setActiveTab(_lobby.gameType);
			}
			else
			{
				_lobby.gameType = params.getInt('gameType')
			}

			if (_lobby.gameType == 1)
			{
				if (params.getSFSObject('userInfo').getInt('isSetInfo') == 0)
				{
					_lobby.showPreInitCashGame(true ,params.getUtfString('title'));
				}
				else if (params.getSFSObject('userInfo').getInt('isSetInfo') == 1 && params.getBool('enableGame') == false)
				{
					_lobby.showPreInitCashGame(false, params.getUtfString('title'));
				}
			}
			else  if (_lobby.gameType == 2)
			{
				if (params.getBool('enableGame') == false)
				{
					_lobby.showPreInitCashGame(false, params.getUtfString('title'));
				}

				if (params.getInt('lastTime') > 0)
				{
					_lobby.whiteGame.show(params.getInt('lastTime'));
				}
			}
			else if (_lobby.gameType == 3)
			{
				if (params.getSFSObject('userInfo').getInt('isSetInfo') == 0)
				{
					_lobby.showPreInitCashGame(true ,params.getUtfString('title'));
				}
				else
				{
					_lobby.tournament.initState(params.getSFSObject('tournament'));
				}
			}

			_lobby._UserMenu.btnEnable(_lobby.gameType);

			_lobby.setUserInfo( params.getSFSObject('userInfo'));

			_lobby.joinPublicRoom.init(_lobby.gameType, params.getSFSArray('rooms'), params.getSFSObject('myActiveRoom'));

			if(params.getSFSObject('myRoom'))
			{
				_lobby.tableOfRooms.init( params.getSFSArray('roomsList'), _lobby.gameType  );
			}
			_lobby._ChangeRoomType.setActiveTab(1);
			updateOnlinePlayers( params.getSFSObject('userCount').getInt('value').toString());
			_lobby.hideProgress();
		}

		public static function updateOnlinePlayers(users:String):void
		{
			_lobby.mcOnlinePlayers.value.text = users;
		}

		public static function responseJoinRoom(params:ISFSObject):void
		{
			trace(params.getDump());
			var code:int = params.getInt("code");

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
			_lobby.tableOfRooms.update(param, 'busy');
		}

		public static function freeRoom(param:ISFSObject):void
		{
			_lobby.tableOfRooms.update(param, 'free');
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

			if (params.containsKey('freePlace'))
			{
				var data:ISFSObject = params.getSFSObject('freePlace');
				_lobby.joinPublicRoom.freePlace(data.getInt('level'), data.getUtfString('type'), data.getInt('count'));
			}

			if (params.containsKey('code'))
			{
				switch (params.getInt('code'))
				{
					case 1:	 _lobby.showAlert('????? ?? ????? ????????? ????? ????????'); 	break;
					case 2:	 _lobby.showAlert('????? ????????? ???????');	break;
				}
			}
			else
			{
				_lobby.joinPublicRoom.takePlace(params.getInt('level'), params.getUtfString('type'), params.getInt('count'));
			}
		}

		public static function freePlaceResponse(params:ISFSObject):void
		{
			trace(params.getDump());
			_lobby.hideProgress();
			_lobby.joinPublicRoom.freePlace(params.getInt('level'), params.getUtfString('type'), params.getInt('count'));
		}

		public static function userPlaceAction(params:ISFSObject):void
		{
			trace(params.getDump());
			_lobby.joinPublicRoom.placeIcon(params.getInt('count'), params.getInt('level'), params.getUtfString('type'));

			if (params.containsKey('freePlace'))
			{
				var data:ISFSObject = params.getSFSObject('freePlace');
				_lobby.joinPublicRoom.placeIcon(data.getInt('count'), data.getInt('level'), data.getUtfString('type'));
			}
		}

		public static function responseCreateRoom(params:ISFSObject):void
		{
			trace(params.getDump());
			if (_lobby.createRoomPopUP) _lobby.createRoomPopUP.response(params);

			//add my room to table
			if (params.containsKey('room'))
			{
				_lobby.tableOfRooms.add(params.getSFSObject("room"));
			}
		}

		public static function startGame( params:ISFSObject ):void
		{
			trace(params.getDump());
			var isRestored:Boolean = GameProperties.restore;
			User.tableID 		= 	params.getSFSObject('gameInfo').getUtfString('roomId');
			User.username 		= 	params.getSFSObject('clientInfo').getUtfString('username');
			User.myIndex 		= 	params.getInt('index');

			User.balance     	=   params.getSFSObject('clientInfo').getDouble('balance');
			User.gameType     	=   params.getInt('gameType');
			User.bet     		=   params.getSFSObject('gameInfo').getInt('bet');

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
			if (params.getInt('gameType') != 2)
			{
				_game.mcChat.visible = false;
			}

			GameSound.play("startGame");

			_game.infoBar.updateBalance(User.balance);
			_game.infoBar.updateBet(params.getSFSObject('gameInfo').getDouble('bet'));

			_game.gameType = params.getInt('gameType');

			if (params.containsKey('users'))
			{
				_game.manager.setPlayersIndex( params.getInt('index'), params.getSFSArray('users') ); // myindex
				_game.scoresTable.init(params.getSFSObject('gameInfo').getInt('tableType'),params.getSFSObject('gameInfo').getInt('level'), params.getSFSObject('atuzva').getInt('tableIndex'), params.getInt('index'), params.getSFSArray('users'))
			}
			else
			{
				_game.manager.setPlayersIndex( params.getInt('index') ); // myindex
				_game.scoresTable.init(params.getSFSObject('gameInfo').getInt('tableType'),params.getSFSObject('gameInfo').getInt('level'), params.getSFSObject('atuzva').getInt('tableIndex'), params.getInt('index'))
			}

			startHand(params.getSFSObject('startHand'));
			oppAction(params.getInt('startClient'));

			_game.infoBar.setInfo(params.getSFSObject('gameInfo').getDouble('bet'), User.balance, _game.gameType);

			Facade.dispatcher.dispatch(GameEvent.GAME_INIT);
		}

		public static function startHand( params:ISFSObject ):void
		{
			trace(params.getDump());
			_game.updateHandStatus();

			var cards:Array = params.getUtfStringArray('cards');
			var trump:String = (params.getUtfString('trump'))?params.getUtfString('trump'):'';

			_game.manager.resetAutoActionVars();
			_game.manager.distribute(cards, trump);

			if (params.getSFSObject('order') != null)
			{
				_game.setOrder( params.getSFSObject('order').getInt('max'), params.getSFSObject('order').getInt('restrict'), params.getSFSObject('order').getInt('fill'), params.getSFSObject('order').getInt('autoOrder') );
			}
			else if (params.getSFSObject('orderTrump') != null)
			{
				_game.setOrderTrump(params.getSFSObject('orderTrump').getUtfString('autoOrderTrump'));
			}

			_game.currentHand = params.getInt('currentHand');

			if (params.getSFSObject('partItem'))
			{
				_game.scoresTable.setOrderResult(params.getSFSObject('partItem'));
			}

			_game.manager.setDealer(params.getInt('dealer'));
		}

		public static function endGame(params:ISFSObject):void
		{
			trace(params.getDump());
			if (params.getSFSObject('partItem'))
			{
				_game.scoresTable.setOrderResult(params.getSFSObject('partItem'));
			}

			_game.gameTimer.disable();

			_game.endGameAdd(params);
			User.balance = params.getDouble('balance');
			_game.infoBar.updateBalance(User.balance);
		}

		public static function oppMove(params:ISFSObject):void
		{
			trace(params.getDump());
			_game.gameTimer.disable();

			var index:int = params.getInt('index');
			var move:ISFSObject = params.getSFSObject('move');
			var card:ISFSObject = params.getSFSObject('card');
			var starthand:ISFSObject = params.getSFSObject('startHand');

			if (params.getBool('oppMove'))
			{
				_game.manager.oppMove(index, card);
			}

			if(move)
			{
				setMove( move.getUtfStringArray('disabledCards'), move.getBool('firstMove'), move.getSFSObject('autoMoveCard'));
			}

			if (params.containsKey('winIndex'))
			{
				var winIndex	:	int = params.getInt('winIndex');
				var taken		:	int = params.getInt('taken');

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

			_game.gameType = params.getInt('gameType');

			if (params.getInt('gameType') != 2) _game.mcChat.visible = false;

			_game.currentHand = params.getInt('currentHand');

			if (params.containsKey('users'))
			{
				trace('resss');
				_game.manager.setPlayersIndex( params.getInt('index'), params.getSFSArray('users') ); // myindex
				_game.scoresTable.init(params.getSFSObject('gameInfo').getInt('tableType'),params.getSFSObject('gameInfo').getInt('level'), params.getInt('tableIndex'), params.getInt('index'), params.getSFSArray('users'))
			}
			else
			{
				_game.manager.setPlayersIndex( params.getInt('index') ); // myindex
				_game.scoresTable.init(params.getSFSObject('gameInfo').getInt('tableType'),params.getSFSObject('gameInfo').getInt('level'), params.getInt('tableIndex'), params.getInt('index'))
			}

			//_manager.setPlayersIndex( params.getInt('index') ); // myindex


			_game.scoresTable.restore(params.getSFSObject('resultTable'), _game.currentHand);

			_game.manager.distribute(params.getUtfStringArray('cards'), params.getUtfString('trump'));
			_game.manager.restoreLastMoveCards(params.getSFSArray('lastMoveCards'));

			_game.manager.setDealer(params.getInt('dealer'));

			_game.infoBar.setInfo(params.getSFSObject('gameInfo').getDouble('bet'), User.balance, _game.gameType);

			/*********MOVED CARDS RESTORE*******************/
			for (var i:int = 0; i < params.getSFSArray('oppMoves').size(); i++)
			{
				var actionMoves:ISFSObject = params.getSFSArray('oppMoves').getSFSObject(i);

				if (actionMoves.getInt('index') != params.getInt('index'))
				{
					_game.manager.oppMove(actionMoves.getInt('index'), actionMoves.getSFSObject('card'));
				}
				else
				{
					_game.manager.oppMove(actionMoves.getInt('index'), actionMoves.getSFSObject('card'));
				}
			}


			_game.updateHandStatus(params.getInt('handStatus'));


			/*****************BOARD ORDER RESTORE ***********/
			for (var index:int = 1; index <= 4; index++)
			{
				if (params.getSFSObject(index.toString()).containsKey('order') )
				{
					updateOrder(index , params.getSFSObject(index.toString()).getInt('order'), null, null, params.getInt('handStatus'));
				}

				if (params.getSFSObject(index.toString()).getInt('taken'))
				{
					_game.manager.setCurrentOrder(params.getSFSObject(index.toString()).getInt('taken'), index);
				}

				if (params.getSFSObject(index.toString()).containsKey('type'))
				{
					trace('tt:' + params.getSFSObject(index.toString()).getInt('type'))
					switchUser(index, params.getSFSObject(index.toString()).getInt('type'));
				}
			}


			/******MY ACTION RESTORE**********************/
			if (params.getSFSObject('move')) // svlis agdegan (minicheba)
			{
				var disCard:Array = params.getSFSObject('move').getUtfStringArray('disabledCards');
				var firstMove:Boolean = params.getSFSObject('move').getBool('firstMove');

				setMove(disCard, firstMove, params.getSFSObject('move').getSFSObject('autoMoveCard'));
			}
			else if (params.getSFSObject('orderTrump')) // kozeris cxadebis agdgena
			{
				_game.setOrderTrump(params.getSFSObject('orderTrump').getUtfString('autoOrderTrump'));
			}
			else if (params.getSFSObject('order')) // cxadebis agdgena
			{
				var max:int = params.getSFSObject('order').getInt('max');
				var restrict:int = params.getSFSObject('order').getInt('restrict');
				var fill:int = params.getSFSObject('order').getInt('fill');

				_game.setOrder( max, restrict, fill, params.getSFSObject('order').getInt('autoOrder'));
			}

			_game.gameTimer.restore(params.getInt('timer'), _game.manager.getPlayerPos( params.getInt('activePlayer') ) );

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
			_lobby.tournament.running.updateOnlinePlayers(param.getInt('activePlayers'));
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
				_game.setOrder( order.getInt('max'), order.getInt('restrict'), order.getInt('fill'), order.getInt('autoOrder'));
			}
			else if(move != null)
			{
				setMove( move.getUtfStringArray('disabledCards'), move.getBool('firstMove'), move.getSFSObject('autoMoveCard')  );
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