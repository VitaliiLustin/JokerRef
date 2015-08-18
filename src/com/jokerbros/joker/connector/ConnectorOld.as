package  com.jokerbros.joker.connector
{
	/**
	 * ...
	 * @author JokerBros
	 */
	
	import com.jokerbros.joker.events.ConnectorEvent;
	import com.jokerbros.joker.user.*;
	import com.jokerbros.joker.utils.TyniHelper;
	import com.jokerbros.joker.windows.Reconnect;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.*;
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.entities.variables.*;
	import com.smartfoxserver.v2.requests.*;
	import com.smartfoxserver.v2.util.ClientDisconnectionReason;
	import com.smartfoxserver.v2.util.ConfigData; 

	
		
	import com.jokerbros.joker.events.*;
	import com.jokerbros.joker.windows.*;

	
	import flash.display.MovieClip;
	
	import flash.net.*;
	 
	public class ConnectorOld extends MovieClip
	{
		
		public static var sfs:SmartFox;
		
		public static var windowRetry:WindowRetryConnection;
		public static var windowDisconnect:*;
		
		private var reconnectionTime:int = 20;
		private var reconnectionTaskTime:int = 2;
		
		private var reconnectDelayTimer:Timer;
		private var reconnectCount:int = 1;
		
		private var username:String;
		private var key:String;
		private var host:String;
		private var port:int ;
		
		private var config:String;
		private var zone:String = 'jokerbeta';
		private var connectionType:int;
		private var  isReconnected:Boolean = false;
		private var _ping:Ping;
		
		////////////////////
		////////////////////!!!!!!!!!! gasatvaliswinebelia pirveli dakavshireba!
		//////////////////// !!!! ar izaxebs disconnectis events magito ar achvenebs internetis agdgenis fanjaras
		public function ConnectorOld( username:String='', key:String= '', config:String= '',  host:String = '80.92.177.244', port:int = 9933 )
		{
			ConnectorOld.sfs = new SmartFox();
			ConnectorOld.sfs.useBlueBox = false;
			ConnectorOld.sfs.debug = false;
			ConnectorOld.windowRetry = new WindowRetryConnection();
			
			_ping = new Ping();
			
			this.username = username;
			this.key = key;
			this.host = host;
			this.port = port;
			this.config = config;
			
			if (config == '') { this.connectionType = 1; }
			else { this.zone = ''; this.connectionType = 0; }
			
			this.initConnect();
		}
		
		
		private function events(act:Boolean = true):void
		{
			var func:String = (act)?'addEventListener':'removeEventListener';
		
			ConnectorOld.sfs[func](SFSEvent.CONNECTION, onConnection);
			ConnectorOld.sfs[func](SFSEvent.CONNECTION_LOST, onDisconnect);
			ConnectorOld.sfs[func](SFSEvent.LOGIN, onLogin);
			ConnectorOld.sfs[func](SFSEvent.LOGIN_ERROR, onLoginError);
			ConnectorOld.sfs[func](SFSEvent.ROOM_JOIN, onJoinRoom);
			ConnectorOld.sfs[func](SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);
			ConnectorOld.sfs[func](SFSEvent.PING_PONG, onPingPong);
			
		}
		
		private function initConnect():void
		{
			this.events(true);
			this.connect();
		}

		
		private function reInitSFS() : void
        {
            if (ConnectorOld.sfs != null) this.events(false);
			
			ConnectorOld.sfs = new SmartFox();
			
			this.events(true);
        }
		
		private function connect():void
		{
			if (!ConnectorOld.sfs.isConnected)
            {
				if (this.connectionType == 0)
				{
					ConnectorOld.sfs.loadConfig(this.config);
				}
				else
				{
					ConnectorOld.sfs.connect(this.host, this.port);
					ConnectorOld.sfs.useBlueBox = false;
				}
            }
		}
		
		
		private function reconnectDelay():void
		{
			this.reconnectDelayTimer = new Timer(TyniHelper.randomIntBetween(3000, 7000), 1)
			this.reconnectDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.completeReconnectDelay);
			this.reconnectDelayTimer.start();	
		}
		
		private function destroyReconnectDelay():void
		{
			if (this.reconnectDelayTimer != null)
			{
				if (this.reconnectDelayTimer.running) this.reconnectDelayTimer.stop();
				this.reconnectDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.completeReconnectDelay);
				this.reconnectDelayTimer = null;
			}
		}
		
		private function completeReconnectDelay(e:TimerEvent):void 
		{
			this.destroyReconnectDelay();
			
			// restore Count
			this.reconnectCount ++;
			
			if (this.reconnectCount == 20)
			{
				//navigateToURL(new URLRequest("http://jokerbros.com/"), "_self");
				return;
			}
			
			this.reconnet();
			
			
			
		}
		
		private function reconnet():void
        {
			trace('Reconnet');
            this.reInitSFS();
            this.connect();
			
        }

		private function onConnection(e:SFSEvent):void
		{			
			
			trace('sfsOnConnection');
			
			if (e.params.success)
			{
				if (this.isReconnected)
				{
					// clear loading
					
					this.reconnectCount = 0;
					
					ConnectorOld.windowRetryHide();
					
					ReportException.send('RESTORE', 0, 'CONNECTOR');
					
				}
			}
			else
			{
				//this.Reconnet();
				this.reconnectDelay();
				return;
			}
			
			if (ConnectorOld.sfs.isConnected)
            {
				this.login();		
            }
			
			this.isReconnected = false;
			
		}
		
		
		private function onDisconnect(e:SFSEvent) : void
		{	
			trace('||||||||||| DISCONNECT ' + e.params.reason);
			
			
			_ping.pingStop();
			
			if (e.params.reason == ClientDisconnectionReason.KICK)
			{
				//navigateToURL(new URLRequest("http://jokerbros.com/"), "_self");
				return;
			}
			
			// show loading
			ConnectorOld.windowRetryShow('Reconnect');
			
			this.isReconnected = true;
			this.reconnet();
			
			
		}
		
		private function onLogin(evt:SFSEvent) : void
		{
			ConnectorOld.sfs.enableLagMonitor(true);
			
			_ping.pingStart();
			
			this.joinRoom();	
		}
		
		private function onLoginError(evt:SFSEvent) : void
		{
			//navigateToURL(new URLRequest("http://jokerbros.com/"), "_self");
		}
		
		private function onJoinRoom(evt:SFSEvent) : void
		{	
			//if (evt.params.room.name == 'lobby'){ dispatchEvent( new ConnectorEvent( ConnectorEvent.START) ); }
		}
		
		
		private function onExtensionResponse(evt:SFSEvent):void
		{
			if (evt.params.cmd == "PING") { _ping.pingResponse(); }
			else if (evt.params.cmd == "ON_JOIN_LOBBY") { dispatchEvent( new ConnectorEvent( ConnectorEvent.START) ); }
			else dispatchEvent( new ConnectorEvent( ConnectorEvent.RESPONSE, evt ) );
		}
		
		
		private function onPingPong(evt:SFSEvent):void
		{
			//trace('Pong: ' + evt.params.lagValue);
		}
		
		
		public static function send(handler:String, data:ISFSObject=null):void
		{
			ConnectorOld.sfs.send(new ExtensionRequest(handler, data));
		}
		
		private function login() : void
		{
			var logData:ISFSObject = SFSObject.newInstance();
				logData.putUtfString("key", this.key);
				logData.putBool("reconnectInUse", this.isReconnected);
			
			ConnectorOld.sfs.send(new LoginRequest(this.username, "", this.zone, logData));
		}
		
		private function joinRoom() : void
		{
			ConnectorOld.sfs.send(new JoinRoomRequest("lobby"));
		}

		
		public static function windowRetryShow(msg:String = ''):void
		{
			if (msg != '') ConnectorOld.windowRetryText(msg);
			
			if (!Joker.STAGE.contains(ConnectorOld.windowRetry)) Joker.STAGE.addChild(ConnectorOld.windowRetry);
			
			User.soundOn(false);
		}
		
		public static function windowRetryHide():void
		{
			if (Joker.STAGE.contains(ConnectorOld.windowRetry)) Joker.STAGE.removeChild(ConnectorOld.windowRetry);
			
			if(!User.soundEnabled) User.soundOn(true);
		}
		
		private static function windowRetryText(txt:String):void
		{
			ConnectorOld.windowRetry.updateText(txt);
		}
		
			public static function joinRoom(roomID:String, password:String=''):void
		{
			var data:ISFSObject = new SFSObject(); 
				data.putUtfString('room', roomID);
				
				if (password != '') data.putUtfString('password', password);
				
			ConnectorOld.send('joinRoomHandler', data);
		}
		
	}

}