package com.jokerbros.joker.lobby.tournament 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenNano;
	import com.jokerbros.joker.utils.TyniHelper;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class CountDown extends Sprite
	{
		private var _mc:MovieClip;
		
		private var _timer:Timer;
		private var _downCount:int = 0;
		
		public function CountDown(mc:MovieClip, lbl:String = '') 
		{
			_mc = mc
			
			_mc.txtLbl.text = lbl
			
			_mc.mcLblEnd.visible = false
			
			_mc.visible = false
			
			initGraphics()
			
		}
		
		public function isCenter(param:Boolean):void
		{
			_mc.x = (param) ? 166 : 30;
		}
		
		public function run(sec:Number, duration:Number = (60*60*12)):void
		{
			destroy()
			
			_downCount = (sec < 0) ? 0 : sec
			_mc.mcTrack.mcMask.x = (sec >= duration) ? 0  : -int(321-((321*sec)/duration))

			_mc.txtTimer.text = TyniHelper.sec2Time(_downCount); 
			
			if (_downCount > 0)
			{
				_timer = new Timer(1000,_downCount);
				_timer.addEventListener(TimerEvent.TIMER, onDown)
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onCoundDownComplete)
				_timer.start(); 
				
				TweenNano.to(_mc.mcTrack.mcMask, sec , { x: -321, delay:0, ease:Linear.easeNone } );
			}
		}
		
		private function onDown(e:TimerEvent):void 
		{
			if (_downCount == 0)
			{	
				dispatchEvent(new Event(Event.COMPLETE));
				return
			}
			_downCount--;
			_mc.txtTimer.text = TyniHelper.sec2Time(_downCount); 
		}
		
		
		private function onCoundDownComplete(e:TimerEvent = null):void 
		{
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, onDown)
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCoundDownComplete)
				_timer = null
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function killTimer():void
		{
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, onDown)
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCoundDownComplete)
				_timer = null
			}
		}
		
		private function killAnim():void
		{
			if (_mc)
			{
				TweenNano.killTweensOf(_mc.mcTrack.mcMask);	
				_mc.mcTrack.mcMask.x = -321
			}
		}
		
		
		public function isEnd(param:Boolean = false):void
		{
			if (param)
			{
				_mc.mcLblEnd.visible = true
				_mc.txtLbl.visible = false
				_mc.mcIcon.visible = false
				_mc.txtTimer.visible = false
				
			}
			else
			{
				_mc.mcLblEnd.visible = false
				_mc.txtLbl.visible = true
				_mc.mcIcon.visible = true
				_mc.txtTimer.visible = true
			}
		}
		
		
		public function destroy():void
		{
			isEnd(false)
			killTimer()
			killAnim()
			
		}
		
		public function show(param:Boolean = true):void
		{
			if(_downCount <= 0) isEnd(true)
			_mc.visible = param;
		}
		
		private function initGraphics():void
		{
			//var arialName:String = new ArialRegular().fontName;
			var bpgArialName:String = new BGPArial().fontName;
			
			//_mc.txtTimer.embedFonts = true;
			//_mc.txtTimer.selectable = false;
			//_mc.txtTimer.antiAliasType = AntiAliasType.ADVANCED;
			//_mc.txtTimer.setTextFormat( new TextFormat(arialName) );
			
			_mc.txtLbl.embedFonts = true;
			_mc.txtLbl.selectable = false;
			_mc.txtLbl.antiAliasType = AntiAliasType.ADVANCED;
			_mc.txtLbl.setTextFormat( new TextFormat(bpgArialName) );
			
		}
		
		
		
	}

}