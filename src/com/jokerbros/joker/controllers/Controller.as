/**
 * Created by Vadim on 17.06.2015.
 */

package com.jokerbros.joker.controllers
{
import com.jokerbros.joker.Facade.Facade;
import com.jokerbros.joker.connector.Connector;
import com.jokerbros.joker.connector.Response;
import com.jokerbros.joker.events.GameEvent;
import com.jokerbros.joker.models.DataModel;
import com.jokerbros.joker.models.GameModel;
import flash.display.StageDisplayState;
import flash.events.DataEvent;
import flash.events.Event;

public class Controller
	{
		private var _connector:Connector;
		private var _response:Response;
		private var _gameModel:GameModel;
		private var _data:DataModel;
		
		private var _responseInited:Boolean;

		public function Controller(model:GameModel)
		{
			_gameModel = model;
			
			_connector = new Connector();
			_connector.addEventListener(Connector.INITED, sfsInit);
			_connector.init(Joker.LOADER_INFO);
			
			_response = new Response(_connector, _gameModel);
		}

		private function init():void
		{
			_data = new DataModel();
			_response.init(_data);
			_connector.addEventListener(Connector.LAG_MONITOR_STOP, lagMonitorStop);
			_connector.addEventListener(Connector.STATE_BAR, stateBar);
			_response.addEventListener(Response.JOIN_LOBBY, joinRoom);
			Joker.STAGE.addEventListener(GameEvent.FULL_SCREEN, onFullScreen);
			Facade.dispatcher.dispatch(GameEvent.LOGIN);
		}

		private function sfsInit(e:Event):void 
		{
			if(!_responseInited)
			{
				_responseInited = true;
				init();
			}
			else
			{
				Facade.dispatcher.dispatch(GameEvent.LOGIN);
			}
		}

		private function joinRoom(e:Event):void 
		{
			_gameModel.dataUser(_data);
			_gameModel.init();
		}

		private function stateBar(e:DataEvent):void 
		{
			_response.stateMonitor(e.data);
		}

		private function lagMonitorStop(e:Event):void 
		{
			_response.lagMonitor("stop");
		}

		private function onFullScreen(e:Event):void
		{
			try
			{
				if (Joker.STAGE.displayState == StageDisplayState.NORMAL)
				{
					Joker.STAGE.displayState = StageDisplayState.FULL_SCREEN;
				}
				else
				{
					Joker.STAGE.displayState = StageDisplayState.NORMAL;
				}
			}
			catch (err:Error)
			{

			}
		}
	}
}
