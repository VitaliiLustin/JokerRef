package com.jokerbros.joker.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class ChangeRoomTypeEvent extends Event
	{
		
		public static const CHANGE:String = "change";
		
		public var data: Object;
		
		public function ChangeRoomTypeEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new ChangeRoomTypeEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "ChangeRoomTypeEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}