package com.jokerbros.joker.connector
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.util.ClientDisconnectionReason;

	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class Connector extends EventDispatcher
	{
		public static const DATA_TYPE_BOOLEAN	:int = 1;
		public static const DATA_TYPE_INT		:int = 2;
		public static const DATA_TYPE_NUMBER	:int = 3;
		public static const DATA_TYPE_STRING	:int = 4;

		public static const INITED:String = "SFSmodelInited";
		
		public static const SEND_LOBBY				:String = 'lobby';
		public static const SEND_INIT_LOBBY			:String = 'initLobby';
		public static const SEND_CREATE_ROOM        :String = 'createRoom';
		public static const SEND_JOIN_ROOM          :String = 'joinRoom';
		public static const PARAM_PARAM				:String = 'param';
		public static const PARAM_RECONECT_IN_USE	:String = 'reconnectInUse';
		public static const PARAM_DATA_LOBBY		:String = 'dataLobby';
		
		public static const PING_HANDLER:String = 'Ping';
		
		private static const CONNECT_DELAY	:int = 3 ;// second
		private static const MAX_TRY_CONNECT:int = 20 ;// second
		
		private var _params:Object;

		//Smart Fox Constants
		private static const IS_DEBUG		:Boolean = false;
		private static const USE_BLUE_BOX	:Boolean = false;
		//-------------------

		public static const LAG_MONITOR_STOP:String = "LagMonitorStop";
		public static const STATE_BAR:String = "StateBarLobby";
		
		private var _connectDelayTimer:Timer;
		private var _tryConnectCount:int = 0;
		private var _tryConnect:Boolean = false;
		
		private static var _smartFox:SmartFox;
		
		private static var _instance:Connector;


		public static function get instance():Connector
		{
			if (!_instance) {
				_instance = new Connector();
			}

			return _instance;
		}

		public function Connector():void
		{
			if (!_instance) {
				_instance = this;
			}else {
				throw new Error('Use singleton instance');
			}
		}

		public function init(params:Object):void
		{
			_smartFox = new SmartFox();
			_smartFox.useBlueBox = USE_BLUE_BOX;
			_smartFox.debug = IS_DEBUG;
			_smartFox.addEventListener(SFSEvent.CONNECTION, onConnection);
			_smartFox.addEventListener(SFSEvent.CONNECTION_LOST, onDisconnect);

			_params = params;

			_connectDelayTimer = new Timer(Connector.CONNECT_DELAY * 1000, 1);
			_connectDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, connect);

			connect();
		}
		
		public static function send(handler:String, data:*=null, dataType:int=0):void
		{
			var sendData:ISFSObject;
			
			if (dataType != 0)
			{
				sendData = SFSObject.newInstance();
				
				switch (dataType) 
				{
					case DATA_TYPE_BOOLEAN:
						sendData.putBool(PARAM_PARAM, data); 
					break;
					case DATA_TYPE_INT:
						sendData.putInt(PARAM_PARAM, data); 
					break;
					case DATA_TYPE_NUMBER: 
						sendData.putDouble(PARAM_PARAM, data); 
					break;
					case DATA_TYPE_STRING:
						sendData.putUtfString(PARAM_PARAM, data);
					break;
				}
			}
			else
			{
				sendData = data;
			}

			if(handler != SEND_CREATE_ROOM)
			{
				handler += 'Handler';
			}

			_smartFox.send(new ExtensionRequest(handler, sendData));

			if (handler != 'PingHandler')
			{
				trace('SEND: ' + handler + ", data :" + data);
			}
		}
		
		/*-----------------------------------------------------------------------------------------------------------------------*/
		private function connect(e:TimerEvent = null, delay:Boolean=false):void
		{
			if (_smartFox.isConnected) return;
			
			//delay
			if (delay)
			{
				if (_connectDelayTimer.running)
				{
					_connectDelayTimer.reset();
				}
				
				_connectDelayTimer.start();
				return;
			}
			
			// check try connect
			if (_tryConnect)
			{
				if (_tryConnectCount > Connector.MAX_TRY_CONNECT)
				{
					dispatchEvent(new DataEvent(STATE_BAR,false,false,"showLostWind"));
//					_stateBar.showLostWind();
					return;
				}
				
				_tryConnectCount++
			}

			//connect
			if (_params.config != null) //with config
			{
				_smartFox.loadConfig(_params.config);
			}
			else //only dev
			{
				_smartFox.connect(_params.host, _params.port);
			}

		}
		private function onConnection(e:SFSEvent):void
		{
			trace('onConnection: ');
			
			if (_smartFox.isConnected)
			{
				if (_tryConnect)
				{
					_tryConnectCount = 0;
					dispatchEvent(new DataEvent(STATE_BAR,false,false,"hideAll"));
				}
				dispatchEvent(new Event(INITED));
			}
			else
			{
				connect(null, true);
			}
		}
		
		private function onDisconnect(e:SFSEvent):void
		{
			trace('onDisconnect: ');
			
			dispatchEvent(new Event(LAG_MONITOR_STOP));

			if (e.params.reason == ClientDisconnectionReason.KICK)
			{
				dispatchEvent(new DataEvent(STATE_BAR,false,false,"showKickWind"));
				return;
			}
			
			_tryConnect = true;
			connect(null, true);
		}
		
		public function clear():void
		{
			_smartFox.removeEventListener(SFSEvent.CONNECTION, onConnection);
			_smartFox.removeEventListener(SFSEvent.CONNECTION_LOST, onDisconnect);

			_connectDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, connect);
			_connectDelayTimer.reset();
		}
		
		public function get params():Object {
			return _params;
		}

		public function get SFS():SmartFox{
			return _smartFox;
		}
		
	}

}