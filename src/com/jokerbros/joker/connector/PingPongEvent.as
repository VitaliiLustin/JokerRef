package com.jokerbros.joker.connector
{
	import flash.events.Event;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class PingPongEvent extends Event
	{
		public static const PING		:String = "ping";
		public static const TROUBLESHOOT:String = "troubleshoot";
		public static const BAD_NETWORK	:String = "bad_network";
		
		public var params: Object;
		
		public function PingPongEvent( type:String, params:Object = null, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
			
			this.params = params;
			
		}
		
		public override function clone():Event 
		{ 
			return new PingPongEvent( type, params, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "PingPongEventLobby", "params", "type", "bubbles", "cancelable", "eventPhase" );
		}
		
	}

}