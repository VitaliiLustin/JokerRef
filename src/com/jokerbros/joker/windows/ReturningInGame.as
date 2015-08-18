package com.jokerbros.joker.windows 
{
	import com.jokerbros.joker.events.ReturningWindowEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 13
	 */
	public class ReturningInGame extends mcReturningInGame 
	{
		
		public function ReturningInGame() 
		{
			this.x = - this.width / 2
			this.y = - this.height / 2
			
			this.yes.addEventListener(MouseEvent.CLICK, onYes)
			this.no.addEventListener(MouseEvent.CLICK, onNo)
			
		}
		
		private function onYes(e:MouseEvent):void 
		{
			this.yes.removeEventListener(MouseEvent.CLICK, onYes)
			this.no.removeEventListener(MouseEvent.CLICK, onNo)
			
			dispatchEvent(new ReturningWindowEvent(ReturningWindowEvent.RESPONSE, 1))
		}
		
		private function onNo(e:MouseEvent):void 
		{
			this.yes.removeEventListener(MouseEvent.CLICK, onYes)
			this.no.removeEventListener(MouseEvent.CLICK, onNo)
			
			dispatchEvent(new ReturningWindowEvent(ReturningWindowEvent.RESPONSE, 2))
		}
		
	}

}