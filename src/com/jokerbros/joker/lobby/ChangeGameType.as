package com.jokerbros.joker.lobby 
{
	import com.jokerbros.joker.events.LobbyEvent;
	import com.jokerbros.joker.Facade.Facade;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class ChangeGameType 
	{
		
		private var _mc:MovieClip;
		
		private var _tabFun:MovieClip
		private var _tabCash:MovieClip
		private var _tabTour:MovieClip
		
		public function ChangeGameType(mc:MovieClip) 
		{
			_mc = mc;
		
			_mc.visible = true;

			_tabFun = _mc.tab_fun
			_tabCash = _mc.tab_cash
			_tabTour = _mc.tab_tour

			_tabFun.visible = false
			_tabCash.visible = false
			_tabTour.visible = false

		}
		
		public function setActiveTab(isActiveTab:int):void
		{
			if (isActiveTab == 1)
			{
				funTabActive(false);
				tourTabActive(false);
				cashTabActive(true);
			}
			else if(isActiveTab == 2)
			{
				funTabActive(true);	
				cashTabActive(false);
				tourTabActive(false);
			}
			else if(isActiveTab == 3)
			{
				funTabActive(false);	
				cashTabActive(false);
				tourTabActive(true);
			}
			_tabTour.visible = true
			_tabFun.visible = true
			_tabCash.visible = true
		}
		
		
		
		private function onClick(e:MouseEvent):void 
		{
			if (e.currentTarget.name == 'tab_fun')
			{
				funTabActive(true);
				cashTabActive(false);
				tourTabActive(false);
				
				Facade.dispatcher.dispatch(LobbyEvent.CHANGE_GAME_TYPE, 2);
				//dispatchEvent(new ChangeGameTypeEvent(ChangeGameTypeEvent.CHANGE, 2))
			}
			else if(e.currentTarget.name == 'tab_cash')
			{
				cashTabActive(true);
				funTabActive(false);
				tourTabActive(false);
				
				Facade.dispatcher.dispatch(LobbyEvent.CHANGE_GAME_TYPE, 1);
				//dispatchEvent(new ChangeGameTypeEvent(ChangeGameTypeEvent.CHANGE, 1))
			}
			else if(e.currentTarget.name == 'tab_tour')
			{
				cashTabActive(false);
				funTabActive(false);
				tourTabActive(true);
				
				//dispatchEvent(new ChangeGameTypeEvent(ChangeGameTypeEvent.CHANGE, 3))
				Facade.dispatcher.dispatch(LobbyEvent.CHANGE_GAME_TYPE, 3);
			}
		}
		
		private function onOver(e:MouseEvent):void 
		{
			e.currentTarget.alpha = 1;
			e.currentTarget.gotoAndStop(1)
		}
		
		private function onOut(e:MouseEvent):void 
		{
			e.currentTarget.alpha = 1;
			e.currentTarget.gotoAndStop(2)
		}
		
		
		private function funTabActive(params:Boolean):void
		{
			if (!params)
			{
				_tabFun.gotoAndStop(2)
				_tabFun.icon.gotoAndStop(1)
				_tabFun.alpha = 1
				_tabFun.buttonMode = true;
				_tabFun.addEventListener(MouseEvent.CLICK, onClick)
				_tabFun.addEventListener(MouseEvent.MOUSE_OUT, onOut)
				_tabFun.addEventListener(MouseEvent.MOUSE_OVER, onOver)
			}
			else
			{
			
				_tabFun.removeEventListener(MouseEvent.CLICK, onClick)
				_tabFun.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
				_tabFun.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
				_tabFun.gotoAndStop(1)
				_tabFun.icon.gotoAndStop(2)
				_tabFun.alpha = 1
				_tabFun.buttonMode = false;
				
			}
		}
		
		private function cashTabActive(params:Boolean):void
		{
			if (!params)
			{
				_tabCash.gotoAndStop(2)
				_tabCash.icon.gotoAndStop(1)
				_tabCash.alpha = 1
				_tabCash.buttonMode = true;
				_tabCash.addEventListener(MouseEvent.CLICK, onClick)
				_tabCash.addEventListener(MouseEvent.MOUSE_OUT, onOut)
				_tabCash.addEventListener(MouseEvent.MOUSE_OVER, onOver)
			}
			else
			{
				_tabCash.removeEventListener(MouseEvent.CLICK, onClick)
				_tabCash.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
				_tabCash.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
				_tabCash.gotoAndStop(1)
				_tabCash.icon.gotoAndStop(2)
				_tabCash.alpha = 1
				_tabCash.buttonMode = false;
			}
		}
		
		
		private function tourTabActive(params:Boolean):void
		{
			if (!params)
			{
				_tabTour.gotoAndStop(2)
				_tabTour.icon.gotoAndStop(1)
				_tabTour.alpha = 1
				_tabTour.buttonMode = true;
				_tabTour.addEventListener(MouseEvent.CLICK, onClick)
				_tabTour.addEventListener(MouseEvent.MOUSE_OUT, onOut)
				_tabTour.addEventListener(MouseEvent.MOUSE_OVER, onOver)
			}
			else
			{
				_tabTour.removeEventListener(MouseEvent.CLICK, onClick)
				_tabTour.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
				_tabTour.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
				_tabTour.gotoAndStop(1)
				_tabTour.icon.gotoAndStop(2)
				_tabTour.alpha = 1
				_tabTour.buttonMode = false;
				
				//swapIndex('cash');
			}
		}
		
		public function destroy():void
		{
			_tabFun.removeEventListener(MouseEvent.CLICK, onClick)
			_tabFun.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_tabFun.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
			_tabCash.removeEventListener(MouseEvent.CLICK, onClick)
			_tabCash.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_tabCash.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
			_tabTour.removeEventListener(MouseEvent.CLICK, onClick)
			_tabTour.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_tabTour.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
		}
		
		
	}

}