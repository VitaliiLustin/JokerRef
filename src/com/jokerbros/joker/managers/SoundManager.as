package com.jokerbros.joker.managers 
{
	import com.greensock.plugins.SoundTransformPlugin;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author ValeriiT.Fedorov
	 */
	public class SoundManager 
	{
		
		// CONSTANTS
		
		//buttons
		public static const BUTTON_PUSH				:String = 'sound_pushButton';
		
		//cards
		public static const CARD_1					:String = 'sound_card1';
		public static const CARD_2					:String = 'sound_card2';
		public static const CARD_3					:String = 'sound_card3';
		public static const CARD_STACK				:String = 'sound_cardStack';
		public static const CARD_THROW				:String = 'sound_cardThrow';
		
		//chips
		public static const CHIP_1					:String = 'sound_chip1';
		public static const CHIP_2					:String = 'sound_chip2';
		public static const CHIP_3					:String = 'sound_chip3';
		public static const CHIP_4					:String = 'sound_chip4';
		public static const CHIP_5					:String = 'sound_chip5';
		public static const CHIPS_THROW_1			:String = 'sound_chipsThrow1';
		public static const CHIPS_THROW_2			:String = 'sound_chipsThrow2';
		public static const CHIPS_THROW_3			:String = 'sound_chipsThrow3';
		public static const CHIPS_THROW_4			:String = 'sound_chipsThrow4';
		public static const CHIPS_THROW_5			:String = 'sound_chipsThrow5';
		
		//background
		//public static const BACK_THEME_1			:String = 'backTheme1';
		//public static const BACK_THEME_2			:String = 'backTheme2';
		
		//game
		public static const CARD_FLY     			:String = 'sound_whipe';
		public static const CHECK					:String = 'sound_check';
		public static const BET_FLY					:String = 'sound_betFly';
		public static const CARDS_TRICK				:String = 'sound_cards_trick';
		public static const LOSE					:String = 'sound_lose';
		public static const OPEN_CARD				:String = 'sound_openCard';
		public static const TAKE_WIN				:String = 'sound_takeWin';
		public static const WIN						:String = 'sound_win';
		
		//timer
		public static const TIMER_SOUND1			:String = 'sound_timer1';
		public static const TIMER_SOUND2			:String = 'sound_timer2';
		public static const TIMER_SOUND3			:String = 'sound_timer3';
		
		
		//managing constants
		public static const MAX_VOLUME				:int = 1;
		public static const SOUND_VOLUME			:int = 1;
		public static const SOUND_DISABLE			:int = 0;
		//public static const MUSIC_VOLUME			:int = 0.5;
		
		private static const LOCAL_NAME_SAVE:String = 'sound';
		
		
		//private
		private static var _soundChanel:SoundChannel;
		private static var _soundVolume:SoundTransform;
		private static var _classReference:Class;
		private static var _currentSound:Sound;
		private static var _soundEnable:Boolean = true;	
		private static var _lastSoundName:String;	
		private static var _instance:SoundManager;
		public static function get instance():SoundManager
		{
			if (!_instance) {
				_instance = new SoundManager();
			}

			return _instance;
		}

		public function SoundManager():void
		{
			if (!_instance) {
				_instance = this;
			}else {
				throw new Error('Use singleton instance');
			}
		}
		
		public static function switchSoundEnable():void
		{
			if (!_soundEnable) {
				SoundMixer.soundTransform = new SoundTransform(SOUND_VOLUME);
				_soundEnable = true;
				
				if (_lastSoundName) {
					playSound(_lastSoundName);
				}
				
			}else {
				stopSoundChannel();
				_soundEnable = false;
			}
			
			//saveSoundDisable(!_soundEnable);
			SharedManager.save(LOCAL_NAME_SAVE, !_soundEnable);
		}
		
		public static function setSoundState(value:Boolean):void
		{
			_soundEnable = value;
			if (_soundEnable) {
				SoundMixer.soundTransform = new SoundTransform(SOUND_VOLUME);
				
				if (_lastSoundName) {
					playSound(_lastSoundName);
				}
				
			}else {
				stopSoundChannel();
			}
		}
		
		public static function playSound(soundName:String):void
		{
			if (!_soundEnable) 
			{
				return
			}
			
			_classReference = getDefinitionByName(soundName) as Class;
			_currentSound = new _classReference as Sound;
			_lastSoundName = soundName;
			_soundChanel = _currentSound.play();
		}
		
		private static function stopSoundChannel():void
		{
			if (_soundChanel) {
				_soundChanel.stop();
			}
		}
		
		public static function get soundEnable():Boolean
		{
			return !SharedManager.getData(LOCAL_NAME_SAVE);
		}
	}

}