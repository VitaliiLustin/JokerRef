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
	public class OrderTrump
	{
		
		public var container:MovieClip;
		
		private var _emptyBtn	:Button;
		
		private var _clubsBtn	:Button;
		private var _diamondsBtn:Button;
		private var _spadesBtn	:Button;
		private var _heartsBtn	:Button;
		
		public function OrderTrump(cont:MovieClip) 
		{
			container = cont;
			
			_emptyBtn 		= new Button(container.empty, onSetOrder);
			
			_clubsBtn 		= new Button(container.C, onSetOrder);
			_diamondsBtn 	= new Button(container.D, onSetOrder);
			_spadesBtn 		= new Button(container.S, onSetOrder);
			_heartsBtn 		= new Button(container.H, onSetOrder);
		}
		
		public function setActive(act:Boolean):void
		{
			container.visible = act;
		}
		
		private function onSetOrder(e:MouseEvent):void 
		{
			container.visible = false;
			Facade.dispatcher.dispatch(GameEvent.SET_ORDER_TRUMP, e.currentTarget.name);
		}
	}
}