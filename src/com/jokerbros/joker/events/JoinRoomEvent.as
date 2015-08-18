package com.jokerbros.joker.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class JoinRoomEvent extends Event
	{
		
		public static const TAKE_PLACE:String = "take_place";
		public static const FREE_PLACE:String = "free_place";
		public static const SHOW_BLACK_LIST:String = "show_black_list";
		public static const SHOW_HELP:String = "show_help";

		public var data: Object;
		
		public function JoinRoomEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new JoinRoomEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "JoinRoomEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}