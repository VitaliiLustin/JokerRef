package  com.jokerbros.joker.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 13
	 */
	public class ConnectorEvent extends Event 
	{
		public static const START:String = "start";
		public static const RESPONSE:String = "response";
		
		
		public var data: Object;
		
		public function ConnectorEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new ConnectorEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "ConnectorEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}