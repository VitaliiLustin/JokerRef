/**
 * Created by Vadim on 17.06.2015.
 */
package com.jokerbros.joker.view
{
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.connector.Connector;
	import com.jokerbros.joker.events.GameEvent;
	import com.jokerbros.joker.game.Game;
	import com.jokerbros.joker.lobby.Lobby;
	import com.jokerbros.joker.models.GameModel;
	import com.jokerbros.joker.user.User;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class GreatView extends Sprite
	{
		private var _model:GameModel;
		private var _lobby:Lobby;
		private var _game:Game;
		
		public function GreatView(model:GameModel)
		{
			User.soundOn();
			_model = model;
			
			if (_model.inited)
			{
				init();
			}
			else
			{
				_model.addEventListener(GameModel.INITED, init);
			}
		}

		private function init(event:Event = null):void 
		{
			Preloader.hide();

			Facade.dispatcher.addEventListener(GameEvent.GAME_INIT, showGame);

			_lobby = new Lobby(_model.userData.getData(Connector.PARAM_DATA_LOBBY) as ISFSObject);
			_lobby.init();
			addChild(_lobby);
			//
			_game = new Game(_model.userData.getData(Connector.PARAM_DATA_LOBBY) as ISFSObject);
			_game.visible = false;
			_game.addEventStage();
			
			addChild(_game);
			_game.addEventListener(GameEvent.GAME_TO_LOBBY, onGameToLobby);
		}

		private function showGame(e:GameEvent):void
		{
			_lobby.visible = false;
			_game.visible = true;
		}

		private function onGameToLobby(event:GameEvent) : void
		{
			//_lobby.restoreLobby();
			Connector.send(Connector.SEND_INIT_LOBBY);
			
			_lobby.visible = true;
			_game.visible = false;
		}
	}
}
