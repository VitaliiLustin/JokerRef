package com.jokerbros.joker.lobby.tournament 
{
	import com.jokerbros.joker.connector.Connector;
	import com.jokerbros.joker.events.TournamentEvent;
	import com.jokerbros.joker.lobby.items.TourRatingItem;
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	internal class Running extends Sprite
	{
		public static const STATUS_SUCCESS:int = 1
		public static const STATUS_LOW_BALANCE:int = 2
		public static const STATUS_ACCESS_DENIED:int = 3
		
		private var _mcParent:MovieClip
		private var _topPlayers:Vector.<TourRatingItem>;
		
		private var _coutDown:CountDown;
		private var _tourID:int
		
		private var _winPlayers:ISFSArray
		
		public function Running($parent:MovieClip) 
		{
			_mcParent = $parent;
			_mcParent.visible = false
			
			_coutDown = new CountDown(_mcParent.mcTimer, 'დარჩენილი \n დრო:')
			_coutDown.addEventListener(Event.COMPLETE, onCoutDownComplete)

			hideAllElements()
			
			_mcParent.mcInfo.btnHowDistributed.addEventListener(MouseEvent.CLICK, onHowDistributed)
			_mcParent.btnHowWork.addEventListener(MouseEvent.CLICK, onHowWork)
			_mcParent.btnBack.addEventListener(MouseEvent.CLICK, onBack)
			
			_mcParent.mcEnd.mcWin.btnHowDistributed.addEventListener(MouseEvent.CLICK, onHowDistributed)
			_mcParent.mcEnd.mcLoss.btnHowDistributed.addEventListener(MouseEvent.CLICK, onHowDistributed)
			
			initGraphics()
		}
		
		private function onBack(e:MouseEvent):void 
		{
			Tournament.enableProgress(true)
			Connector.send('tourHome');
		}
		
		private function hideAllElements():void
		{
			_coutDown.show(false)
			
			_mcParent.mcMyInfo.visible = false
			_mcParent.btnPlay.visible = false
			_mcParent.btnNextHand.visible = false
			_mcParent.mcEnd.visible = false
			_mcParent.mcNotReg.visible = false
			_mcParent.mcWhiteOpp.visible = false
			_mcParent.mcMsgLate.visible = false
			_mcParent.mcInfo.visible = false
			_mcParent.mcGameOver.visible = false
			_mcParent.mcAccessDenied.visible = false
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------FIRST INIT-----------------------------------------------------------------------------------------*/
		public function init(params:ISFSObject):void
		{
			hideAllElements()

			setInfo( params.getSFSObject('info') )
			
			_coutDown.show(true)

			if (params.getSFSObject('info').getInt('endLeftTime') <= 0)
			{
				_coutDown.destroy()
				_coutDown.isEnd(true)
			}
			else
			{
				_coutDown.run(params.getSFSObject('info').getInt('endLeftTime'), 60*60*2)
			}
			
			
			
			if (params.getBool('isRegistered'))
			{
				_mcParent.mcNotReg.visible = false
				
				if (params.containsKey('endTour'))
				{
					endTour(params.getSFSObject('endTour'))
					_winPlayers = params.getSFSObject('endTour').getSFSArray('winPlayers')
				}
				else
				{
					initPlay(params.getInt('playerStatus'))
					initInfoBox()
				}
				
				initMyInfoBox()
				updateMyInfo(params)
				
				_coutDown.isCenter(false)
				
			}
			else
			{
				_mcParent.mcNotReg.visible = true
				_coutDown.isCenter(true)
				initInfoBox()
			}
			
			_mcParent.visible = true;
			
			updateOnlinePlayers(params.getInt('activePlayers'));
			
			updateTopPlayers(params.getSFSObject('topPlayers'))
		}
		
		public function hide():void
		{
			_mcParent.visible = false;
		}
		
		
		private function endTour(params:ISFSObject):void
		{
			_mcParent.mcEnd.mcWin.visible = false
			_mcParent.mcEnd.mcLoss.visible = false
			_mcParent.mcEnd.mcWhite.visible = false
			
			if (params.getBool('finish'))
			{
				if (params.getBool('isWin'))
				{
					_mcParent.mcEnd.mcWin.txtNote.text = params.getUtfString('msg');
					_mcParent.mcEnd.mcWin.txtPlace.text = params.getInt('level')
					_mcParent.mcEnd.mcWin.txtAmount.text = params.getDouble('winAmount').toFixed(2) + ' ლარი'
					_mcParent.mcEnd.mcWin.visible = true
				}
				else
				{
					_mcParent.mcEnd.mcLoss.txtPlace.text = params.getInt('level')
					_mcParent.mcEnd.mcLoss.txtNote.text = params.getUtfString('msg')
					_mcParent.mcEnd.mcLoss.visible = true
				}
			}
			else
			{
				_mcParent.mcEnd.mcWhite.visible = true
				_mcParent.mcEnd.mcWhite.txtTbl.text = params.getInt('roomsCount').toString()
			}
			
			_mcParent.mcEnd.visible = true
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*-------------------------- INFO ---------------------------------------------------------------------------------------------*/
		private function setInfo(params:ISFSObject):void
		{
			//_coutDown.show(true)
			//_coutDown.run(params.getInt('endLeftTime'))
			
			_tourID = params.getInt('id')
			
			Rules.fish = params.getDouble('fish')
			Rules.duration = params.getInt('duration')
			Rules.bet = params.getDouble('bet')
			Rules.hand = params.getInt('hand')
			
			
			_mcParent.mcInfo.txtPrizeFond.text = params.getDouble('prizeFund').toString()
			_mcParent.mcInfo.txtActivePlayer.text = '';

		}
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------PLAY-----------------------------------------------------------------------------------------------*/
		private function initPlay(status:int):void
		{
			if (status == Running.STATUS_SUCCESS)
			{
				_mcParent.btnPlay.visible = true
				_mcParent.btnPlay.addEventListener(MouseEvent.CLICK, onPlay)
			}
			else if (status == Running.STATUS_LOW_BALANCE)
			{
				_mcParent.mcGameOver.visible = true
			}
			else if (status == Running.STATUS_ACCESS_DENIED)
			{
				_mcParent.mcAccessDenied.visible = true	
			}
			
			
		}
		
		private function onPlay(e:MouseEvent):void 
		{
			var data:ISFSObject = new SFSObject(); data.putInt('ID', _tourID)
			_mcParent.btnPlay.removeEventListener(MouseEvent.CLICK, onPlay)
			Tournament.enableProgress(true)
			Connector.send('tourFindOpp',data)
		}
		
		public function resPlay(params:ISFSObject):void
		{
			Tournament.enableProgress(false)
			
			if (params.containsKey('code'))
			{
				if (params.getInt('code') == 0)
				{
					hidePlay()
					initWhiteOpp()
				}
				else  if (params.getInt('code') == 1)
				{
					dispatchEvent(new TournamentEvent(TournamentEvent.ALERT, 'თქვენ არ გაქვთ საკმარისი ქულა ტურნირის \n გასაგრძელებლად.') )
					initPlay(Running.STATUS_SUCCESS)
				}
				else
				{
					dispatchEvent(new TournamentEvent(TournamentEvent.ALERT, 'მოხდა ტექნიკური შეცდომა.') )
					initPlay(Running.STATUS_SUCCESS)
				}
			}
			else
			{
				dispatchEvent(new TournamentEvent(TournamentEvent.ALERT, 'მოხდა ტექნიკური შეცდომა.' ) )
				initPlay(Running.STATUS_SUCCESS)
			}
			
		}
		
		private function hidePlay():void
		{
			_mcParent.btnPlay.removeEventListener(MouseEvent.CLICK, onPlay)
			_mcParent.btnPlay.visible = false
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------WHITE OPP------------------------------------------------------------------------------------------*/
		private function initWhiteOpp():void
		{
			_mcParent.mcWhiteOpp.visible = true
			_mcParent.mcWhiteOpp.btnCancelWhite.addEventListener(MouseEvent.CLICK, onCancelWhiteOpp)
		}
		
		private function onCancelWhiteOpp(e:MouseEvent):void 
		{
			var data:ISFSObject = new SFSObject(); data.putInt('ID', _tourID)
			_mcParent.mcWhiteOpp.btnCancelWhite.removeEventListener(MouseEvent.CLICK, onCancelWhiteOpp)
			Tournament.enableProgress(true)
			Connector.send('tourCancelFindOpp',data)
		}
		
		public function respCancelWhiteOpp(params:ISFSObject):void
		{
			Tournament.enableProgress(false)
			
			if (params.containsKey('code'))
			{
				if (params.getInt('code') == 0)
				{
					hideWhiteOpp()
					initPlay(Running.STATUS_SUCCESS)
				}
				else 
				{
					dispatchEvent(new TournamentEvent(TournamentEvent.ALERT, 'მოხდა ტექნიკური შეცდომა.') )
					initWhiteOpp()
				}
			}
			else
			{
				dispatchEvent(new TournamentEvent(TournamentEvent.ALERT, 'მოხდა ტექნიკური შეცდომა.') )
				initWhiteOpp()
			}

		}
		
		private function hideWhiteOpp():void
		{
			_mcParent.mcWhiteOpp.btnCancelWhite.removeEventListener(MouseEvent.CLICK, onCancelWhiteOpp)
			_mcParent.mcWhiteOpp.visible = false
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------INFO BOX-------------------------------------------------------------------------------------------*/
		private function initInfoBox():void
		{
			_mcParent.mcInfo.visible = true
		}
		
		private function hideInfoBox():void
		{
			_mcParent.mcInfo.visible = false
		}
		
		private function initMyInfoBox():void
		{
			_mcParent.mcMyInfo.visible = true
		}
		
		private function hideMyInfoBox():void
		{
			_mcParent.mcMyInfo.visible = false
		}
		
		private function updateMyInfo(params:ISFSObject):void
		{
			_mcParent.mcMyInfo.txtPoint.text = params.getDouble('balance').toString()
			_mcParent.mcMyInfo.txtRating.text = params.getInt('level').toString()
		}
		
		public function updateOnlinePlayers(count:int):void
		{
			_mcParent.mcInfo.txtActivePlayer.text = count.toString()
		}
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------END GAME-------------------------------------------------------------------------------------------*/
		private function initEndGame(params:ISFSObject):void
		{
			_mcParent.mcEnd.mcWin.visible = false
			_mcParent.mcEnd.mcLoss.visible = false
			_mcParent.mcEnd.mcWhite.visible = false
			
			if (true) //IS_ENDED
			{
				if (true) //WINNER
				{
					_mcParent.mcEnd.mcWin.txtPlace.text = 'txtPlace'
					_mcParent.mcEnd.mcWin.txtNote.text = 'txtNote'
					_mcParent.mcEnd.mcWin.txtAmount.text = 'txtAmount'
					_mcParent.mcEnd.mcWin.visible = true
				}
				else
				{
					_mcParent.mcEnd.mcLoss.txtPlace.text = 'txtPlace'
					_mcParent.mcEnd.mcLoss.txtNote.text = 'txtNote'
					_mcParent.mcEnd.mcLoss.visible = true
				}
			}
			else
			{
				_mcParent.mcEnd.mcWhite.txtTbl.text = 'txtTbl'
				_mcParent.mcEnd.mcWhite.visible = true
			}
			
			_mcParent.mcEnd.visible = true
		}
		
		private function hideEndGame():void
		{
			_mcParent.mcEnd.visible = false
		}
		
		private function updateLeftTable():void
		{
			_mcParent.mcEnd.mcWhite.txtTbl.text = 'txtTbl'
		}
	
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------TOP PLAYERS----------------------------------------------------------------------------------------*/
		public function updateTopPlayers(params:ISFSObject):void
		{
			clearTopPlayers()
			
			_topPlayers = new Vector.<TourRatingItem>()
			
			var rmY:int = 0;
			
			for (var i:int = 0; i < params.getSFSArray('users').size(); i++) 
			{
				_topPlayers[i] = new TourRatingItem();
				_topPlayers[i].fill(i+1, params.getSFSArray('users').getSFSObject(i).getUtfString('username'), params.getSFSArray('users').getSFSObject(i).getDouble('balance'))
				_topPlayers[i].y = rmY
				rmY =	rmY + _topPlayers[i].height;
				_mcParent.mcRatingTable.container.addChild(_topPlayers[i]);
			}
		}
		
		private function clearTopPlayers():void
		{
			while (_mcParent.mcRatingTable.container.numChildren > 0) _mcParent.mcRatingTable.container.removeChildAt(0);
			_topPlayers = null
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------WINDOWS HANDLERS-----------------------------------------------------------------------------------*/
		private function onHowDistributed(e:MouseEvent):void 
		{
			if(e.target.parent.name == 'mcInfo')
			{
				dispatchEvent(new TournamentEvent(TournamentEvent.HOW_DISTRIBUTED, false))
			}
			else
			{
				dispatchEvent(new TournamentEvent(TournamentEvent.HOW_DISTRIBUTED, _winPlayers))
			}
		}
		
		private function onHowWork(e:MouseEvent):void 
		{
			dispatchEvent(new TournamentEvent(TournamentEvent.HOW_WORK, {x:70,y:50}))
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------COUT DOWN HANDLERS---------------------------------------------------------------------------------*/
		private function onCoutDownComplete(e:Event):void 
		{
			var data:ISFSObject = new SFSObject(); data.putInt('ID', _tourID)
			Tournament.enableProgress(true)
			Connector.send('tourView', data)
		}
		
		public function clear():void
		{
			_mcParent.mcInfo.btnHowDistributed.removeEventListener(MouseEvent.CLICK, onHowDistributed)
			_mcParent.btnHowWork.removeEventListener(MouseEvent.CLICK, onHowWork)
			_mcParent.btnBack.removeEventListener(MouseEvent.CLICK, onBack)
			_mcParent.mcEnd.mcWin.btnHowDistributed.removeEventListener(MouseEvent.CLICK, onHowDistributed)
			_mcParent.mcEnd.mcLoss.btnHowDistributed.removeEventListener(MouseEvent.CLICK, onHowDistributed)
			_mcParent.mcWhiteOpp.btnCancelWhite.removeEventListener(MouseEvent.CLICK, onCancelWhiteOpp)
			_mcParent.btnPlay.removeEventListener(MouseEvent.CLICK, onPlay)
			
			if (_coutDown)
			{
				_coutDown.removeEventListener(Event.COMPLETE, onCoutDownComplete)	
				_coutDown.destroy()
			}
			
			_winPlayers = null
			
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------GRAPHICS-------------------------------------------------------------------------------------------*/
		private function initGraphics():void
		{
			var bpgArial:String = new BGPArial().fontName;
			var hanndel:String = new HandelRegular().fontName;

			_mcParent.mcMyInfo.txtPoint.embedFonts = true;
			_mcParent.mcMyInfo.txtPoint.selectable = false;
			_mcParent.mcMyInfo.txtPoint.antiAliasType = AntiAliasType.ADVANCED;
			_mcParent.mcMyInfo.txtPoint.setTextFormat( new TextFormat(hanndel) );
			
			_mcParent.mcMyInfo.txtRating.embedFonts = true;
			_mcParent.mcMyInfo.txtRating.selectable = false;
			_mcParent.mcMyInfo.txtRating.antiAliasType = AntiAliasType.ADVANCED;
			_mcParent.mcMyInfo.txtRating.setTextFormat( new TextFormat(hanndel) );
	
			_mcParent.mcInfo.txtPrizeFond.embedFonts = true;
			_mcParent.mcInfo.txtPrizeFond.selectable = false;
			_mcParent.mcInfo.txtPrizeFond.antiAliasType = AntiAliasType.ADVANCED;
			_mcParent.mcInfo.txtPrizeFond.setTextFormat( new TextFormat(hanndel) );
			
			_mcParent.mcInfo.txtActivePlayer.embedFonts = true;
			_mcParent.mcInfo.txtActivePlayer.selectable = false;
			_mcParent.mcInfo.txtActivePlayer.antiAliasType = AntiAliasType.ADVANCED;
			_mcParent.mcInfo.txtActivePlayer.setTextFormat( new TextFormat(hanndel) );

			_mcParent.mcEnd.mcWin.txtPlace.embedFonts = true;
			_mcParent.mcEnd.mcWin.txtPlace.selectable = false;
			_mcParent.mcEnd.mcWin.txtPlace.antiAliasType = AntiAliasType.ADVANCED;
			_mcParent.mcEnd.mcWin.txtPlace.setTextFormat( new TextFormat(hanndel) );

			_mcParent.mcEnd.mcWin.txtNote.embedFonts = true;
			_mcParent.mcEnd.mcWin.txtNote.selectable = false;
			_mcParent.mcEnd.mcWin.txtNote.antiAliasType = AntiAliasType.ADVANCED;
			_mcParent.mcEnd.mcWin.txtNote.setTextFormat( new TextFormat(bpgArial) ); 

			_mcParent.mcEnd.mcWin.txtAmount.embedFonts = true;
			_mcParent.mcEnd.mcWin.txtAmount.selectable = false;
			_mcParent.mcEnd.mcWin.txtAmount.antiAliasType = AntiAliasType.ADVANCED;
			_mcParent.mcEnd.mcWin.txtAmount.setTextFormat( new TextFormat(bpgArial) ); 
			
			_mcParent.mcEnd.mcLoss.txtPlace.embedFonts = true;
			_mcParent.mcEnd.mcLoss.txtPlace.selectable = false;
			_mcParent.mcEnd.mcLoss.txtPlace.antiAliasType = AntiAliasType.ADVANCED;
			_mcParent.mcEnd.mcLoss.txtPlace.setTextFormat( new TextFormat(hanndel) );

			_mcParent.mcEnd.mcLoss.txtNote.embedFonts = true;
			_mcParent.mcEnd.mcLoss.txtNote.selectable = false;
			_mcParent.mcEnd.mcLoss.txtNote.antiAliasType = AntiAliasType.ADVANCED;
			_mcParent.mcEnd.mcLoss.txtNote.setTextFormat( new TextFormat(bpgArial) );
			
			_mcParent.mcEnd.mcWhite.txtTbl.embedFonts = true;
			_mcParent.mcEnd.mcWhite.txtTbl.selectable = false;
			_mcParent.mcEnd.mcWhite.txtTbl.antiAliasType = AntiAliasType.ADVANCED;
			_mcParent.mcEnd.mcWhite.txtTbl.setTextFormat( new TextFormat(bpgArial) );
			
		}
		
		
	}

}