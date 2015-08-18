package  com.jokerbros.joker.lobby.windows
{
	/**
	 * ...
	 * @author JokerBros
	 */
	import com.jokerbros.joker.connector.Connector;
	import com.jokerbros.joker.events.CreateRoomEvent;
	import com.jokerbros.joker.events.RadioPointEvnt;
	import com.jokerbros.joker.user.User;
	import com.jokerbros.joker.lobby.radio.*;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.requests.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	
	import com.greensock.TweenNano;
	import com.greensock.easing.*;
	 
	public class CreateRoom extends mcCreateRoom 
	{

		private var _radioPoint:RadioPoint;
		//private var _radioCashBet:RadioCashBet;
		//private var _radioFunBet:RadioFunBet;
		private var _bet:MovieClip;
		
		private var _gameType:int;
		
		public function CreateRoom(gameType:int) 
		{
			_gameType = gameType;
			
			this.x = 185;
			this.y = 130;
			
			this.mcModal.alpha = 0.6;
			
			this.mcProgress.visible = false;	
			this.errorMsg.visible = false;
			this.password.visible = true;
			
			
			// init font
			
			var bpgArial:String = new BGPArial().fontName;
			
			this.password.input.embedFonts = true;
			this.password.input.antiAliasType = AntiAliasType.ADVANCED;
			this.password.input.setTextFormat( new TextFormat(bpgArial) );
			
			this.mcRadioCashBet.visible = false;
			this.mcRadioFunBet.visible = false;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			stage.addEventListener(Event.RESIZE, this.resizeCreateRoom);

			_radioPoint = new RadioPoint(this.mcRadioPoint);
			
			if (_gameType == 1) // cash game
			{
				_bet = new RadioCashBet(this.mcRadioCashBet);
			}
			else if(_gameType == 2) // fun game
			{
				_radioPoint.addEventListener(RadioPointEvnt.CHANGE, onPointChange)	
				
				_bet = new RadioFunBet(this.mcRadioFunBet);
			}
			

			
			initPassword();
			
			this.btnEventsEnabled(true);
			
			this.resizeCreateRoom();
		}
		
		private function onPointChange(e:RadioPointEvnt):void 
		{
			//
			
			_bet.changeFrame(int(e.data));
			
		}
		
		private function onCreate(e:MouseEvent):void 
		{
			this.hideError();
			
			this.btnEventsEnabled(false);
		
			if ( !this.checkPassword())
			{
				this.btnEventsEnabled(true);
			}
			else
			{
				this.btnCreate.visible = false;
				this.mcProgress.visible = true;	
				
				this.createRoom( this.getPassword() );
			}
			
		}
		
		private function onClose(e:MouseEvent):void 
		{
			this.btnEventsEnabled(false);
			dispatchEvent( new CreateRoomEvent( CreateRoomEvent.RESPONSE, false ) );
		}
		

		
		/*create room send for server*/
		private function createRoom(password:String):void
		{
			var data:ISFSObject = new SFSObject();
			
				//data.putInt("type", _radioPoint.selectedPoint); 
			    //data.putDouble("bet", _bet.selectedBet);
				
				data.putInt("type", 1); 
				data.putInt("bet", 40);
				
				data.putUtfString('password', password);
				
				
				
			Connector.send("createRoom", data);
		}
		
		/*pass manege*/
		private function initPassword():void
		{
			this.destroyPassword();
			this.password.input.restrict="a-zA-Z0-9";
			this.password.input.addEventListener(FocusEvent.FOCUS_IN, passFocusIn)
			this.password.input.addEventListener(FocusEvent.FOCUS_OUT, passFocusOut)
		}
		
		private function destroyPassword():void
		{
			//this.password.input.restrict="გთხოვთ შეიყვანოთ პაროლი";
			this.password.input.text = 'გთხოვთ შეიყვანოთ პაროლი';
			this.password.input.textColor = 0xFFFFFF;
			this.password.input.removeEventListener(FocusEvent.FOCUS_IN, passFocusIn)
			this.password.input.removeEventListener(FocusEvent.FOCUS_OUT, passFocusOut)
		}
		
		private function checkPassword():Boolean
		{
			this.password.input.text.replace(/^\s+|\s+$/gs, '');
			
			if (this.password.input.text == 'გთხოვთ შეიყვანოთ პაროლი')
			{
				this.password.input.textColor = 0xFF0000;
			}
			else if (this.password.input.text == '')
			{
				this.password.input.text = 'გთხოვთ შეიყვანოთ პაროლი'
				this.password.input.textColor = 0xFF0000
			}
			else
			{
				return true;
			}
			
			return false;
		}
		
		private function getPassword():String
		{
			return this.password.input.text.replace(/^\s+|\s+$/gs, '');
		}
		
		private function passFocusIn(e:FocusEvent):void 
		{
			this.password.input.textColor = 0xFFFFFF;
			
			if (this.password.input.text == 'გთხოვთ შეიყვანოთ პაროლი')
			{
				this.password.input.text = '';
			}
		}
		
		private function passFocusOut(e:FocusEvent):void 
		{
			if (this.password.input.text.replace(/^\s+|\s+$/gs, '') == '')
			{
				this.password.input.text = 'გთხოვთ შეიყვანოთ პაროლი';
			}
		}
		
		/*respons manege*/
		private function createSuccess(roomID:String = '', password:String=''):void 
		{
			dispatchEvent( new CreateRoomEvent( CreateRoomEvent.RESPONSE, {roomID:roomID, roomPassword:password } ) );
		}
		
		private function showError(message:String):void
		{
			this.errorMsg.message.text = message;
			this.errorMsg.visible = true;
			
			this.btnEventsEnabled(true);
		}
		
		private function hideError():void
		{
			this.errorMsg.visible = false;
		}

		public function response(params:ISFSObject):void
		{
			var code:int = params.getInt("code");

			switch( code )
			{
				
				case 0:   createSuccess(params.getSFSObject('room').getUtfString('roomName'), params.getSFSObject('room').getUtfString('password'));
						  break;
						  
				case 1:   showError('თქვენ არ გაქვთ საკმარისი თანხა ბალანსზე');  
						  break;
						  
				case 2:   showError('მოხდა ტექნიკური ხარვეზი');   
						  break;
			}
			
			this.mcProgress.visible = false;
		}		
		
		
		private function btnEventsEnabled(param:Boolean = true):void
		{
			if (param)
			{
				this.btnCreate.addEventListener(MouseEvent.CLICK, onCreate)
				this.btnClose.addEventListener(MouseEvent.CLICK, onClose)
				
				this.btnCreate.visible = true;
			}
			else
			{
				this.btnCreate.removeEventListener(MouseEvent.CLICK, onCreate)
				this.btnClose.removeEventListener(MouseEvent.CLICK, onClose)
				
				this.btnCreate.visible = false;
			}
		}
		
		private function destroy(e:Event):void
		{
			
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			if (stage) stage.removeEventListener(Event.RESIZE, this.resizeCreateRoom);
			
			this.btnEventsEnabled(false);
			this.destroyPassword();
			
			if (_radioPoint)
			{
				_radioPoint.removeEventListener(RadioPointEvnt.CHANGE, onPointChange)
				_radioPoint.destroy();
				_radioPoint = null;
			}
			
			if (_bet)
			{
				_bet.destroy();
				_bet = null	
			}
		}
		
		private function resizeCreateRoom(e:Event=null):void 
		{
			this.mcModal.x = -stage.stageWidth / 2;
			this.mcModal.y = -stage.stageHeight / 2;
			
			this.mcModal.width = stage.stageWidth + 500;
			this.mcModal.height = stage.stageHeight + 250;
		}
		
		
	}

}