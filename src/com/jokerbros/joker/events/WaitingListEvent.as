package com.jokerbros.joker.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author wdasd
	 */
	public class WaitingListEvent extends Event
	{
		
		public static const REMOVE_ROOM:String = "close";
		
		public var data: Object;
		
		public function WaitingListEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new WaitingListEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "WaitingListEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}