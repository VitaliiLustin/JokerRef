package com.jokerbros.joker.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class ChangeGameTypeEvent extends Event
	{
		
		public static const CHANGE:String = "change";
		
		public var data: Object;
		
		public function ChangeGameTypeEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new ChangeGameTypeEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "ChangeGameTypeEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}