/**
 * Created by Vadim on 17.06.2015.
 */
package com.jokerbros.joker.models
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class GameModel extends EventDispatcher
	{
		public static const INITED:String = "GameModelInited";
		
		private var _inited		:Boolean;
		private var _userModel	:DataModel;

		public function GameModel()
		{
			super();
		}

		public function init():void 
		{
			if(_inited){
				trace("GameModelLobby init.");
			}
		}

		public function dataUser(user:DataModel):void
		{
			_userModel = user;
			if(!_inited){
				_inited = true;
				dispatchEvent(new Event(INITED));
			} else {
				//need write
			}
		}

		public function get inited():Boolean 
		{
			return _inited;
		}
		
		public function get userData():DataModel
		{
			return _userModel;
		}
	}
}
