package com.jokerbros.joker.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class WindGameHistoryEvent extends Event 
	{

		public static const CLOSE:String = "close";
		
		public var data: Object;
		
		public function WindGameHistoryEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new WindGameHistoryEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "WindGameHistoryEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}