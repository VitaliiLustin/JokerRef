package com.jokerbros.joker.lobby.tournament 
{
	import com.jokerbros.joker.connector.Connector;
	import com.jokerbros.joker.events.TournamentEvent;
	import com.jokerbros.joker.utils.TyniHelper;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author JokerBros
	 */
	internal class Registration extends Sprite
	{
		private var _mcParent:MovieClip
		private var _coutDown:CountDown;
		
		private var _tourID:int
		
		private var _isRegistered:Boolean
		
		public function Registration($parent:MovieClip) 
		{
			_mcParent = $parent;
			
			_coutDown = new CountDown(_mcParent.mcTimer, 'დაწყებამდე \n დარჩა:')
			_coutDown.addEventListener(Event.COMPLETE, onCoutDownComplete)
			_coutDown.show(false)
			
			_mcParent.mcStartRegInfo.visible = false
			_mcParent.mcRegInfo.visible = false
			_mcParent.mcTourFull.visible = false
			_mcParent.mcRegistered.visible = false
			_mcParent.btnReg.visible = false
			
			_mcParent.btnHowWork.addEventListener(MouseEvent.CLICK, onHowWork)
			_mcParent.btnHowDistributed.addEventListener(MouseEvent.CLICK, onHowDistributed)
			_mcParent.btnBack.addEventListener(MouseEvent.CLICK, onBack)
			

			_mcParent.mcTourDate.txtLine1.embedFonts = true;
			_mcParent.mcTourDate.txtLine1.selectable = false;
			_mcParent.mcTourDate.txtLine1.antiAliasType = AntiAliasType.ADVANCED;
			_mcParent.mcTourDate.txtLine1.setTextFormat( new TextFormat(new Hanndel().fontName) );
			
			_mcParent.mcTourDate.txtLine2.embedFonts = true;
			_mcParent.mcTourDate.txtLine2.selectable = false;
			_mcParent.mcTourDate.txtLine2.antiAliasType = AntiAliasType.ADVANCED;
			_mcParent.mcTourDate.txtLine2.setTextFormat( new TextFormat(new Hanndel().fontName) );
			
			
			_mcParent.mcBuyIn.txtBuyIn.embedFonts = true
			_mcParent.txtPrizeFund.embedFonts = true
			_mcParent.mcRegInfo.txtRegisterUserCount.embedFonts = true
			_mcParent.mcRegInfo.txtRegisterUserLimit.embedFonts = true
			
			_isRegistered = false
			
			_mcParent.visible = false
		}
		
		private function onBack(e:MouseEvent):void 
		{
			Tournament.enableProgress(true)
			Connector.send('tourHome');
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------FIRST INIT-----------------------------------------------------------------------------------------*/
		public function show(params:ISFSObject):void
		{
			setInfo( params.getSFSObject('info') )
			
			initRegistrationState(params)

			_mcParent.visible = true
		}
		
		public function hide():void
		{
			_mcParent.visible = false
		}
		
		
		private function initRegistrationState(params:ISFSObject):void
		{
			resetRegistrationState()
			
			hideBrosTalk()
			
			if (params.getBool('enableRegistration')) // enable reg
			{
				_mcParent.mcRegInfo.visible = true
				
				if( params.containsKey('isRegistered') && params.getBool('isRegistered') )
				{
					initUnReg()
				}
				else if (_isRegistered)
				{
					initUnReg()
				}
				else
				{
					if (params.getBool('isFull'))
					{
						_mcParent.mcTourFull.visible = true
					}
					else
					{
						initReg()
					}
				}
			}
			else // disable reg
			{
				showBrosTalk('რეგისტრაცია დაიწყება ტურნირამდე ' + int((params.getInt('registrationLeftTime')/(60))) + ' წუთით ადრე.')
			}
		}
		
		private function resetRegistrationState():void
		{
			_mcParent.mcStartRegInfo.visible = false
			_mcParent.mcRegInfo.visible = false
			_mcParent.mcTourFull.visible = false
			_mcParent.mcRegistered.visible = false
			_mcParent.btnReg.visible = false
		}
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------REGISTER-------------------------------------------------------------------------------------------*/
		private function initReg():void
		{
			_isRegistered = false
			
			if (!_mcParent.btnReg.hasEventListener(MouseEvent.CLICK)) _mcParent.btnReg.addEventListener(MouseEvent.CLICK, onRegister)
			_mcParent.btnReg.visible = true;
			_mcParent.mcBuyIn.visible = true;
		}
		
		private function onRegister(e:MouseEvent):void 
		{
			_mcParent.btnReg.removeEventListener(MouseEvent.CLICK, onRegister)
			var data:ISFSObject = new SFSObject(); data.putInt('ID', _tourID)
			Tournament.enableProgress(true)
			Connector.send('tourRegistration',data);
		}
		
		public function respRegistration(params:ISFSObject):void
		{
			Tournament.enableProgress(false);
			
			if (params.getInt('code') == 1)
			{
				_mcParent.btnReg.visible = false;
				initUnReg()
			}
			else if(params.getInt('code') == 2) // full
			{
				dispatchEvent(new TournamentEvent(TournamentEvent.ALERT, 'ტურნირში მონაწილეთა ადგილები \n შევსებულია.') )
				_mcParent.btnReg.visible = false;
				_mcParent.mcTourFull.visible = true
			}
			else 
			{
				dispatchEvent(new TournamentEvent(TournamentEvent.ALERT, 'მოხდა ტექნიკური შეცდომა.')) 
				initReg()
			}
		}
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------UN REGISTER----------------------------------------------------------------------------------------*/
		private function initUnReg():void
		{
			_isRegistered = true
			if(!_mcParent.mcRegistered.btnUnReg.hasEventListener(MouseEvent.CLICK)) _mcParent.mcRegistered.btnUnReg.addEventListener(MouseEvent.CLICK, onUnRegister)
			_mcParent.mcRegistered.visible = true;
			_mcParent.mcBuyIn.visible = false;
		}
		
		private function onUnRegister(e:MouseEvent):void 
		{
			_mcParent.mcRegistered.btnUnReg.removeEventListener(MouseEvent.CLICK, onUnRegister)
			_mcParent.mcRegistered.visible = false;
			
			var data:ISFSObject = new SFSObject(); data.putInt('ID', _tourID)
			Tournament.enableProgress(true)
			Connector.send('tourUnRegistration',data);
		}
		
		public function respUnRegistration(params:ISFSObject):void
		{
			Tournament.enableProgress(false);
			
			if (params.getInt('code') == 1)
			{
				_mcParent.mcRegistered.visible = true;
				_mcParent.mcRegistered.visible = false;
				initReg()
			}
			else 
			{
				dispatchEvent(new TournamentEvent(TournamentEvent.ALERT, 'მოხდა ტექნიკური შეცდომა') )
				initUnReg()
			}
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*-------------------------- INFO ---------------------------------------------------------------------------------------------*/
		private function setInfo(params:ISFSObject):void
		{
			_coutDown.show(true)
			_coutDown.run(params.getInt('startLeftTime'), 60*60*24)
			
			_tourID = params.getInt('id')
			
			Rules.fish = params.getDouble('fish')
			Rules.duration = params.getInt('duration')
			Rules.bet = params.getDouble('bet')
			Rules.hand = params.getInt('hand')
			

			//_mcParent.mcTourDate.txtLine1.text = TyniHelper.sec2DateTourReg(params.getLong("startTime"), params.getLong("currentDate"));
			//_mcParent.mcTourDate.txtLine2.text = TyniHelper.sec2HHMM(params.getLong("startTime"));
			
			_mcParent.mcTourDate.txtLine1.text = params.getUtfString('dateLine');
			_mcParent.mcTourDate.txtLine2.text = params.getUtfString('timeLine');
			
			_mcParent.mcBuyIn.txtBuyIn.text = (params.getDouble('buyIn') == 0) ? 'ufaso' : params.getDouble('buyIn') + 'GEL';
			_mcParent.txtPrizeFund.text =  params.getDouble('prizeFund').toString();
			_mcParent.mcRegInfo.txtRegisterUserCount.text = params.getInt('regUsersCount').toString();
			_mcParent.mcRegInfo.txtRegisterUserLimit.text = params.getInt('limit').toString();
		}
		
		public function updateRegUsers(params:ISFSObject):void
		{
			initRegistrationState(params.getSFSObject('registration'))
			_mcParent.mcRegInfo.txtRegisterUserCount.text = params.getInt('usersCount').toString();
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------BROS TALK------------------------------------------------------------------------------------------*/
		private function showBrosTalk(msg:String):void
		{
			_mcParent.mcStartRegInfo.txtVal.text = msg;
			_mcParent.mcStartRegInfo.visible = true
		}
		
		private function hideBrosTalk():void
		{
			_mcParent.mcStartRegInfo.visible = false
			_mcParent.mcStartRegInfo.txtVal.text = '';
		}

		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------WINDOWS HANDLERS-----------------------------------------------------------------------------------*/
		private function onHowDistributed(e:MouseEvent):void 
		{
			dispatchEvent(new TournamentEvent(TournamentEvent.HOW_DISTRIBUTED))
		}
		
		private function onHowWork(e:MouseEvent):void 
		{
			dispatchEvent(new TournamentEvent(TournamentEvent.HOW_WORK))
		}
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------COUT DOWN HANDLERS---------------------------------------------------------------------------------*/
		private function onCoutDownComplete(e:Event):void 
		{
			var data:ISFSObject = new SFSObject(); data.putInt('ID', _tourID)
			Tournament.enableProgress(true)
			Connector.send('tourView', data)
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------CLEAR----------------------------------------------------------------------------------------------*/		
		public function clear():void
		{
			_mcParent.btnHowWork.removeEventListener(MouseEvent.CLICK, onHowWork);
			_mcParent.btnHowDistributed.removeEventListener(MouseEvent.CLICK, onHowDistributed);
			_mcParent.btnBack.removeEventListener(MouseEvent.CLICK, onBack);
			_mcParent.btnReg.removeEventListener(MouseEvent.CLICK, onRegister);
			_mcParent.mcRegistered.btnUnReg.removeEventListener(MouseEvent.CLICK, onUnRegister);
			
			if (_coutDown)
			{
				_coutDown.removeEventListener(Event.COMPLETE, onCoutDownComplete);
				_coutDown.destroy();
			}
		}
		
	}

}