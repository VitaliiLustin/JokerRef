/**
 * Created by Vadim on 17.06.2015.
 */
package com.jokerbros.joker.connector {
import com.jokerbros.joker.Facade.Facade;
import com.jokerbros.joker.events.GameEvent;
import com.jokerbros.joker.game.GameProperties;
import com.jokerbros.joker.game.MainHandler;
import com.jokerbros.joker.models.DataModel;
import com.jokerbros.joker.models.GameModel;
import com.junkbyte.console.Cc;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.requests.JoinRoomRequest;
import com.smartfoxserver.v2.requests.LoginRequest;

import flash.events.Event;
import flash.events.EventDispatcher;

	public class Response extends EventDispatcher{

		public static const JOIN_LOBBY                  :String = "JOIN_LOBBY";
		public static const RESPONSE_PING				:String = 'PING';
		public static const RESPONSE_ON_JOIN_LOBBY		:String = 'ON_JOIN_LOBBY';
		public static const RESPONSE_RESTORE			:String = 'RESTORE';
		public static const MONITOR_STATE_KICK_WIND		:String = 'showKickWind';
		public static const MONITOR_STATE_LOST_WIND		:String = 'showLostWind';
		public static const MONITOR_STATE_HIDE_ALL		:String = 'hideAll';
		public static const MONITOR_STATE_START			:String = 'start';
		public static const MONITOR_STATE_STOP			:String = 'stop';

		private var _connectorSFS:Connector;
		private var _userData:DataModel;
		private var _stateBar:StateBar;
		private var _lagMonitor:MyLagMonitor;
		private var _dataRoom:ISFSObject;
		private var _smartFox:SmartFox;
		
		private var _tryConnect:Boolean = false;
		private var _gameModel:GameModel;

		private var lobbyCommands:Array = ["setUserCount","responseCreateRoom","responseJoinRoom","initLobby","addRoom",
			"removeRoom","busyRoom","freeRoom","updateGameHistory","updateRatingList","startGame","RESTORE",
			"userPlaceAction","freePlaceResponse","takePlaceResponse","updateBlackList"];

		public function Response(connect:Connector, gameModel:GameModel)
		{
			_connectorSFS = connect;
			_gameModel = gameModel;
			_smartFox = _connectorSFS.SFS;
		}

		public function init(userData:DataModel):void
		{
			_userData = userData;

			_smartFox.addEventListener(SFSEvent.LOGIN, onLogin);
			_smartFox.addEventListener(SFSEvent.LOGIN_ERROR, onLogin);
			_smartFox.addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);

			_lagMonitor = new MyLagMonitor();
			_lagMonitor.addEventListener(PingPongEvent.PING, onLagMonitor);
			_lagMonitor.addEventListener(PingPongEvent.BAD_NETWORK, onLagMonitor);
			_lagMonitor.addEventListener(PingPongEvent.TROUBLESHOOT, onLagMonitor);

			_stateBar = new StateBar();
			Facade.dispatcher.addEventListener(GameEvent.LOGIN, login)
		}

		private function onExtensionResponse(e:SFSEvent):void
		{
			trace('_Ext: ' + e.params.cmd);
			switch(e.params.cmd)
			{
				case RESPONSE_PING:
					_lagMonitor.onPingPong();
				break;
				case RESPONSE_ON_JOIN_LOBBY:
					trace("_SFS:"+ RESPONSE_ON_JOIN_LOBBY);
					_dataRoom = e.params.params;
					_userData.setData(Connector.PARAM_DATA_LOBBY, e.params.params);
					dispatchEvent(new Event(JOIN_LOBBY));
				break;
				case RESPONSE_RESTORE:
					trace("_SFS:" + RESPONSE_RESTORE);
					var dataRestore:SFSObject = e.params.params as SFSObject;
					trace(dataRestore.getDump());
					GameProperties.restore = true;
					if (MainHandler.lobby && MainHandler.game)
					{
						MainHandler.startGame(dataRestore);
					}
					else
					{
						_userData.setData(Connector.PARAM_DATA_LOBBY, dataRestore);
						dispatchEvent(new Event(JOIN_LOBBY));
					}
					break;
				default:
					if(_gameModel.inited)
					{
						if(MainHandler.lobby && MainHandler.lobby.visible)
						{
							if(lobbyCommands.indexOf(e.params.cmd) != -1)//have
							{
								mainHandler(e.params.cmd, e.params.params);
							}
						}
						else if(MainHandler.game && MainHandler.game.visible)
						{
							if(lobbyCommands.indexOf(e.params.cmd) == -1|| e.params.cmd == "startGame")//not have
							{
								mainHandler(e.params.cmd, e.params.params);
							}
						}
					}
					else
					{
						Cc.log("GLOBAL_ERROR: " + e);
					}
				break;
			}
		}

		public function mainHandler(cmd:String, param:ISFSObject):void
		{
			trace('_SFS: ' + cmd);
			switch( cmd )
			{
				//lobby
				case "setUserCount":
					MainHandler.updateOnlinePlayers(param.getInt('value').toString());
					break;

				case "responseCreateRoom":
					MainHandler.responseCreateRoom(param);
					break;

				case "responseJoinRoom":
					MainHandler.responseJoinRoom(param);
					break;

				case "initLobby":
					MainHandler.initLobby(param);
					break;

				case "addRoom":
					MainHandler.addRoom(param);
					break;

				case "removeRoom":
					MainHandler.removeRoom(param);
					break;

				case "busyRoom":
					MainHandler.busyRoom(param);
					break;

				case "freeRoom":
					MainHandler.freeRoom(param);
					break;

				case "updateGameHistory":
					MainHandler.updateGameHistory(param);
					break;

				case "updateRatingList":
					MainHandler.updateRatingList(param);
					break;

				case "updateBlackList":
					MainHandler.updateBlackList(param);
					break;

				case "takePlaceResponse":

					MainHandler.takePlaceResponse(param);
					break;

				case "freePlaceResponse":

					MainHandler.freePlaceResponse(param);
					break;

				case "userPlaceAction":

					MainHandler.userPlaceAction(param);
					break;

				case "RESTORE":
					MainHandler.startGame(param);
					break;

				//game
				case "gameToLobby":
					MainHandler.gameToLobby();
					break;

				case "updateOrder":
					MainHandler.updateOrder(param.getInt('index'), param.getInt('value'), param.getSFSObject('order'), param.getSFSObject('move'), param.getInt('handStatus'));
					break;

				case "startGame":
					GameProperties.restore = false;
					MainHandler.startGame(param);
					break;

				case "endGame":
					MainHandler.endGame(param);
					break;

				case "oppMove":
					MainHandler.oppMove(param);
					break;

				case "oppAction":
					MainHandler.oppAction(param.getInt('index'));
					break;

				case "startHand":
					MainHandler.startHand(param);
					break;

				case "setMove":
					MainHandler.setMove(param.getUtfStringArray('disabledCards'), param.getBool('firstMove'), param.getSFSObject('autoMoveCard'));
					break;

				case "updateTaken":
					MainHandler.updateTaken(param.getInt('value'), param.getInt('index'));
					break;

				case "switchUser":
					MainHandler.switchUser(param.getInt('index'), param.getInt('type'));
					break;

				//tournament
				case "responseTourReg":
						MainHandler.responseTourReg(param);
					break;

				case "responseTourUnReg":
					MainHandler.responseTourUnReg(param);
					break;

				case "responseTourFindOpp":
					MainHandler.responseTourFindOpp(param);
					break;

				case "responseTourCancelFindOpp":
					MainHandler.responseTourCancelFindOpp(param);
					break;

				case "tourUpdateTopPlayers":
					MainHandler.tourUpdateTopPlayers(param);
					break;

				case "tourUpdateActiveUsers":
					MainHandler.tourUpdateActiveUsers(param);
					break;

				case "tourUpdateList":
					MainHandler.tourUpdateList(param);
					break;

				case "tourInitState":
					MainHandler.tourInitState(param);
					break;

				case "tourUpdateRegUsers":
					MainHandler.tourUpdateRegUsers(param);
					break;

				//chat
				case "updateChatMessage":
					MainHandler.updateChatMessage( param.getUtfString('msg'), param.getInt('index') );
					break;

				case "updateChatStatus":
					MainHandler.updateChatStatus(param);
					break;
			}
		}

		private function onLogin(e:SFSEvent):void
		{
			if (e.type == SFSEvent.LOGIN)
			{
				_lagMonitor.start();
				_smartFox.send(new JoinRoomRequest(Connector.SEND_LOBBY));
			}
			else if (e.type == SFSEvent.LOGIN_ERROR)
			{
				_stateBar.showLoginErrorWind();
			}
		}

		public function login(e:GameEvent = null):void
		{
			var data:ISFSObject = SFSObject.newInstance();
			data.putUtfString('key', params.key);
			data.putBool(Connector.PARAM_RECONECT_IN_USE, _tryConnect);
			data.putBool(Connector.PARAM_RECONECT_IN_USE, false);

			_smartFox.send(new LoginRequest(params.username, '', params.zone, data));
		}

		private function onLagMonitor(e:PingPongEvent):void
		{
			if (e.type == PingPongEvent.PING)
			{
				_stateBar.updateNetworkStatus(e.params.lagValue);
			}
			else
			{
				_stateBar.showBadNetworkWind( e.type == PingPongEvent.BAD_NETWORK );
			}
		}

		public function lagMonitor(value:String):void {
			if (value == MONITOR_STATE_STOP)
			{
				_lagMonitor.stop();
			}
			else if (value == MONITOR_STATE_START)
			{
				_lagMonitor.start();
			}
		}

		public function stateMonitor(value:String):void
		{
			switch( value )
			{
				case MONITOR_STATE_KICK_WIND:
					_stateBar.showKickWind();
				break;
				case MONITOR_STATE_LOST_WIND:
					_stateBar.showLostWind();
				break;
				case MONITOR_STATE_HIDE_ALL:
					_stateBar.hideAll();
				break;
			}
		}

		public function clear():void
		{
			_smartFox.removeEventListener(SFSEvent.LOGIN, onLogin);
			_smartFox.removeEventListener(SFSEvent.LOGIN_ERROR, onLogin);
			_smartFox.removeEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);

			_lagMonitor.removeEventListener(PingPongEvent.PING, onLagMonitor);
			_lagMonitor.removeEventListener(PingPongEvent.BAD_NETWORK, onLagMonitor);
			_lagMonitor.removeEventListener(PingPongEvent.TROUBLESHOOT, onLagMonitor);
			_lagMonitor.clear();

			_stateBar.hideAll();
		}

		public function get dataRoom():ISFSObject 
		{
			return _dataRoom;
		}
		
		private function get params():Object
		{
			return _connectorSFS.params;
		}

	}
}
