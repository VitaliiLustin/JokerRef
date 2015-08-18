package com.jokerbros.joker.lobby.windows 
{
	import com.jokerbros.joker.events.WindEnterPassEvent;
	import com.jokerbros.joker.user.User;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.requests.*;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	
	import com.greensock.TweenNano;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author wdasd
	 */
	public class WindEnterPass extends mcWindEnterPass
	{
		private var _joinRoomID:String
		
		public function WindEnterPass(roomID:String) 
		{
			_joinRoomID = roomID;
			
			this.x = 245;
			this.y = 180;
			
			this.mcModal.alpha = 0.6;
			
			this.errorMsg.visible = false;
			
			this.mcProgress.visible = false;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			stage.addEventListener(Event.RESIZE, this.resizeEnterPassWind);

			stage.focus = this.password.input;
			
			this.btnEventsEnabled(true);
			
			this.resizeEnterPassWind();
			
			this.initPassword();
		}
		
		private function destroy(e:Event):void 
		{

			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			if (stage) stage.removeEventListener(Event.RESIZE, this.resizeEnterPassWind);
			
			btnEventsEnabled(false);
			
			destoryPass();
			
		}
		
		
		private function btnEventsEnabled(boolean:Boolean = true):void 
		{
			if (boolean)
			{
				this.btnJoin.addEventListener(MouseEvent.CLICK, onJoin)
			    this.btnClose.addEventListener(MouseEvent.CLICK, onClose)
				
				this.btnJoin.visible = true;
			}
			else
			{
				this.btnJoin.removeEventListener(MouseEvent.CLICK, onJoin)
			    this.btnClose.removeEventListener(MouseEvent.CLICK, onClose)
				
				this.btnJoin.visible = false;
			}
		}
		
		/*BUTONS HANDLER*/
		private function onJoin(e:MouseEvent):void 
		{
			hideError();
			btnEventsEnabled(false);
			
			if (this.checkPassword() == false)
			{
				btnEventsEnabled(true);
			}
			else
			{
				this.btnJoin.visible = false;
				this.mcProgress.visible = true;
				
				var params:Object = {roomID: _joinRoomID, password: this.password.input.text.replace(/^\s+|\s+$/gs, '')}
				
				dispatchEvent(new WindEnterPassEvent(WindEnterPassEvent.RESPONSE, params))
			}
			
		}
		
		private function onClose(e:MouseEvent):void 
		{
			btnEventsEnabled(false);
			
			dispatchEvent(new WindEnterPassEvent(WindEnterPassEvent.RESPONSE, false))
		}
		
		/*PASSWORD*/
		private function initPassword():void
		{
			this.password.input.text = '';
			this.password.input.textColor = 0xFFFFFF;
			this.password.input.addEventListener(FocusEvent.FOCUS_IN, passFocusIn)
		}
		
		private function checkPassword():Boolean
		{
			this.password.input.text.replace(/^\s+|\s+$/gs, '');
			
			if (this.password.input.text == '' || this.password.input.text == 'შეიყვანეთ პაროლი')
			{
				this.password.input.text = 'შეიყვანეთ პაროლი'
				this.password.input.textColor = 0xFF0000;
				return false;
			}
			return true;
		}
		
		private function destoryPass():void
		{
			this.password.input.text = '';
			this.password.input.textColor = 0xFFFFFF;
			this.password.input.removeEventListener(FocusEvent.FOCUS_IN, passFocusIn)
		}
		
		private function passFocusIn(e:FocusEvent):void 
		{
			trace('sss')
			this.password.input.text.replace(/^\s+|\s+$/gs, '');
			
			if ( this.password.input.text == 'შეიყვანეთ პაროლი' )
			{
				this.password.input.text = '';
				this.password.input.textColor = 0xFFFFFF;
			}
		}
		
		
		private function resizeEnterPassWind(e:Event=null):void 
		{
			this.mcModal.x = -stage.stageWidth / 2;
			this.mcModal.y = -stage.stageHeight / 2;
			
			this.mcModal.width = stage.stageWidth + 500;
			this.mcModal.height = stage.stageHeight + 250;
		}
		
		private function showError(code:int):void
		{
			var message:String = '';
			
			switch( code )
			{
				case 1:  message = 'თქვენ არ გაქვთ საკმარისი თანხა ბალანსზე';  break;
				case 2:  message = 'მოხდა ტექნიკური ხარვეზი';    break;
				case 3:  message = 'პაროლი არასწორია';   break;
			}
			
			this.errorMsg.message.text = message;
			this.errorMsg.visible = true;
			
			this.btnEventsEnabled(true);
			
			if (code == 3) initPassword();
			
		}
		
		private function hideError():void
		{
			this.errorMsg.visible = false;
		}
		
		public function response(code:int):void 
		{
			this.showError(code);	
			
			this.mcProgress.visible = false;
		}
		
	}

}