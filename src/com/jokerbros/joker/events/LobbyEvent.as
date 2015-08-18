package  com.jokerbros.joker.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 13
	 */
	public class LobbyEvent extends Event 
	{
		

		public static const ROOM_REMOVED					:String = "room_removed";
		public static const ROOM_CREATED					:String = "room_created";
		
		public static const START_GAME						:String = "start_game";
		
		public static const INIT_GAME						:String = "init_game";
		
		public static const SHOW_GAME_HISTORY				:String = "show_game_history";
		public static const SHOW_RATING						:String = "show_rating";
		
		public static const CHANGE_GAME_TYPE				:String = "changeGameType";
		public static const CHANGE_ROOM_TYPE				:String = "change";
		public static const REMOVE_ROOM						:String = "close";
		public static const HIDE_ALERT						:String = "close";
		public static const CLOSE_WIND_RATING				:String = "close";
		public static const CLOSE_WIND_BLACKLIST			:String = "close";
		public static const CLOSE_WIND_HISTORY				:String = "close";
		public static const CLOSE_WIND_HELP					:String = "close";
		
		public static const SIT_PUBLIC_ROOM					:String = "sit_public_roomt";
		public static const SIT_RPIVATE_ROOM				:String = "sit_private_room";
		public static const REMOVE_MY_ROOM					:String = "remove_my_room";
		
		public static const TAKE_PLACE						:String = "take_place";
		public static const FREE_PLACE						:String = "free_place";
		public static const SHOW_BLACK_LIST					:String = "show_black_list";
		public static const SHOW_HELP						:String = "show_help";
		
		public static const ROOM_CANCEL						:String = "cancel";
		//public static const ROOM_CREATED					:String = "created";
		public static const ROOM_RESPONSE					:String = "response";
		
		public static const WIND_ENTER_CLOSE				:String = "response";
		public static const WIND_ENTER_JOIN_PRIVATE_ROOM	:String = "join_private_room";
		public static const WIND_ENTER_RESPONSE				:String = "response";
		
		public static const TOURNAMENT_HOW_DISTRIBUTED		:String = "how_distributed";
		public static const TOURNAMENT_HOW_WORK				:String = "how_work";
		public static const TOURNAMENT_ALERT				:String = "alert";
		
		
		
		
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