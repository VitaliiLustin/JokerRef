package com.jokerbros.joker.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author wdasd
	 */
	public class TableOfRoomsEvent extends Event 
	{
		
		public static const SIT_PUBLIC_ROOM:String = "sit_public_roomt";
		public static const SIT_RPIVATE_ROOM:String = "sit_private_room";
		public static const REMOVE_MY_ROOM:String = "remove_my_room";
		
		public var data: Object;
		
		public function TableOfRoomsEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );

			this.data = data;
		}
		
		public override function clone():Event 
		{ 
			return new TableOfRoomsEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "TableOfRoomsEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
		
		
	}

}