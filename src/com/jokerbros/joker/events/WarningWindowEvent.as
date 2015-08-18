package com.jokerbros.joker.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 13
	 */
	public class WarningWindowEvent extends Event 
	{
		
		public static const CLOSE:String = "close";
		
		
		public var data: Object;
		
		public function WarningWindowEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new WarningWindowEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "WarningWindowEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
		
	}

