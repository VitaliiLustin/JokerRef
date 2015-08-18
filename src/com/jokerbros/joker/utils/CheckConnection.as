package com.jokerbros.joker.utils 
{
	import Joker;
	import com.jokerbros.bura.events.WarningWindowEvent;
	import com.jokerbros.bura.windows.WarningWindow;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 13
	 */
	public class CheckConnection 
	{
		private const SECOND:int = 10;
		
		private var _status			:	Boolean = true;
		private var _alert			:	WarningWindow;
		private var _timer			:	Timer;
		
		//reference
		private var _refDocument	:	Joker;
		
		
		public function CheckConnection(refDocument:Joker) 
		{
			_refDocument = refDocument;
		}
		
		private function startTimer():void
		{
			_timer = new Timer(1000, SECOND);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteTimer)
			_timer.start();
		}
		
		private function stopTimer():void
		{
			if (_timer != null)
			{
				if (_timer.running)
					_timer.stop();
					
				if(_timer.hasEventListener(TimerEvent.TIMER_COMPLETE))	
					_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteTimer);
					
				_timer = null;
			}
		}
		
		private function onCompleteTimer(event:TimerEvent):void
		{
			_status = false;
			this.stopTimer();

			_alert = new WarningWindow('tqven gagiwydat internet kavshiri');
			_alert.addEventListener(WarningWindowEvent.CLOSE, onClose);
			
			_refDocument.addChild(_alert);
			
		}
		
		private function onClose(event:WarningWindowEvent):void
		{
			_alert.removeEventListener(WarningWindowEvent.CLOSE, onClose);
			_alert = null;
			
			//trace('URL Request'); // new URL Request
		}
		
		public function sfsResponse():void
		{
			if (_status == true)
			{
				this.stopTimer();
				this.startTimer();	
			}
		}
		
	}

}