package com.jokerbros.joker.lobby 
{
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.greensock.TweenNano;
	import com.jokerbros.joker.utils.TyniHelper;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class WhiteGame extends MovieClip
	{
		
		private var _mcWhiteFreeGam:MovieClip;
		
		private var _timer:Timer;
		
		private var _downCount:int;
		
		public function WhiteGame(mc:MovieClip) 
		{
			_mcWhiteFreeGam = mc;
			initGraphics();
			hide();
		}
		
		public function show(sec:int = 1800):void
		{
			_mcWhiteFreeGam.visible = true;
		
			_downCount = sec;
			
			//_mcWhiteFreeGam.downTimerTxt.text = sec2Time(_downCount);
			_mcWhiteFreeGam.downTimerTxt.text = TyniHelper.sec2MMSS(_downCount)
			
			_timer = new Timer(1000,sec);
			_timer.addEventListener(TimerEvent.TIMER, onDown)
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete)
			_timer.start();
			
			_mcWhiteFreeGam.mcFreeGameLoading.mcMask.x = -450+(450 / 1800) * sec;
			
			TweenNano.to(_mcWhiteFreeGam.mcFreeGameLoading.mcMask, sec , { x: -450, delay:0, ease:Linear.easeNone } );
			
		}
		
		
		public function hide():void
		{
			// destroy
			TweenNano.killTweensOf(_mcWhiteFreeGam.mcFreeGameLoading.mcMask);
			_mcWhiteFreeGam.mcFreeGameLoading.mcMask.x = 0;
			
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, onDown)
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onComplete)
				if (_timer.running) _timer.stop();
				
				_timer = null;
			}
			_mcWhiteFreeGam.downTimerTxt.text = '';
			_mcWhiteFreeGam.visible = false;
			
		}
		
		private function onDown(e:TimerEvent):void 
		{
			_downCount--;
			//_mcWhiteFreeGam.downTimerTxt.text = sec2Time(_downCount);
			_mcWhiteFreeGam.downTimerTxt.text = TyniHelper.sec2MMSS(_downCount);
			
		}
		
		private function onComplete(e:TimerEvent):void 
		{
			hide();
		}
		
		private function sec2Time(second:int):String
		{
			var min:String 	
			var sec:String
			
			if (second >= 60)
			{
				min = '0' + int(second / 60).toString();
			}
			else
			{
				min = '00';
			}
			
			if (second < 60)
			{
				sec = (second > 9)? second.toString(): '0' + second.toString();
			}
			else
			{
				var ss:int = second % 60;
				
				sec = (ss > 9 )? ss.toString(): '0' + ss.toString();
			}
			
			return min + ':' + sec;
		}
		
		private function initGraphics():void
		{
			var fontName:String = new BGPArial().fontName;

			_mcWhiteFreeGam.downTimerTxt.embedFonts = true;
			_mcWhiteFreeGam.downTimerTxt.antiAliasType = AntiAliasType.ADVANCED;
			_mcWhiteFreeGam.downTimerTxt.setTextFormat( new TextFormat(fontName) );
		}
		
		public function clear():void
		{
			//clear event listeners!
		}
	}

}