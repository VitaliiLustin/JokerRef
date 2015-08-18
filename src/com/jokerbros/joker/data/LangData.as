package com.jokerbros.joker.data 
{
	/**
	 * ...
	 * @author ...
	 */
	public class LangData 
	{
		
		private var _langName : String = "default";
		private var _langData : Object = {};
		
		public function get langName() : String
		{
			return _langName;
		}
		public function set langName( newName : String ) : void
		{
			_langName = newName;
		}
		
		public function get langData() : Object
		{
			return _langData;
		}
		
		public function set langData( newData : Object ) : void
		{
			_langData = newData;
		}
		
		public function getText(key:String):String
		{
			if (_langData.hasOwnProperty(key)) {
				return _langData[key];
			}else {
				trace('LangData   now text by key - ' + key + '   lang - ' + _langName);
			}
			
			return '';
		}
		
		public function dispose() : void
		{
			_langName = "default";
			_langData = null;
		}
		
	}

}