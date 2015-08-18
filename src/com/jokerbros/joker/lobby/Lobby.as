package  com.jokerbros.joker.lobby
{
	import com.jokerbros.joker.connector.Connector;
	import com.jokerbros.joker.events.AlertEvent;
	import com.jokerbros.joker.events.ChangeRoomTypeEvent;
	import com.jokerbros.joker.events.CreateRoomEvent;
	import com.jokerbros.joker.events.GameEvent;
	import com.jokerbros.joker.events.JoinRoomEvent;
	import com.jokerbros.joker.events.LobbyEvent;
	import com.jokerbros.joker.events.TableOfRoomsEvent;
	import com.jokerbros.joker.events.WaitingListEvent;
	import com.jokerbros.joker.events.WindEnterPassEvent;
	import com.jokerbros.joker.events.WindGameHistoryEvent;
	import com.jokerbros.joker.events.WindRatingEvent;
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.game.GameProperties;
	import com.jokerbros.joker.game.MainHandler;
	import com.jokerbros.joker.lobby.tournament.Tournament;
	import com.jokerbros.joker.lobby.windows.Alert;
	import com.jokerbros.joker.lobby.windows.CreateRoom;
	import com.jokerbros.joker.lobby.windows.WindBlackList;
	import com.jokerbros.joker.lobby.windows.WindEnterPass;
	import com.jokerbros.joker.lobby.windows.WindGameHistory;
	import com.jokerbros.joker.lobby.windows.WindHelp;
	import com.jokerbros.joker.lobby.windows.WindRating;
	import com.jokerbros.joker.user.User;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import com.greensock.TweenNano;

	/**
	 * ...
	 * @author JokerBros
	 */
	public class Lobby extends mcLobby
	{
		private const FUN_GAME:int = 2;
		private const CASH_GAME:int = 1;

		private var _gameType				:   int = 0;
		private var _roomType				:   int = 0;
		
		private var _header					:   Header;
		private var _tableOfRooms			:	TableOfRooms;
		private var _createRoomPopUP		:	CreateRoom;
		private var _windEnterPass			:	WindEnterPass;
		private var _alert					:	Alert;
		private var _waitingList			:	WaitingList;
		private var _userMenu				:   UserMenu;
		private var _gameHistory			:   WindGameHistory;
		private var _windRating				:   WindRating;
		private var _windBlackList			:   WindBlackList;
		private var _windHelp				:   WindHelp;
		private var _changeGameType			:   ChangeGameType;
		private var _changeRoomType			:   ChangeRoomType;
		private var _tournament				:   Tournament;
		private var _whiteGame			    :   WhiteGame;
		
		private var _joinPublicRoom			:   JoinPublicRoom;
		
		private var _initParams:ISFSObject;

		public function Lobby(params:ISFSObject)
		{
			_initParams = params;
		}

		public function init(e:Event = null):void
		{
			if (stage)
			{
				start();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}

		private function start():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			stage.addEventListener(Event.RESIZE, resizeLobby);
			
			Facade.dispatcher.addEventListener(LobbyEvent.SHOW_GAME_HISTORY, showGameHistory);
			Facade.dispatcher.addEventListener(LobbyEvent.SHOW_RATING, showRating);
			Facade.dispatcher.addEventListener(LobbyEvent.CHANGE_GAME_TYPE, onChangeGameType);
			Facade.dispatcher.addEventListener(LobbyEvent.CHANGE, onChangeRoomType);
			Facade.dispatcher.addEventListener(LobbyEvent.REMOVE_ROOM, removeMyRoom);
			
			
			initProgress();
			
			// init change games tab
			_header = Header.factory(1, mcHeader);
			
			// init user menu
			_userMenu = new UserMenu(userMenu);
			
			//mcWhiteFreeGame
			_whiteGame = new WhiteGame(mcWhiteGame);
			
			// init change game type
			_changeGameType = new ChangeGameType(changeGameType);
			
			// init change game type
			_changeRoomType = new ChangeRoomType(changeRoomType);
			changeRoomType.visible = false;
			
			// init waiting list
			_waitingList = new WaitingList(waitingList);
			
			// init tournament
			_tournament = new Tournament(mcTournament, mcLobbyProgress);
			
			// init table	
			_tableOfRooms = new TableOfRooms(mcPrivateTableOfRooms);
			_tableOfRooms.addEventListener(TableOfRoomsEvent.SIT_PUBLIC_ROOM, onJoinPublicRoom);
			_tableOfRooms.addEventListener(TableOfRoomsEvent.SIT_RPIVATE_ROOM, onJoinPrivateRoom);
			_tableOfRooms.addEventListener(TableOfRoomsEvent.REMOVE_MY_ROOM, removeMyRoom);
			
			mcPreInitGame.visible = false;
			
			btnCreateRoom.visible = false;
			btnCreateRoom.addEventListener(MouseEvent.CLICK, onOpenCreateRoomPopUP);

			_joinPublicRoom = new JoinPublicRoom(this.mcJoinRoomCash, mcJoinRoomFun);
			_joinPublicRoom.addEventListener(JoinRoomEvent.FREE_PLACE, userFreePlace);
			_joinPublicRoom.addEventListener(JoinRoomEvent.TAKE_PLACE, userTakePlace);
			_joinPublicRoom.addEventListener(JoinRoomEvent.SHOW_BLACK_LIST, showBlackList);
			_joinPublicRoom.addEventListener(JoinRoomEvent.SHOW_HELP, showHelp);
			
			mcPrivateTableOfRooms.visible = false;

			initGraphics();
			resizeLobby();

			MainHandler.initHandlerLobby(this);
			if(!GameProperties.restore)
			{
				Connector.send(Connector.SEND_INIT_LOBBY);
			}
		}
		
		private function onChangeRoomType(e:GameEvent):void 
		{
			_roomType = int(e.data);
			
			if (_roomType == 1) // public
			{
				mcOnlinePlayers.visible = true;
				mcPrivateTableOfRooms.visible = false;
				_joinPublicRoom.enable(true);
			}
			else if (_roomType == 2) // private
			{
				mcPrivateTableOfRooms.visible = true;
				_joinPublicRoom.enable(false);
			}
			
		}
		
		private function onChangeGameType(e:GameEvent):void 
		{
			showProgress();
			var data:ISFSObject = new SFSObject();
			data.putInt('gameType', int(e.data));
			Connector.send('changeGame', data);
		}

		private function showBlackList(e:JoinRoomEvent):void 
		{
			_windBlackList = new WindBlackList();
			_windBlackList.addEventListener(WindGameHistoryEvent.CLOSE, hideBlackList);
			addChild(_windBlackList);
		}
		
		private function showHelp(e:JoinRoomEvent):void 
		{
			_windHelp = new WindHelp();
			_windHelp.addEventListener(WindGameHistoryEvent.CLOSE, hideHelp);
			addChild(_windHelp);
		}
		
		private function hideBlackList(e:Event):void
		{
			if (_windBlackList)
			{
				_windBlackList.removeEventListener(WindGameHistoryEvent.CLOSE, hideBlackList);
				if (contains(_windBlackList))
				{
					removeChild(_windBlackList);
				}
				_windBlackList = null;
			}
		}
		
		private function hideHelp(e:Event):void
		{
			if (_windHelp)
			{
				_windHelp.removeEventListener(WindGameHistoryEvent.CLOSE, hideBlackList);
				if (contains(_windHelp))
				{
					removeChild(_windHelp);
				}
				_windHelp = null;
			}
		}

		private function userTakePlace(e:JoinRoomEvent):void 
		{
			showProgress();
			var data:ISFSObject = new SFSObject();
			data.putInt('level', e.data.level);
			data.putUtfString('type', e.data.type);
			//trace("sendeing "+ e.data.level+" "+e.data.type )
			Connector.send('takePlace', data);
		}
		
		private function userFreePlace(e:JoinRoomEvent):void 
		{
			showProgress();
			var data:ISFSObject = new SFSObject();
			data.putInt('level', e.data.level);
			data.putUtfString('type', e.data.type);
			Connector.send('freePlace', data);
		}

		private function showGameHistory(e:LobbyEvent = null):void
		{
			_gameHistory = new WindGameHistory();
			_gameHistory.addEventListener(WindGameHistoryEvent.CLOSE, hideGameHistory);
			_gameHistory.alpha = 0;
			addChild(_gameHistory);
			
			TweenNano.to(_gameHistory, 0.1, {alpha:1} );
		}
		
		private function hideGameHistory(e:WindGameHistoryEvent = null):void
		{
			if (_gameHistory)
			{
				if (contains(_gameHistory))
				{
					removeChild(_gameHistory);
				}
				_gameHistory.removeEventListener(WindGameHistoryEvent.CLOSE, hideGameHistory);
				_gameHistory = null;
			}
		}

		private function showRating(e:LobbyEvent = null):void
		{
			_windRating = new WindRating();
			_windRating.addEventListener(WindRatingEvent.CLOSE, hideRating);
			_windRating.alpha = 0;
			addChild(_windRating);
			
			TweenNano.to(_windRating, 0.1, {alpha:1} );
		}
		
		private function hideRating(e:WindRatingEvent = null):void
		{
			if (_windRating)
			{
				if (contains(_windRating))
				{
					removeChild(_windRating);
				}
				_windRating.removeEventListener(WindRatingEvent.CLOSE, hideRating);
				_windRating = null;
			}
		}

		private function onOpenCreateRoomPopUP(e:MouseEvent = null):void 
		{
			btnCreateRoom.removeEventListener(MouseEvent.CLICK, onOpenCreateRoomPopUP);
			
			_createRoomPopUP = new CreateRoom(_gameType);
			_createRoomPopUP.addEventListener(CreateRoomEvent.RESPONSE, onResponseCreateRoom);
			_createRoomPopUP.alpha = 0;
			addChild(_createRoomPopUP);
			
			TweenNano.to(_createRoomPopUP, 0.1, {alpha:1} );
		}
		
		private function onResponseCreateRoom(e:CreateRoomEvent):void 
		{
			_createRoomPopUP.removeEventListener(CreateRoomEvent.RESPONSE, onResponseCreateRoom);
			removeChild(_createRoomPopUP);
			_createRoomPopUP = null;
			
			if (e.data != false)
			{
				btnCreateRoom.visible = false;
				_waitingList.show(e.data.roomID, e.data.roomPassword);
			}
			else
			{
				btnCreateRoom.addEventListener(MouseEvent.CLICK, onOpenCreateRoomPopUP)
			}
		}
		
		private function showWindEnterPass(roomID:String):void
		{
			_windEnterPass = new WindEnterPass(roomID);
			_windEnterPass.addEventListener(WindEnterPassEvent.RESPONSE, onResponseWindEnterPass);
			_windEnterPass.alpha = 0;
			addChild(_windEnterPass);
			
			TweenNano.to(_windEnterPass, 0.1, {alpha:1} );
		}
		
		public function hideWindEnterPass():void
		{
			if (_windEnterPass)
			{
				_windEnterPass.removeEventListener(WindEnterPassEvent.RESPONSE, onResponseWindEnterPass);
				removeChild(_windEnterPass);
				_windEnterPass = null;
			}
		}

		private function onJoinPublicRoom(e:TableOfRoomsEvent = null):void 
		{
			showProgress();
			joinRoom(e.data.roomName);
		}
		
		private function onJoinPrivateRoom(e:TableOfRoomsEvent):void 
		{
			showWindEnterPass(e.data.roomName)
		}
		
		private function onResponseWindEnterPass(e:WindEnterPassEvent):void 
		{
			if (e.data == false)
			{
				hideWindEnterPass();
				_tableOfRooms.init();
			}
			else
			{
				joinRoom(e.data.roomID, e.data.password);
			}
		}

		private function joinRoom(roomID:String, password:String=''):void
		{
			var data:ISFSObject = new SFSObject();
			data.putUtfString('room', roomID);
			if (password != '') data.putUtfString('password', password);

			Connector.send(Connector.SEND_JOIN_ROOM, data);
		}
		
		private function removeMyRoom(e:Event):void 
		{
			Connector.send("removeRoom");
			_waitingList.hide();
			btnCreateRoom.visible = true;
			btnCreateRoom.addEventListener(MouseEvent.CLICK, onOpenCreateRoomPopUP)
		}

		public function showAlert(msg:String=''):void
		{
			_alert = new Alert();
			_alert.setMessage(msg);
			_alert.addEventListener(AlertEvent.CLOSE, hideAlert);
			_alert.alpha = 0;
			addChild(_alert);
			TweenNano.to(_alert, 0.1, {alpha:1} );
		}
		
		public function hideAlert(e:Event):void
		{
			_tableOfRooms.init();
			_alert.removeEventListener(AlertEvent.CLOSE, hideAlert);
			removeChild(_alert);
			_alert = null;
		}
		
		public function setUserInfo(params:ISFSObject):void
		{
			//update user information
			User.username = params.getUtfString("username");
			User.pin 	  = params.getUtfString("pin");
			User.balance  = params.getDouble("balance");
			User.rating   = params.getDouble("rating").toString();
			_userMenu.updateInfo(_gameType);
		}
		
		
		private function initGraphics():void
		{
			//var arialName:String = new Arial().fontName;
			//
			//this.mcOnlinePlayers.value.embedFonts = true;
			//this.mcOnlinePlayers.value.antiAliasType = AntiAliasType.ADVANCED;
			//this.mcOnlinePlayers.value.setTextFormat( new TextFormat(arialName) );
			//
			//this.mcPreInitGame.title.embedFonts = true;
			//this.mcPreInitGame.title.antiAliasType = AntiAliasType.ADVANCED;
			//this.mcPreInitGame.title.setTextFormat( new TextFormat(new BGPArial().fontName) );
		}
		
		private function resizeLobby(e:Event = null):void
		{
			mcLobbyProgress.mcModal.x = -stage.stageWidth / 2;
			mcLobbyProgress.mcModal.y = -stage.stageHeight / 2 - 200;
			mcLobbyProgress.mcModal.width = int(stage.stageWidth + 500);
			mcLobbyProgress.mcModal.height = int(stage.stageHeight + 500);
		}
		
		public function destroy():void
		{
			if (stage) {
				stage.removeEventListener(Event.RESIZE, resizeLobby);
			}
			
			btnCreateRoom.removeEventListener(MouseEvent.CLICK, onOpenCreateRoomPopUP);
			mcPreInitGame.btnPersonalInfo.removeEventListener(MouseEvent.CLICK, goEditPersonalInfo);
			
			Facade.dispatcher.removeEventListener(LobbyEvent.SHOW_GAME_HISTORY, showGameHistory);
			Facade.dispatcher.removeEventListener(LobbyEvent.SHOW_RATING, showRating);
			Facade.dispatcher.removeEventListener(LobbyEvent.CHANGE_GAME_TYPE, onChangeGameType);

			if (_header)
			{
				_header.destroy();
				_header = null;
			}
			
			if (_userMenu)
			{	
				_userMenu.destroy();
				_userMenu = null;
			}

			if (_changeGameType)
			{
				_changeGameType.destroy();
				_changeGameType = null;
			}

			if (_waitingList)
			{
				Facade.dispatcher.removeEventListener(LobbyEvent.REMOVE_ROOM, removeMyRoom);
				//_waitingList.removeEventListener(LobbyEvent.REMOVE_ROOM, removeMyRoom);
				_waitingList.destroy();
				_waitingList = null
			}

			if (_tableOfRooms)
			{
				_tableOfRooms.removeEventListener(TableOfRoomsEvent.SIT_PUBLIC_ROOM, onJoinPublicRoom);
				_tableOfRooms.removeEventListener(TableOfRoomsEvent.SIT_RPIVATE_ROOM, onJoinPrivateRoom);
				_tableOfRooms.removeEventListener(TableOfRoomsEvent.REMOVE_MY_ROOM, removeMyRoom);
				_tableOfRooms.destroy();
				_tableOfRooms = null;
			}

			if (_createRoomPopUP)
			{
				_createRoomPopUP.removeEventListener(CreateRoomEvent.RESPONSE, onResponseCreateRoom);
				_createRoomPopUP = null;
			}
			
			if (_windEnterPass)
			{
				_windEnterPass.removeEventListener(WindEnterPassEvent.RESPONSE, onResponseWindEnterPass);
				_windEnterPass = null;
			}
			
			if (_alert)
			{
				_alert.removeEventListener(AlertEvent.CLOSE, hideAlert);
				_alert = null;
			}
			
			if (_gameHistory)
			{
				_gameHistory.removeEventListener(WindGameHistoryEvent.CLOSE, hideGameHistory);
				_gameHistory = null;
			}
			
			if (_windRating)
			{
				_windRating.removeEventListener(WindRatingEvent.CLOSE, hideRating);
				_windRating = null;
			}
			
			if (_windBlackList)
			{
				_windBlackList.removeEventListener(WindGameHistoryEvent.CLOSE, hideBlackList);
				_windBlackList = null;
			}

			if (_changeRoomType)
			{
				//_changeRoomType.removeEventListener(ChangeRoomTypeEvent.CHANGE, onChangeRoomType);
				Facade.dispatcher.removeEventListener(LobbyEvent.CHANGE, onChangeRoomType);
				_changeRoomType.destroy();
				_changeRoomType = null;
			}
			
			if (_joinPublicRoom)
			{
				_joinPublicRoom.removeEventListener(JoinRoomEvent.FREE_PLACE, userFreePlace);
				_joinPublicRoom.removeEventListener(JoinRoomEvent.TAKE_PLACE, userTakePlace);
				_joinPublicRoom.removeEventListener(JoinRoomEvent.SHOW_BLACK_LIST, showBlackList);
				_joinPublicRoom.removeEventListener(JoinRoomEvent.SHOW_HELP, showHelp);
				_joinPublicRoom.clear();
				_joinPublicRoom = null;
			}
		}

		private function initProgress():void
		{
			mcLobbyProgress.mcModal.alpha = 0.3;
			mcLobbyProgress.visible = true;
		}
		
		private function showProgress():void
		{
			mcLobbyProgress.visible = true;
		}
		
		public function hideProgress():void
		{
			mcLobbyProgress.visible = false;
		}

		public function showPreInitCashGame(isEditInfo:Boolean,  txt:String=''):void
		{
			mcPreInitGame.visible = true;
			if (isEditInfo)
			{
				mcPreInitGame.btnPersonalInfo.visible = true;
				mcPreInitGame.btnPersonalInfo.addEventListener(MouseEvent.CLICK, goEditPersonalInfo);
			}
			else
			{
				mcPreInitGame.btnPersonalInfo.visible = false;
			}
			mcPreInitGame.title.text = txt;
		}
		
		public function hidePreInitCashGame():void
		{
			mcPreInitGame.title.text = '';
			mcPreInitGame.btnPersonalInfo.removeEventListener(MouseEvent.CLICK, goEditPersonalInfo);
			if (mcPreInitGame.visible)
			{
				mcPreInitGame.visible = false;
			}
		}
		
		private function goEditPersonalInfo(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://jokerbros.com/profile/setInfo"), "_self");
		}

		public function get tableOfRooms():TableOfRooms {
			return _tableOfRooms;
		}

		public function get createRoomPopUP():CreateRoom {
			return _createRoomPopUP;
		}

		public function get header():Header {
			return _header;
		}

		public function set createRoomPopUP(value:CreateRoom):void {
			_createRoomPopUP = value;
		}

		public function get windEnterPass():WindEnterPass {
			return _windEnterPass;
		}

		public function get alert():Alert {
			return _alert;
		}

		public function get _WaitingList():WaitingList {
			return _waitingList;
		}

		public function get _UserMenu():UserMenu {
			return _userMenu;
		}

		public function get gameHistory():WindGameHistory {
			return _gameHistory;
		}

		public function get windRating():WindRating {
			return _windRating;
		}

		public function get windBlackList():WindBlackList {
			return _windBlackList;
		}

		public function get windHelp():WindHelp {
			return _windHelp;
		}

		public function get _ChangeGameType():ChangeGameType {
			return _changeGameType;
		}

		public function get _ChangeRoomType():ChangeRoomType {
			return _changeRoomType;
		}

		public function get tournament():Tournament {
			return _tournament;
		}

		public function get whiteGame():WhiteGame {
			return _whiteGame;
		}

		public function get joinPublicRoom():JoinPublicRoom {
			return _joinPublicRoom;
		}

		public function get gameType():int {
			return _gameType;
		}

		public function get roomType():int {
			return _roomType;
		}

		public function set gameType(value:int):void {
			_gameType = value;
		}
	}
}