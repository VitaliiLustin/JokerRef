package com.jokerbros.joker.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 13
	 */
	public class GameManagerEvent extends Event 
	{
		
		public static const RESPONSE:String = "response";
		public static const SET_ORDER:String = "set_order";
		public static const SET_ORDER_TRUMP:String = "set_order_trump";
		public static const MOVE:String = "move";
		
		public static const MOVE_FIRST_JOKER:String = "move_first_joker";
		public static const MOVE_SECOND_JOKER:String = "move_second_joker";
		
		public static const MOVE_JOKER_ACTION:String = "move_joker_action";
		
		public var data: Object;
		
		public function GameManagerEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new GameManagerEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "GameManagerEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}