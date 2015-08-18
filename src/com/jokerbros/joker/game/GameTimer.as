package com.jokerbros.joker.game 
{
	
	import com.greensock.TweenNano;
	import com.greensock.easing.*;
	import com.jokerbros.joker.events.GameTimerEvent;
	import com.jokerbros.joker.user.ReportException;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.media.Sound;
	import flash.events.*;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 13
	 */
	public class GameTimer extends mcUserLoading 
	{
		
		private const DEFAULT_SECOND:int = 15;
		private const START_PLAY_SOUND_SEC:int = 7;
		
		private var _game:MovieClip;
		

		private var _second:int;
		private var _owner:String;
		
		private var _sound:Sound;
		private var _soundTimer:Timer;
		private var _soundChannel:SoundChannel;
		
		private var _timer:Timer;
				
		private var _isEnabledSound:Boolean = false;
		
		public function GameTimer(obj:MovieClip, ind:int=0) 
		{
			_game = obj;
			
			this.x = 35;
			this.y = 92;
		}
		
		

		public function enable(owner:int = 4, sec:int = 15):void
		{
			this.disable();
			
			_second = sec;
			
			
			switch (owner) 
			{
				case Player.LEFT	:  _owner = 'Left';		break;
				case Player.TOP		:  _owner = 'Top';		break;
				case Player.RIGHT	:  _owner = 'Right';	break;
				case Player.BOTTOM	:  _owner = 'Bottom';	break;
			}
			
			try 
			{
				_game['player' + _owner].addChild(this);
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 82, 'GameTimer' );
			}

			TweenNano.to(this.mcMask, _second, { x:-181, ease:Linear.easeNone } );
			
			
			if (_owner == 'Bottom')
			{
				_timer = new Timer(1000, _second);
				_timer.addEventListener(TimerEvent.TIMER, onTickTimer)
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteTimer)
				_timer.start();	
			}
			
		}
		
		
		private function onTickTimer(e:TimerEvent):void 
		{
			var curCount:int = e.currentTarget.currentCount;
			
			if ((_second - curCount) <= START_PLAY_SOUND_SEC && _isEnabledSound == false)
			{
				_isEnabledSound = true;
				this.playSound()
			}
		}
		
		private function onCompleteTimer(e:TimerEvent):void 
		{
			
			if (_owner == 'Bottom')
			{
				dispatchEvent(new GameTimerEvent(GameTimerEvent.MY_END_TIMER));
			}
			
			disable();
		}
		
		private function clearTimer():void
		{
			if (_timer != null)
			{
				try 
				{
					if (_timer.running) _timer.stop();
					_timer.removeEventListener(TimerEvent.TIMER, onTickTimer)
					_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteTimer)
					_timer = null
				}
				catch (err:Error)
				{
					ReportException.send(err.message, 131, 'GameTimer' );
				}
			}
		}
		
		public function disable():void 
		{
			clearTimer();
			clearSound();
			
			try 
			{
				TweenNano.killTweensOf(this.mcMask); 
			}
			catch (err:Error)
			{
				trace('killTweensOf' + err);
				ReportException.send(err.message, 152, 'GameTimer' );
			}
			
			
			try 
			{
				
				if (_game['player' + _owner].contains(this))
				{
					_game['player' + _owner].removeChild(this);	
				}
				
				_game['player' + _owner].filters = [];
			}
			catch (err:Error)
			{
				//ReportException.send(err.message, 162, 'GameTimer' );
			}
			
			mcMask.x = 0;
			
			_isEnabledSound = false;
		}
		

		
				
		private function playSound():void
		{
			try 
			{
				//_sound  = new soundTimer();
				//_soundChannel = _sound.play();
				//_soundChannel.addEventListener(Event.SOUND_COMPLETE, onCompleteSound);	
			}
			catch (err:Error)
			{
				
			}
		}

		private function onCompleteSound(event:Event):void
		{
			try 
			{
				_soundChannel.removeEventListener(event.type, onCompleteSound);
				_sound = null;
				
				_soundTimer = new Timer(500, 1);
				_soundTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteSoundTimer)
				_soundTimer.start();	
			}
			catch (err:Error)
			{
				
			}
			
		}
		
		private function onCompleteSoundTimer(e:TimerEvent):void 
		{
			try 
			{
				_soundTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteSoundTimer);
				_soundTimer = null;	
			}
			catch (err:Error)
			{
				
			}
			
			playSound();
		}
		
		private function clearSound():void
		{
			try 
			{
				if (_sound != null)
				{
					_soundChannel.stop();	
					_soundChannel = null;
					_sound = null;
					
				}
			}
			catch (err:Error)
			{
				
			}
			
			try 
			{
				if (_soundTimer != null)
				{
					if (_soundTimer.running)
					{
						_soundTimer.stop();
					}
					
					_soundTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteTimer);
					
					_soundTimer = null;
				}
			}
			catch (err:Error)
			{
				
			}
		}
		
		
		public function restore(current:int, pos:int):void
		{
			disable();
			
			var oldSec:int = DEFAULT_SECOND - current

			if (oldSec <= 0 && pos == Player.BOTTOM)
			{
				dispatchEvent(new GameTimerEvent(GameTimerEvent.MY_END_TIMER));
				return;
			}
			
			_second = oldSec;
			
			switch (pos) 
			{
				case Player.LEFT	:  _owner = 'Left';			break;
				case Player.TOP		:  _owner = 'Top';			break;
				case Player.RIGHT	:  _owner = 'Right';		break;
				case Player.BOTTOM	:  _owner = 'Bottom';		break;
			}
			
			try 
			{
				_game['player' + _owner].addChild(this);
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 82, 'GameTimer' );
			}
			
			mcMask.x = restCalcX(current);
			
			TweenNano.to(this.mcMask, _second, { x: -181, ease:Linear.easeNone } );
			
			if (_owner == 'Bottom')
			{
				_timer = new Timer(1000, _second);
				_timer.addEventListener(TimerEvent.TIMER, onTickTimer)
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteTimer)
				_timer.start();	
			}
			
		}
		
		
		private function restCalcX(current_sec:int):Number
		{
			return current_sec * (181 / 15 ) *-1;
			
			
			if (xx < 0)
			{
				return -181;
			}
			else
			{
				return xx*-1;	
			}
			
		}
		
	}

}