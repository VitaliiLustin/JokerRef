package com.jokerbros.joker.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author JokerBros.com
	 */
	public class AlertEvent extends Event 
	{
		public static const CLOSE:String = "close";
		
		public var data: Object;
		
		public function AlertEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new AlertEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "AlertEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}