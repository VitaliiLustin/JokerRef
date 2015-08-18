package com.jokerbros.joker.events
{

import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author ...
	 */
	public class GameDispatcher extends EventDispatcher
	{
		
		public function GameDispatcher()
		{
			super();
		}
		
		public function dispatch(eventName:String, data:Object = null):void
		{
			dispatchEvent(new GameEvent(eventName, data));
		}
		
	}

}