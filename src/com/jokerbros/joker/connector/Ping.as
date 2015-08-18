package com.jokerbros.joker.connector 
{
	import flash.events.*;
    import flash.utils.*;
	
	/**
	 * ...
	 * @author wdasd
	 */
	public class Ping  extends EventDispatcher
	{
		
		
		private var _pingInterval:int = 7;
		private var _responseWaitInterval:int = 7;
		
		private var _threadPing:Timer;
		private var _whitePingResponse:Timer;
		
		public function Ping() 
		{
			this.initPing();
		}
		
		
		
		private function initPing():void
		{
			_threadPing = new Timer(_pingInterval * 1000);
            _threadPing.addEventListener(TimerEvent.TIMER, this.threadPingRunner);
		}
		
		private function threadPingRunner(e:TimerEvent):void 
		{
			ConnectorOld.send("PING");

			this.whitePingResponse();
		}
		
		
		
		private function whitePingResponse():void
		{
			_whitePingResponse = new Timer(_responseWaitInterval * 1000, 1);
			_whitePingResponse.addEventListener(TimerEvent.TIMER_COMPLETE, this.noResponsePing);

			_whitePingResponse.start();
		}
		
		private function destroyPingResponse():void
		{
			if (_whitePingResponse != null)
			{
				_whitePingResponse.removeEventListener(TimerEvent.TIMER_COMPLETE, this.noResponsePing);
				_whitePingResponse.stop();
				_whitePingResponse = null;
			}
		}
		
		
		private function noResponsePing(e:TimerEvent):void 
		{
			this.destroyPingResponse();	

			// show Low Connection Window
			ConnectorOld.windowRetryShow('Ping Problem');
			
		}
		
		

		public function pingResponse():void
		{
			this.destroyPingResponse();
			
			// hide Low Connection Window
			ConnectorOld.windowRetryHide();
		}
		
		
		public function pingStart():void
		{
			if (this.isPingRunning){ return; }

            this._threadPing.start();
		}
		
        public function pingStop() : void
        {
            if (!this.isPingRunning) { return; }

            this._threadPing.stop();
			
			this.destroyPingResponse();
        }
		
		public function get isPingRunning() : Boolean
        {
            return this._threadPing.running;
        }
		
	}

}