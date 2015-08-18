package 
{
	import com.jokerbros.joker.connector.Connector;
	import com.jokerbros.joker.events.*;
	import com.jokerbros.joker.game.Game;
	import com.jokerbros.joker.game.pt.PointTable;
	import com.jokerbros.joker.lobby.Lobby;
	import com.jokerbros.joker.user.User;
	import com.jokerbros.joker.windows.EndGame;
	import com.jokerbros.joker.windows.SendReport;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	import flash.system.Security;
	
	
	import com.greensock.TweenNano;
	import com.greensock.easing.*;
	
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.requests.*;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		private var _con				:	Connector;
		private var _lobby				:	Lobby;
		private var _game				:	Game;

		public static var STAGE			:	Stage;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			// entry point
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(Event.RESIZE, this.resizeGame);
			
			SoundMixer.soundTransform = new SoundTransform(0.25);
			
			
			Main.STAGE = stage;
			
			try 
			{
				if (this.loaderInfo.parameters.username != null && this.loaderInfo.parameters.key != null && this.loaderInfo.parameters.config != null)
				{
					_con=  new Connector(this.loaderInfo.parameters.username, this.loaderInfo.parameters.key, this.loaderInfo.parameters.config);
				}
				else
				{
					_con=  new Connector('debuguser', 'debuguser');	
				}
				
				_con.addEventListener(ConnectorEvent.START, onStart);
				_con.addEventListener(ConnectorEvent.RESPONSE, onResponse);
				
			}
			catch (err:Error){}
			
		}
		
		
		private function onStart(connectorEvent:ConnectorEvent):void 
		{		
			initLobby();
			removeLoading();
		}
		
		
		private function onResponse(connectorEvent:ConnectorEvent):void 
		{
			var cmd		:	String 		= 	connectorEvent.data.params.cmd;
			var params	:	ISFSObject 	= 	connectorEvent.data.params.params;
			
			if ( _lobby!= null ) 		_lobby.action(cmd, params);
			else if ( _game != null ) 	_game.action(cmd, params);
		
			// agdgena mxolod roca tamashi mimdinarobs - tu lobbyshia isev aketebs initLobbys
			if (cmd == "RESTORE") 	{ startGame(params, true); removeLoading(); }	
		}
		
		
		private function initLobby():void
		{
			resetLobby();
			resetGame();
			
			_lobby = new Lobby();
			_lobby.addEventListener(LobbyEvent.START_GAME, onStartGame);
			addChild( _lobby );	

			resizeGame();
			
		}
		
		private function onStartGame(event:LobbyEvent):void 
		{
			this.startGame( event.data as ISFSObject );
		}
		
		
		private function startGame( params:ISFSObject, isRestored:Boolean = false ):void
		{
			resetLobby();
			resetGame();
			
			_game = new Game();
			_game.addEventListener(GameEvent.GAME_TO_LOBBY, onGameToLobby);
			addChild( _game );

			User.tableID 		= 	params.getSFSObject('gameInfo').getUtfString('roomId');
			User.username 		= 	params.getSFSObject('clientInfo').getUtfString('username');
			User.myIndex 		= 	params.getInt('index');
			
			User.balance     	=   params.getSFSObject('clientInfo').getDouble('balance');
			User.gameType     	=   params.getInt('gameType');
			User.bet     		=   params.getSFSObject('gameInfo').getInt('bet');
			
			if (isRestored == false)
			{
				_game.init( params );	
			}
			
			else
			{
				_game.restore( params );
			}
			
			resizeGame();
		}
		
		// გამოიძახება როდესაც მაგიდიდან გადავდივარ ლობიში	
		private function onGameToLobby(event:GameEvent) : void
		{
			this.initLobby();
			
			try{ stage.displayState = StageDisplayState.NORMAL; } 
			catch (err:Error){}
		}
		
		private function resetLobby():void
		{
			if (_lobby!=null)
			{
				_lobby.destroy();
				_lobby.removeEventListener(LobbyEvent.START_GAME, onStartGame);
				if (contains( _lobby )) {
					removeChild( _lobby );
				}
				_lobby = null;
			}
		}
		
		private function resetGame():void
		{
			if ( _game != null )
			{
				_game.destroy();
				_game.removeEventListener(GameEvent.GAME_TO_LOBBY, onGameToLobby);
				if (contains(_game)) {
					removeChild( _game );
				}
				_game = null;	
			}
		}
		
		
		private function resizeGame(e:Event = null):void 
		{	
			try 
			{
				_lobby.x = int(stage.stageWidth / 2 - 480)
				_lobby.y = int(stage.stageHeight / 2 - 309.5)
			}
			catch (err:Error){}

		}
		
		private function removeLoading():void
		{
			try {this.parent.removeChild(Preloader._preloader); Preloader._preloader = null; }
			catch (err:Error){}
		}

	}

}