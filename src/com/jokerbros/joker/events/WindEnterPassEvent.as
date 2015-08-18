package com.jokerbros.joker.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author wdasd
	 */
	public class WindEnterPassEvent extends Event
	{
		
		public static const CLOSE:String = "response";
		public static const JOIN_PRIVATE_ROOM:String = "join_private_room";
		public static const RESPONSE:String = "response";
		
		
		public var data: Object;
		
		public function WindEnterPassEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new WindEnterPassEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "WindEnterPassEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}