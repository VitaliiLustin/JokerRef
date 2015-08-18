package com.jokerbros.joker.Facade
{
import com.jokerbros.joker.events.GameDispatcher;
import com.jokerbros.joker.game.Game;
import com.jokerbros.joker.game.GameManager;
/**
	 * ...
	 * @author Vitalii
	 */
	public class Facade
	{
		public static var dispatcher:GameDispatcher;
		public static var game:Game;
		static public var gameManager:GameManager;
	}

}