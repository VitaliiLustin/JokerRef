package com.jokerbros.joker.managers
{
	import com.jokerbros.joker.data.LangData;
	import com.junkbyte.console.Cc;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class LangManager
	{
		public static const LANG_URL:String = 'https://testing.jokerbros.com/SITE/newreg/media/poker/langRoom/';
		
		public static const DEFAULT_NAME	: String = "default";
		
		public static const GR				: String = "gr";
		public static const RU				: String = "ru";
		public static const EN				: String = "en";
		
		
		public static const VALID_LANGS		:Vector.<String> = Vector.<String>( [ GR, RU, EN ] );
		
		private static const TRYES_LOAD 	: int = 3;
		
		private static var _countLoad		:int = 0;
		private static var _currentURL		:String = '';
		
		private static var _currentLangName : String = DEFAULT_NAME;
		private static var _currentLangData : Object;
		
		
		private static var _langsData 		: Vector.<LangData> = new Vector.<LangData>();
		
		private static var _loadCallback:Function;
		
		
		public static function loadLang ( url : String, language : String = EN, callback:Function = null ):void
		{
			trace("start load lang ");
			Cc.log("start load lang "+language);
			url = url + language + '.xml';
			_loadCallback = callback;
			
			_currentLangName = language;
			_currentURL = url;
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadCompleteHandler, false, 0, true );
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorLoadingLang, false, 0, true );
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorSecurityLoadingLang, false, 0, true );

			var _urlRequest:URLRequest = new URLRequest( url );
			
			loader.load(_urlRequest);
			
			_countLoad++;
		}
		
		
		private static function errorLoadingLang( event : IOErrorEvent ):void
		{
			reloadLang( URLLoader( event.target ) );
		}
		
		private static function errorSecurityLoadingLang( event : SecurityErrorEvent ):void
		{
			reloadLang( URLLoader( event.target ) );
		}
		
		private static function reloadLang( loader 	: URLLoader ):void
		{
			if ( _countLoad >= TRYES_LOAD )
			{
				loader.removeEventListener( Event.COMPLETE, loadCompleteHandler );
				loader.removeEventListener( IOErrorEvent.IO_ERROR, errorLoadingLang );
				loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, errorSecurityLoadingLang );
			}
			else
			{
				loader.addEventListener(Event.COMPLETE, loadCompleteHandler, false, 0, true );
				loader.addEventListener(IOErrorEvent.IO_ERROR, errorLoadingLang, false, 0, true );
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorSecurityLoadingLang, false, 0, true );

				var _urlRequest:URLRequest = new URLRequest( _currentURL );

				loader.load( _urlRequest );
			}
		}
		
		private static function loadCompleteHandler( event : Event ):void
		{
			var xml		: XML = XML( event.target.data );
			var loader 	: URLLoader = event.target as URLLoader;
			
			addLangXML( xml, _currentLangName );
			Cc.log("load lang - Complete");
			trace("load lang - Complete");
			loader.removeEventListener( Event.COMPLETE, loadCompleteHandler );
			loader.removeEventListener( IOErrorEvent.IO_ERROR, errorLoadingLang );
			loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, errorSecurityLoadingLang );
			
			loader.data = null;
			
			if (_loadCallback != null) {
				_loadCallback();
				_loadCallback = null;
			}
		}
		
		public static function addLangXML( langXML : XML, langName : String ) : void
		{
			var langData : LangData;
			var hasInData : Boolean = false;
			
			if ( hasLang( langName ) )
			{
				langData = getLangData( langName );
				hasInData = true;
			}
			else
			{
				langData = new LangData();
				langData.langName = langName;
				hasInData = false;
			}
			
			XML.ignoreWhitespace = true;
			var tag : *;
			for each ( tag  in langXML.children())
			{
				var nm:String = tag['@name'];
				var tr:String = tag['@translate'];
				langData.langData[nm] = tr;
			}
			
			if ( !hasInData )
			{
				_langsData[_langsData.length] = langData;
			}
			
			if ( _currentLangName == DEFAULT_NAME ) {	
				switchCurrentLang( langName );
			}
		}
		
		public static function get currentLangName( ) : String
		{
			return _currentLangName;
		}
		
		public static function hasText( key : String, langName : String = null ) : Boolean 
		{
			if ( langName == null )
			{
				return key in _currentLangData;
			}
			else
			{
				if ( hasLang( langName ) )
				{
					return key in getLangData( langName ).langData
				}
				else
					return false;
			}
		}
		
		public static function switchCurrentLang( langName : String ) : void 
		{
			if ( _currentLangName == langName ) 
				return;
			
			const OLD_NAME : String = _currentLangName;
			
			if ( hasLang( langName ) )
			{
				var lang : LangData = getLangData( langName );
				_currentLangName = lang.langName;
				_currentLangData = lang.langData;
			}
		}
		
		public static function get( key : String, replaces:Array = null ) : String
		{
			var text : String = 'no tag';
			
			var langData : LangData = getLangData( _currentLangName );
				
			if ( langData ) {	
				text = langData.getText(key);
			}else {
				trace('Lang Manager   now LangData by lang - ', _currentLangName);	
			}
				
			return text;
		}
		
		public static function getByLang( key : String, locale:String, ... replaces ) : String
		{
			var text : String = 'no tag';
			
			var langData:LangData = getLangData(locale);
			
			if(langData){
				text = langData.getText(key);
			}else {
				trace('Lang Manager   now LangData by lang - ', _currentLangName);	
			}
			
			return text;
		}
		
		public static function hasLang( langName : String ) : Boolean
		{
			if (_langsData.length == 0)
				return false;
			
			var lang : LangData;
			for (var i : int = 0; i < _langsData.length; i++)
			{
				lang = _langsData[i];
				if ( lang.langName == langName )
					return true;
			}
			return false;
		}
		
		private static function getLangData( langName : String ) : LangData
		{
			if (_langsData.length == 0)
				return null;
			
			var lang : LangData;
			for (var i : int = 0; i < _langsData.length; i++)
			{
				lang = _langsData[i];
				if ( lang.langName == langName )
					return lang;
			}
			return null;
		}
    }
}
