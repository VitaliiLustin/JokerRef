package com.jokerbros.joker.game 
{
	import com.jokerbros.joker.events.PanelEvent;
	import com.jokerbros.joker.game.GameActionWindow.*;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 13
	 */
	public class ActionPanel extends MovieClip
	{
		private var _refDocument			:	MovieClip;
		
		private var _order					:	Order;
		private var _orderTrump				:	OrderTrump;
		private var _firstJokerMove			:	FirstJokerMove;
		private var _secondJokerMoves		:	SecondJokerMove;
		
		public function ActionPanel(obj:MovieClip) 
		{
			_refDocument = obj;
			trace(_refDocument)
		}
		
		public function show(panel:String = 'order'):void 
		{
			
			switch (panel) 
			{
				case 'order':		order();	break;
				case 'orderTrump':			break;
				case 'firstJokerMove':			break;
				case 'secondJokerMoves':			break;
			}
		}
		
		private function order():void 
		{
			_order = new Order(5,2);
			_order.addEventListener(PanelEvent.RESPONSE, onOrder);
			_refDocument.addChild(_order);
		}
		
		private function onOrder(e:PanelEvent):void 
		{
			_order.removeEventListener(PanelEvent.RESPONSE, onOrder);
			_refDocument.removeChild(_order);
			_order = null;
		}
		
		private function orderTrump():void 
		{
			
		}
		
		private function firstJokerMove():void 
		{
			
		}
		
		private function secondJokerMoves():void 
		{
			
		}
		
		
		
	}

}