package com.jokerbros.joker.game 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * ...
	 * @author 13
	 */
	public class GameSound extends Sound 
	{
		/*
		[Embed(source="../../../../../sound/moveCard.mp3")]
		private static const SOUND_MOVE_CARD:Class;  
		
		[Embed(source="../../../../../sound/soundTimer.mp3")]
		private static const SOUND_TIMER:Class;  
		
		public static var lastTime:int = 0;
		
		//private static const tempSound:Sound;
		*/
		
		public function GameSound() 
		{

		}
		
		/*
		public static function play(sound:String = 'moveCard'):void
		{
			if (sound == 'moveCard')
			{
				var tempSound:Sound = new SOUND_MOVE_CARD();
				
				tempSound.play();

			}
		}
		*/
		
		
		public static function play(sound:String = 'moveCard'):void
		{

			try 
			{
				//SoundMixer.stopAll();
				var channel1:SoundChannel = new SoundChannel();
				var volumeAdjust:SoundTransform = new SoundTransform();
					volumeAdjust.volume = 7;
				
				switch(sound)
				{
					case 'moveCard'				:   channel1 = new soundMoveCard().play(); channel1.soundTransform = volumeAdjust;		break;
					case 'startGame'			:   channel1 = new soundStartGame().play(); channel1.soundTransform = volumeAdjust;		break;
					
					/*case 'gameOver'				:   new soundGameOver().play(); 		break;
					
					case 'gameWin'				:   new soundGameWin().play(); 			break;
					
					case 'startGame'				:   new soundStartGame().play(); 		break;*/
				}
			}
			catch (err:Error)
			{
				
			}
			
		}
		
		
		
	}

}