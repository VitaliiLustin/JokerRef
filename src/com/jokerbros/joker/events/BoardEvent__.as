package  com.jokerbros.backgammon.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 13
	 */
	public class BoardEvent extends Event 
	{
		public static const MOVE:String = "move";
		public static const UNDO:String = "undo";
		public static const LAST_MOVE:String = "last_move";
		
		public var data: Object;
		
		public function BoardEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );

			this.data = data;
		}
		
		public override function clone():Event 
		{ 
			return new BoardEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "BoardEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}