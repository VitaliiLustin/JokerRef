package com.jokerbros.joker.game.GameActionWindow 
{
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.buttons.Button;
	import com.jokerbros.joker.events.GameEvent;
	import com.jokerbros.joker.user.ReportException;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ValeriiT.Fedorov
	 */
	public class FirstJokerMove
	{
		public var container	:MovieClip;
		
		private var _highBtn	:Button;
		private var _takeBtn	:Button;
		
		private var _back		:MovieClip;
		private var _clubsBtn	:Button;
		private var _diamondsBtn:Button;
		private var _spadesBtn	:Button;
		private var _heartsBtn	:Button;
		
		private var _closeBtn	:Button;
		
		public function FirstJokerMove(cont:MovieClip) 
		{
			container 		= cont;
			
			_highBtn 		= new Button(container.btnHigh, onHigh);
			_takeBtn 		= new Button(container.btnTake, onTake);
			
			_back 			= container.back;
			_clubsBtn 		= new Button(_back.C, onChoose);
			_diamondsBtn 	= new Button(_back.D, onChoose);
			_spadesBtn 		= new Button(_back.S, onChoose);
			_heartsBtn 		= new Button(_back.H, onChoose);
			
			_closeBtn 		= new Button(container.close, onClose);
			
			_back.visible = false;
		}
		
		public function setActive(act:Boolean):void
		{
			container.visible = act;
		}
		
		private function onHigh(e:MouseEvent):void 
		{
			_back.visible = true;
		}
		
		private function onClose(e:MouseEvent):void 
		{
			setActive(false);
		}
		
		private function onTake(e:MouseEvent):void 
		{
			_back.visible = true;
		}
		
		private function onChoose(e:MouseEvent):void 
		{
			try 
			{
				var data:Object = new Object();
				
				data["action"] = (e.currentTarget.currentFrame == 2) ? 3 : 4; // 3 aris magali // 4 aris waigos
				data["order"] = e.currentTarget.name;					
				Facade.dispatcher.dispatch(GameEvent.MOVE_FIRST_JOKER, data);
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 144, 'FirstJokerMove' );
			}
			
			hide();
		}
		
		private function hide():void
		{
			container.visible = false;
		}
		
	}

}