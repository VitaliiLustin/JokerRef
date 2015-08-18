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
	public class ChangeRoomType/* extends MovieClip*/
	{
		
		private var _mc:MovieClip;
		
		private var _tabFun:MovieClip
		private var _tabCash:MovieClip
		
		public function ChangeRoomType(mc:MovieClip) 
		{
			_mc = mc;
			//_mc.x = 300; 
			//_mc.y = 59;
		
			_mc.visible = true;

			_tabFun = _mc.tab_fun
			_tabCash = _mc.tab_cash

			_tabFun.visible = false
			_tabCash.visible = false
		}
		
		public function destroy():void
		{
			_tabFun.removeEventListener(MouseEvent.CLICK, onClick)
			_tabFun.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_tabFun.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
			_tabCash.removeEventListener(MouseEvent.CLICK, onClick)
			_tabCash.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_tabCash.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
		}
		
		
		public function setActiveTab(isActiveTab:int):void
		{
			if (isActiveTab == 1)
			{
				funTabActive(false);	
				cashTabActive(true);
			}
			else
			{
				funTabActive(true);	
				cashTabActive(false);
			}
			
			_tabFun.visible = true;
			_tabCash.visible = true;
			
			Facade.dispatcher.dispatch(LobbyEvent.CHANGE_ROOM_TYPE, isActiveTab);
		}
		
		private function swapIndex(activeMC:String=''):void
		{
			if (activeMC == 'fun' && _mc.getChildIndex(_tabFun) < _mc.getChildIndex(_tabCash))
			{
				_mc.swapChildren (_tabFun, _tabCash )
			}
			else if(activeMC == 'cash' && _mc.getChildIndex(_tabFun) > _mc.getChildIndex(_tabCash))
			{
				_mc.swapChildren (_tabCash, _tabFun )
			}
		}
		
		
		private function onClick(e:MouseEvent):void 
		{
			if (e.currentTarget.name == 'tab_fun')
			{
				funTabActive(true);
				cashTabActive(false);
				Facade.dispatcher.dispatch(LobbyEvent.CHANGE_ROOM_TYPE, 2);
			}
			else
			{
				cashTabActive(true);
				funTabActive(false);
				Facade.dispatcher.dispatch(LobbyEvent.CHANGE_ROOM_TYPE, 1);
			}
		}
		
		private function onOver(e:MouseEvent):void 
		{
			e.currentTarget.alpha = 1;
		}
		
		private function onOut(e:MouseEvent):void 
		{
			e.currentTarget.alpha = 0.8;
		}
		
		
		private function funTabActive(params:Boolean):void
		{
			if (!params)
			{
				_tabFun.gotoAndStop(2)
				_tabFun.alpha = 0.8
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
				_tabFun.alpha = 1
				_tabFun.buttonMode = false;
				
				swapIndex('fun');
			}
		}
		
		private function cashTabActive(params:Boolean):void
		{
			if (!params)
			{
				_tabCash.gotoAndStop(2)
				_tabCash.alpha = 0.8
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
				_tabCash.alpha = 1
				_tabCash.buttonMode = false;
				
				swapIndex('cash');
			}
		}		
		
		
	}

}