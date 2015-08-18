package com.jokerbros.joker.game.GameActionWindow 
{
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.buttons.Button;
	import com.jokerbros.joker.events.GameEvent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ValeriiT.Fedorov
	 */
	public class SecondJokerMove
	{
	
		public var container		:MovieClip;
		
		private var _jokerUpBtn		:Button;
		private var _jokerDownBtn	:Button;

		private var _closeBtn		:Button;
		
		public function SecondJokerMove(cont:MovieClip) 
		{	
			container 		= cont;
			
			_jokerUpBtn 	= new Button(container.jokerUp, onUp);
			_jokerDownBtn 	= new Button(container.jokerDown, onDown);
			
			_closeBtn 		= new Button(container.close, onClose);
		}
		
		public function setActive(act:Boolean):void
		{
			container.visible = act;
		}
		
		private function onUp(e:MouseEvent):void 
		{
			Facade.dispatcher.dispatch(GameEvent.MOVE_SECOND_JOKER, 1);
		}
		
		private function onDown(e:MouseEvent):void 
		{
			Facade.dispatcher.dispatch(GameEvent.MOVE_SECOND_JOKER, 2);
		}
		
		private function onClose(e:MouseEvent):void 
		{
			Facade.dispatcher.dispatch(GameEvent.MOVE_SECOND_JOKER, null);
		}
	}
}