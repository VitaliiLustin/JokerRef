package com.jokerbros.joker.game 
{
/**
 * ...
 * @author JokerBros
 */
public class GameProperties
{
	public static const CURRENCY_USD	:String = 'usd';
	public static const CURRENCY_LAR	:String = 'gel';
	
	private static var _restore			:Boolean;
	
	public static var bet				:Number;
	public static var point				:int;
	public static var roomID			:String;
	public static var currency			:String = CURRENCY_LAR;
	
	public function GameProperties()
	{

	}

	public static function get restore():Boolean {
		return _restore;
	}

	public static function set restore(value:Boolean):void {
		_restore = value;
	}
}
}