package com.jokerbros.joker.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class TournamentEvent extends Event
	{
		
		public static const HOW_DISTRIBUTED:String = "how_distributed";
		public static const HOW_WORK:String = "how_work";
		public static const ALERT:String = "alert";
		
		public var data: Object;
		
		public function TournamentEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new TournamentEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "TournamentEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}