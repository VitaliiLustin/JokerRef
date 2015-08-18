package com.jokerbros.joker.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class WindRatingEvent extends Event 
	{
		
		public static const CLOSE:String = "close";
		
		public var data: Object;
		
		public function WindRatingEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new WindRatingEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "WindRatingEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}