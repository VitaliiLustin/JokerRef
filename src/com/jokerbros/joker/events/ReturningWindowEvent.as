package com.jokerbros.joker.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 13
	 */
	public class ReturningWindowEvent extends Event 
	{
		
		public static const RESPONSE:String = "response";
		
		
		public var data: Object;
		
		public function ReturningWindowEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new ReturningWindowEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "ReturningWindowEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}