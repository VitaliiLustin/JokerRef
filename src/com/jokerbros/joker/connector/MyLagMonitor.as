package com.jokerbros.joker.connector
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class MyLagMonitor extends EventDispatcher
	{
		private const INTERVAL	:int = 4;
		private const QUEUE_SIZE:int = 10;

		private var _lastReqTime:int;
        private var _valueQueue:Array;
        private var _thread:Timer;
		private var _pingMaxTime:Timer;
		private var _pingMaxTimeCount:int = 0;
		
		public function MyLagMonitor()
		{
			_valueQueue = [];
			
			_thread = new Timer(this.INTERVAL * 1000);
            _thread.addEventListener(TimerEvent.TIMER, threadRunner);
			
			_pingMaxTime = new Timer(this.INTERVAL * 1000, 1);
			_pingMaxTime.addEventListener(TimerEvent.TIMER_COMPLETE, onPingMaxTime);
		}
		
		private function threadRunner(e:TimerEvent):void 
		{
			_lastReqTime = getTimer();
			_pingMaxTime.start();
			Connector.send(Connector.PING_HANDLER);
		}
		
		//response
		public function onPingPong():void
        {
			if (_pingMaxTimeCount > 0)
			{
				dispatchEvent(new PingPongEvent(PingPongEvent.TROUBLESHOOT));
			}
			
			_pingMaxTime.reset();
			_pingMaxTimeCount = 0;
			
			var pongInterval:int = getTimer() - this._lastReqTime;

            if (_valueQueue.length >= this.QUEUE_SIZE)
            {
                _valueQueue.shift();
            }
            _valueQueue.push(pongInterval);
			
			dispatchEvent(new PingPongEvent(PingPongEvent.PING, {lagValue:averagePingTime}));
        }
		
		private function onPingMaxTime(e:TimerEvent):void 
		{
			_pingMaxTime.reset();
			_pingMaxTimeCount++;
			dispatchEvent(new PingPongEvent(PingPongEvent.BAD_NETWORK));
		}
		
		public function get averagePingTime():int
        {
            var sum:int = 0;
			var time:int = 0;
            
			if (_valueQueue.length == 0)
            {
                return 0;
            }
            
            for each (time in _valueQueue)
            {
                sum = sum + time;
            }
            return sum / _valueQueue.length;
        }
		
		public function start():void
        {
            if (!_thread.running)
            {
                _thread.start();
            }
        }
		
		public function stop():void
        {
            if (!_thread.running)
            {
                _thread.stop();
            }
        }
		
		public function clear():void
		{
			_thread.reset() ;
            _thread.removeEventListener(TimerEvent.TIMER, threadRunner);
			_thread = null;
			
			_pingMaxTime.reset();
			_pingMaxTime.removeEventListener(TimerEvent.TIMER_COMPLETE, onPingMaxTime);
			_pingMaxTime = null;
			
			_pingMaxTimeCount = 0;
			_valueQueue = null;
		}
		
	}

}