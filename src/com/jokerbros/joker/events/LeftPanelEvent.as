package com.jokerbros.joker.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 13
	 */
	public class LeftPanelEvent extends Event 
	{
		
		public static const GO_TO_LOBBY:String = "go_to_lobby";
		public static const REPORT:String = "report";
		
		public var data: Object;
		
		public function LeftPanelEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new LeftPanelEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "LeftPanelEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}		
		

}