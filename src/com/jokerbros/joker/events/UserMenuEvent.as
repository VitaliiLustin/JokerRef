package com.jokerbros.joker.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class UserMenuEvent extends Event 
	{
		
		public static const SHOW_GAME_HISTORY:String = "show_game_history";
		public static const SHOW_RATING:String = "show_rating";
		
		public var data: Object;
		
		public function UserMenuEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );

			this.data = data;
		}
		
		public override function clone():Event 
		{ 
			return new UserMenuEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "UserMenuEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}

}