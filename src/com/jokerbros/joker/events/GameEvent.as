package com.jokerbros.joker.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author 13
	 */
	public class GameEvent extends Event 
	{
		public static const LOGIN:String = "login";
		public static const GAME_INIT:String = "gameInit";
		public static const FULL_SCREEN:String = "fullScreen";
		public static const GAME_TO_LOBBY:String = "game_to_lobby";



		public static const MOVE_FIRST_JOKER	:String = 'MOVE_FIRST_JOKER';
		public static const MOVE_SECOND_JOKER	:String = 'MOVE_SECOND_JOKER';
		public static const SET_ORDER			:String = 'SET_ORDER';
		public static const SET_ORDER_TRUMP		:String = 'SET_ORDER_TRUMP';

		public var data: Object;
		
		public function GameEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{
			super( type, bubbles, cancelable );
			this.data = data;
		}
		
		public override function clone():Event 
		{ 
			return new GameEvent( type, data, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "GameEvent", "data", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
	}
}