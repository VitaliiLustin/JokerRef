package  com.jokerbros.joker.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 13
	 */
	public class CreateRoomEvent extends Event 
	{
		
		public static const CANCEL:String  = "cancel";
		public static const CREATED:String = "created";
		public static const RESPONSE:String = "response";
		
		
		public var data: Object;
		
		public function CreateRoomEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new CreateRoomEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "CreateRoomEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}