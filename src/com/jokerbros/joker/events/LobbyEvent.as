package  com.jokerbros.joker.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 13
	 */
	public class LobbyEvent extends Event 
	{
		

		public static const ROOM_REMOVED:String  = "room_removed";
		public static const ROOM_CREATED:String = "room_created";
		
		public static const START_GAME:String = "start_game";
		
		public static const INIT_GAME:String = "init_game";
		
		public var data: Object;
		
		public function LobbyEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			
			this.data = data;
			
		}
		
		public override function clone():Event 
		{ 
			return new LobbyEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "LobbyEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
		
	}

}