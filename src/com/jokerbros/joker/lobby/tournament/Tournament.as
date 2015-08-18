package com.jokerbros.joker.lobby.tournament 
{
	import com.jokerbros.joker.events.AlertEvent;
	import com.jokerbros.joker.events.TournamentEvent;
	import com.jokerbros.joker.lobby.windows.Alert;
	import com.jokerbros.joker.lobby.windows.WindPrizeFound;
	import com.jokerbros.joker.lobby.windows.WindTourRules;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class Tournament 
	{
		private var _tournament			:	MovieClip;
		private var _windRules			:	WindTourRules;
		private var _windPrizeFound		:	WindPrizeFound;
		private var _windAlert			:	Alert;
		private var _access				: 	Access;
		
		//states
		private var _running			:	Running;
		private var _registration		:	Registration;
		private var _list				:	List;
		
		private var _profitDistribution : Array;
		
		private static var mcProgress	:	MovieClip;
		
		public function Tournament(tournament:MovieClip, progress:MovieClip)
		{
			_tournament = tournament;
			Tournament.mcProgress = progress;
			
			_list = new List(_tournament.mcList);
			
			_running = new Running(_tournament.mcRunning);
			_running.addEventListener(TournamentEvent.HOW_DISTRIBUTED, showWindPrizeFound);
			_running.addEventListener(TournamentEvent.HOW_WORK, showWindRules);
			_running.addEventListener(TournamentEvent.ALERT, showAlert);
			
			_registration = new Registration(_tournament.mcStart);
			_registration.addEventListener(TournamentEvent.HOW_DISTRIBUTED, showWindPrizeFound);
			_registration.addEventListener(TournamentEvent.HOW_WORK, showWindRules);
			_registration.addEventListener(TournamentEvent.ALERT, showAlert);
			
			_access = new Access(_tournament.mcAccess);
			
		}
		
		public static function enableProgress(param:Boolean = true):void
		{
			Tournament.mcProgress.visible = param;
		}

		public function initState(params:ISFSObject):void
		{
			enableProgress(false);
			resetAllSatet();

			if (params.containsKey('list'))
			{
				_list.show(params.getSFSObject('list'));
			}
			else if (params.containsKey('registration'))
			{
				_profitDistribution = params.getSFSObject('registration').getDoubleArray('profitDistribution');
				_registration.show(params.getSFSObject('registration'));
			}
			else if (params.containsKey('running'))
			{
				_profitDistribution = params.getSFSObject('running').getDoubleArray('profitDistribution');
				_running.init(params.getSFSObject('running'));
			}
			else if (params.containsKey('access'))
			{
				_access.show(params.getSFSObject('access'));
			}
			
			_tournament.visible = true;
		}
		
		public function hide():void
		{
			resetAllSatet();
			_tournament.visible = false;
		}
		
		private function resetAllSatet():void
		{
			_access.hide();
			_list.hide();
			_registration.hide();
			_running.hide();
			
			hideAlert();
			hideWindPrizeFound();
			hideWindRules();
		}
		
		
		/*----------------------------WINDOWS------------------------------------------------------------------------------------------*/
		private function showWindRules(e:TournamentEvent = null):void
		{
			hideWindRules();
			
			_windRules = new WindTourRules();
			_windRules.addEventListener(Event.CLOSE, hideWindRules);
			
			if(e && e.data)
			{
				_windRules.x = e.data.x;
				_windRules.y = e.data.y;
			}
			_tournament.addChild(_windRules);
		}
		
		private function hideWindRules(e:Event = null):void
		{
			if (_windRules)
			{
				if (_tournament.contains(_windRules))
				{
					_tournament.removeChild(_windRules);
				}
				_windRules.removeEventListener(Event.CLOSE, hideWindRules);
				_windRules = null;
			}
		}

		private function showWindPrizeFound(e:TournamentEvent = null):void
		{
			hideWindPrizeFound();
			
			_windPrizeFound = new WindPrizeFound(_profitDistribution, e.data);
			_windPrizeFound.addEventListener(Event.CLOSE, hideWindPrizeFound);
			_tournament.addChild(_windPrizeFound);
		}
		
		private function hideWindPrizeFound(e:Event = null):void
		{
			if (_windPrizeFound)
			{
				if (_tournament.contains(_windPrizeFound))
				{
					_tournament.removeChild(_windPrizeFound);
				}
				_windPrizeFound.removeEventListener(Event.CLOSE, hideWindPrizeFound);
				_windPrizeFound = null;
			}
		}
		
		private function showAlert(e:TournamentEvent):void
		{
			var msg:String = e.data.toString();
			
			_windAlert = new Alert();
			_windAlert.y = 100;
			_windAlert.setMessage( msg );
			_windAlert.addEventListener(AlertEvent.CLOSE, hideAlert);
			_tournament.addChild(_windAlert);
		}
		
		private function hideAlert(e:AlertEvent=null):void
		{
			if (_windAlert)
			{
				if (_tournament.contains(_windAlert))
				{
					_tournament.removeChild(_windAlert);
				}
				_windAlert.removeEventListener(AlertEvent.CLOSE, hideAlert);
				_windAlert = null;
			}
		}
		
		public function clear():void
		{
			resetAllSatet();
			
			if (_running)
			{
				_running.addEventListener(TournamentEvent.HOW_DISTRIBUTED, showWindPrizeFound);
				_running.addEventListener(TournamentEvent.HOW_WORK, showWindRules);
				_running.addEventListener(TournamentEvent.ALERT, showAlert);
				_running.clear()
			}
			
			if (_registration)
			{
				_registration.addEventListener(TournamentEvent.HOW_DISTRIBUTED, showWindPrizeFound);
				_registration.addEventListener(TournamentEvent.HOW_WORK, showWindRules);
				_registration.addEventListener(TournamentEvent.ALERT, showAlert);
				_registration.clear();
			}
			
			if (_list)
			{
				_list.clear();
				_list = null;
			}
			
			if (_access)
			{
				_access.clear();
				_access = null;
			}
		}
		
		public function get registration():Registration {
			return _registration;
		}

		public function get running():Running {
			return _running;
		}

		public function get list():List {
			return _list;
		}
	}

}