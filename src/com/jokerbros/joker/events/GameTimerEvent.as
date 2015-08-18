package com.jokerbros.joker.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 13
	 */
	public class GameTimerEvent extends Event 
	{
		
		public static const MY_END_TIMER:String = "my_end_timer";
		
		public var data: Object;
		
		public function GameTimerEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new GameTimerEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "GameTimerEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}