package com.jokerbros.backgammon.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 13
	 */
	public class EndGameEvent extends Event 
	{
		
		public static const CLOSE:String = "close";
		public static const CREATE_TABLE:String = "create_table";
		
		
		public var data: Object;
		
		public function EndGameEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new EndGameEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "EndGameEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}