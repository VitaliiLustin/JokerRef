package com.jokerbros.joker.game 
{
	
	import com.jokerbros.joker.events.PanelEvent;
	import com.jokerbros.joker.game.GameActionWindow.*;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ValeriiT.Fedorov
	 */
	public class ActionPanel
	{
		
		public static const FIRST_MOVE	:String = 'firstMove';
		public static const SECOND_MOVE	:String = 'secondMove';
		public static const ORDER		:String = 'order';
		public static const ORDER_TRUMP	:String = 'orderTrump';
		
		public var container		:MovieClip;
		public var firstJokerMove	:FirstJokerMove;
		public var secondJokerMoves	:SecondJokerMove;
		public var order			:Order;
		public var orderTrump		:OrderTrump;
		
		private var _orderData		:Object = {};
		
		public function ActionPanel(cont:MovieClip) 
		{
			container = cont;
			
			firstJokerMove 	 = new FirstJokerMove(container.mcFirstJokerMove);
			secondJokerMoves = new SecondJokerMove(container.mcSecondJokerMove);
			order 			 = new Order(container.mcOrder, _orderData );
			orderTrump 		 = new OrderTrump(container.mcOrderTrump);
			
			firstJokerMove.setActive(false);
			secondJokerMoves.setActive(false);
			order.setActive(false);
			orderTrump.setActive(false);
		}
		
		public function setOrderData(maxOrder:int, access:int = -1, fill:int=-1, autoOrder:int = -1):void
		{
			_orderData = { 'maxOrder':maxOrder, 'access':access, "fill":fill, 'autoOrder':autoOrder };
			order.updateData(_orderData);
		}
		
		public function show(action:String = 'order', act:Boolean = false):void 
		{
			switch (action) 
			{
				case 'order'		:onOrder(act);		 break;
				case 'orderTrump'	:onOrderTrupm(act);  break;
				case 'firstMove'	:onFirstMove(act);	 break;
				case 'secondMove'	:onSecondMove(act);  break;
			}
		}
		
		private function onFirstMove(act:Boolean = false):void 
		{
			firstJokerMove.setActive(act);
		}
		
		private function onSecondMove(act:Boolean = false):void 
		{
			secondJokerMoves.setActive(act);
		}
		
		private function onOrder(act:Boolean = false):void 
		{
			order.setActive(act);
		}
		
		private function onOrderTrupm(act:Boolean = false):void 
		{
			orderTrump.setActive(act);
		}
		
		
	
	}

}