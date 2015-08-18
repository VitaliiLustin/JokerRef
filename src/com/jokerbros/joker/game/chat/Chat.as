package com.jokerbros.joker.game.chat 
{
	import com.jokerbros.Parametrs;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.*;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;

	
		
	import com.smartfoxserver.v2.requests.*;
	import com.smartfoxserver.v2.entities.data.*;
	
	import com.jokerbros.joker.connector.Connector;
	/**
	 * ...
	 * @author ...
	 */
	public class Chat 
	{
		private const MAX_MSG:int = 30;
		
		private var _input			:	TextField;
		private var _chatBox		:	MovieClip;
		private var _power			:	MovieClip;
		private var _btnSend		:	SimpleButton;
		private var _minimize		:	MovieClip;
	
		private var _newMsgCount	:	int = 0;
		
		private var _items:Vector.<Item>;
		
		private var _mcChat:MovieClip;
		
		public function Chat($mc:MovieClip) 
		{
			_mcChat = $mc;
			
			
			_mcChat.chatClose.visible = false;
			_mcChat.chatClose.buttonMode = true;
			_mcChat.chatClose.useHandCursor = true;
			_mcChat.chatClose.mouseChildren = false;
			_mcChat.chatClose.addEventListener(MouseEvent.CLICK, openChat);
			
			_mcChat.chatOpen.visible = true;
			_mcChat.chatOpen.oppDisable.visible = false;
			_mcChat.chatOpen.myChatDisable.visible = false;
			
			_input = _mcChat.chatOpen.input;
			_input.addEventListener(FocusEvent.FOCUS_IN,textInputHandler);
			_input.addEventListener(FocusEvent.FOCUS_OUT, textInputHandlerOut);
			_input.text = '';
			
			_chatBox = _mcChat.chatOpen.chatBox;
			
    		_power = _mcChat.chatOpen.power;
			_power.buttonMode = true;
			_power.useHandCursor = true;
			_power.mouseChildren = false;
			_power.addEventListener(MouseEvent.CLICK, onPower);
			_power.gotoAndStop(1);

			_btnSend = _mcChat.chatOpen.btnSend;			
			_btnSend.addEventListener(MouseEvent.CLICK, onSend);
			
			_minimize = _mcChat.chatOpen.close;
			_minimize.buttonMode = true;
			_minimize.useHandCursor = true;
			_minimize.addEventListener(MouseEvent.CLICK, onMinimize);
			
			
			_mcChat.chatClose.newMsg.visible = false;
			
			onMinimize();
			
			clearContent();
			
			init();
		}
		
		public function init(isOnline:Boolean = true, oppIsOnline:Boolean = true):void
		{
			if (isOnline == false)
			{
				onPower();
			}
			
			if (oppIsOnline == false)
			{
				updateChatStatus()
			}
		}
		
		
		private function onMinimize(e:MouseEvent=null):void 
		{
			_mcChat.chatOpen.visible = false;
			_mcChat.chatClose.visible = true;
			
			_minimize.removeEventListener(MouseEvent.CLICK, onMinimize);
			
		}
		
		private function openChat(e:MouseEvent):void 
		{
			if (_mcChat.chatOpen.visible == false)
			{
				_mcChat.chatOpen.visible = true;
				_minimize.addEventListener(MouseEvent.CLICK, onMinimize)
				// reset new msg
				_mcChat.chatClose.newMsg.visible = false;
				_mcChat.chatClose.newMsg.value.text = '';
				_newMsgCount = 0;
			}
			else
			{
				onMinimize()
			}

		}
		
				// login / logout
		private function onPower(e:MouseEvent=null):void 
		{
			var onlineStatus:ISFSObject = new SFSObject();
			
			if (_power.currentFrame == 1) // disable chat
			{
				_btnSend.removeEventListener(MouseEvent.CLICK, onSend);
				_power.gotoAndStop(2);
				_input.visible = false; 
				_mcChat.chatOpen.myChatDisable.visible = true;

				onlineStatus.putBool(Parametrs.PARAM_STATUS, false);
				
			}
			else // enable chat
			{	

				if (_mcChat.chatOpen.oppDisable.visible == false)
				{
					_btnSend.addEventListener(MouseEvent.CLICK, onSend)
					_input.visible = true;
				}
				
				_power.gotoAndStop(1);
				
				_mcChat.chatOpen.myChatDisable.visible = false;

				onlineStatus.putBool(Parametrs.PARAM_STATUS, true);  
			}
	
			Connector.send(Parametrs.PARAM_CHAT_STATUS, onlineStatus);
		}
		
		private function chatSend():void 
		{
			
			if (_input.length < 1) return;
			
			setMessage(_input.text, true);
			
			var sendToServer:ISFSObject = SFSObject.newInstance();
				sendToServer.putUtfString(Parametrs.PARAM_MSG, _input.text);
				
			Connector.send(Parametrs.PARAM_CHAT,sendToServer);
			
			trace(_input.text)
			
			_input.text = '';
			
		}
		
		public function updateChatStatus(list:ISFSObject=null):void 
		{
			
			var bool:Boolean = false;
			var count:int = 0;
			var isfsarr:ISFSArray = (list) ? list.getSFSArray(Parametrs.PARAM_USERS) : null;
			
			if (isfsarr)
			{
				for (var i:int = 0; i < isfsarr.size(); i++) 
				{
					if (isfsarr.getSFSObject(i).getBool(Parametrs.PARAM_STATUS) == true) 
					{
						count ++;
					}
				}
			}
			

			bool = (count > 1) ? true :false
			
			if (bool == false) // opp disable chat
			{
				_mcChat.chatOpen.oppDisable.visible = true;
				_input.visible = false;
				_btnSend.removeEventListener(MouseEvent.CLICK, onSend);
			}
			else // opp enable chat
			{
				_mcChat.chatOpen.oppDisable.visible = false;
				_input.visible = true;
				_btnSend.addEventListener(MouseEvent.CLICK, onSend);
			}
		}
		
		public function updateChatMessage(utfString:String, ind:int=0):void 
		{
			if (_mcChat.chatOpen.visible == false)
			{
				_newMsgCount ++;
				_mcChat.chatClose.newMsg.visible = true;
				_mcChat.chatClose.newMsg.value.text = _newMsgCount.toString();
			}
			
			//setMessage('Bros'+ind +': ' + utfString, false)
			setMessage('--' + ind +': ' + utfString, false);
		}
		
		public function action(cmd:String, params:ISFSObject):void
		{
			
			switch( cmd )
			{   
				case Parametrs.PARAM_UPDATE_CHAT_MSG: 
					updateChatMessage( params.getUtfString(Parametrs.PARAM_MSG), params.getInt(Parametrs.PARAM_INDEX) );	                  
				break;
				case Parametrs.PARAM_UPDATE_CHAT_STATUS:  
					updateChatStatus(params);	 
				break;
			}
			
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------HANDLERS------------------------------------------------------------------------------------------*/
		private function onSend(e:MouseEvent):void 
		{
			this.chatSend();	
		}
		
		private function textInputHandler(event:FocusEvent):void 
		{
			_input.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler);
			_input.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler);
		}

		private	function textInputHandlerOut(event:FocusEvent=null):void 
		{
			_input.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler);
			_input.removeEventListener( KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			_input.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler);	
			if (event.charCode == 13)
			{
				_input.text = '';
			}
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			_input.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			if (event.charCode == 13)
			{
				chatSend();	
			}
		}
		
		
		public function setMessage(msg:String, isMy:Boolean):void
		{
			//if tu chemi gagzavnilia mosulia ukna
			_items.unshift(new Item(msg, isMy));
			
			updateContent();
		}
		
		
		private function clearContent():void
		{
			if(_items){
				for (var i:int = 0; i < _items.length; i++) 
				{
					_items[i].destroy();
					_items[i] = null;
				}
			}
			
			_items = new Vector.<Item>();
		}
		
		private function updateContent():void
		{
			while (_mcChat.chatOpen.mcChatBox.numChildren > 0) {
				_mcChat.chatOpen.mcChatBox.removeChildAt(0);
			}
			
			var yy:int = 0;
			var len:int = (_items.length > MAX_MSG) ? MAX_MSG : _items.length;
			
			for (var i:int = 0; i < len; i++) 
			{
				yy = yy - _items[i].mc.height - 5;
				_items[i].mc.y = yy;
				_mcChat.chatOpen.mcChatBox.addChild(_items[i].mc);
			}
		}
		
		public function destroy():void
		{
			clearContent();
			
			_mcChat.chatClose.removeEventListener(MouseEvent.CLICK, openChat);
			_input.removeEventListener(FocusEvent.FOCUS_IN,textInputHandler);
			_input.removeEventListener(FocusEvent.FOCUS_OUT, textInputHandlerOut);
			_power.removeEventListener(MouseEvent.CLICK, onPower);	
			_btnSend.removeEventListener(MouseEvent.CLICK, onSend);
			_minimize.removeEventListener(MouseEvent.CLICK, onMinimize);
			
			if (_minimize.parent) {
				_minimize.removeChild(_minimize);
			}
			if (_mcChat.parent) {
				_mcChat.removeChild(_mcChat);
			}
			if (_power.parent) {
				_power.removeChild(_power);
			}
			if (_chatBox.parent) {
				_chatBox.removeChild(_chatBox);
			}
			
			_minimize = null;
			_power = null;
			_mcChat = null;
			_chatBox = null;
			_input = null;
			_btnSend = null;
		}
		
	}

}
