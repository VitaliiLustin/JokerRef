package com.jokerbros.joker.lobby 
{
	import com.greensock.TweenNano;
	import com.jokerbros.joker.events.LobbyEvent;
	import com.jokerbros.joker.events.WaitingListEvent;
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.user.User;
	import flash.display.MovieClip;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class WaitingList/* extends MovieClip*/ 
	{

		private var _isVisible:Boolean;
		public function get isVisible():Boolean { return _isVisible; }
		
		private var _mcWaitingList:MovieClip;
		
		public function WaitingList(wind:MovieClip) 
		{
			_mcWaitingList = wind;
			
			_mcWaitingList.visible = false;
			
			_isVisible = false;
		}
		
		
		public function destroy():void
		{
			_isVisible =  false;
			try 
			{
				_mcWaitingList.btnRemove.removeEventListener(MouseEvent.CLICK, onRemoveRoom);
				_mcWaitingList.linkToRoom.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
				_mcWaitingList.linkToRoom.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			}
			catch (err:Error)
			{
				
			}

		}
		
		
		private function onRemoveRoom(e:MouseEvent):void 
		{
			hide();
			Facade.dispatcher.dispatch(LobbyEvent.CHANGE, onChangeRoomType);
			//dispatchEvent(new WaitingListEvent(WaitingListEvent.REMOVE_ROOM));
		}
		
		public function show(roomID:String = '', roomPassword:String = ''):void
		{
			_mcWaitingList.btnRemove.addEventListener(MouseEvent.CLICK, onRemoveRoom);
		
			_mcWaitingList.visible = true;
				
			//password
			_mcWaitingList.linkToRoom.text = 'http://jokerbros.com/joker/joinPrivateRoom/'+ roomID + '&' + roomPassword;
			_mcWaitingList.password.text = roomPassword;
				
			_mcWaitingList.linkToRoom.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_mcWaitingList.linkToRoom.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			
			_isVisible =  true;
		}
		
		
		private function onFocusOut(e:FocusEvent):void 
		{
			e.target.setSelection(0, 0);
			_mcWaitingList.linkToRoom.background = false
			_mcWaitingList.linkToRoom.backgroundColor = 0xFFFFFF
		}
		
		private function onFocusIn(e:FocusEvent):void 
		{
			setTimeout(e.target.setSelection, 50, 0, e.target.text.length); 
			_mcWaitingList.linkToRoom.background = true
			_mcWaitingList.linkToRoom.backgroundColor = 0x2B2B2B
		}
		
		public function hide():void
		{
			_isVisible =  false;

			_mcWaitingList.btnRemove.removeEventListener(MouseEvent.CLICK, onRemoveRoom);
			_mcWaitingList.linkToRoom.text = '';
			_mcWaitingList.password.text = '';
			_mcWaitingList.visible = false;
			
			_mcWaitingList.linkToRoom.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_mcWaitingList.linkToRoom.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			
		}
		
	}

}