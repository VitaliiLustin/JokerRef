package com.jokerbros.joker.windows 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author wdasd
	 */
	public class Reconnect extends mcReconnect
	{
		
		public function Reconnect() 
		{
			
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function destroy(e:Event):void 
		{
			
			trace('destroy');
			
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			if (stage) stage.addEventListener(Event.RESIZE, resizeReconnect);
			
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(Event.RESIZE, this.resizeReconnect);
			
			resizeReconnect();
		}
		
		private function resizeReconnect(e:Event=null):void 
		{
			this.x = Joker.STAGE.stageWidth / 2
			this.y = Joker.STAGE.stageHeight / 2
			
			this.BG.alpha = 0.75;
			this.BG.width =  Joker.STAGE.stageWidth;
			this.BG.height =  Joker.STAGE.stageHeight;
			
			this.BG.x = -Joker.STAGE.stageWidth / 2
			this.BG.y = -Joker.STAGE.stageHeight / 2			
		}
		
	}

}