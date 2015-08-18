package com.jokerbros.joker.managers 
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author ...
	 */
	public class SharedManager 
	{
		private static const LOCAL_NAME_SAVE:String = 'jokerBrosPokerLocal'
		
		
		public static function save(key:String, value:Object):void
		{
			var so:SharedObject = SharedObject.getLocal(LOCAL_NAME_SAVE); 
			
			so.data[key] = value;
			
			so.flush();
		}
		
		public static function getData(key:String):Object
		{
			return SharedObject.getLocal(LOCAL_NAME_SAVE).data[key];
		}
	}

}