package com.jokerbros.joker.lobby.windows 
{
	import com.jokerbros.joker.lobby.tournament.Rules;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class WindTourRules extends mcWindRules
	{
		
		public function WindTourRules() 
		{
			this.x = 270;
			this.y = 115;
			
			this.mcModal.alpha = 0.2;
			
			this.txtFish.text = Rules.fish.toString()
			this.txtDurat.text = int(Rules.duration/60).toString()
			this.txtBet.text = Rules.bet.toString()
			this.txtHand.text = Rules.hand.toString()
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
				
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			stage.addEventListener(Event.RESIZE, resize);
			
			this.btnClose.addEventListener(MouseEvent.CLICK, onClose)	

			resize();
		}
		
		private function resize(e:Event = null):void 
		{
			this.mcModal.x = -stage.stageWidth / 2;
			this.mcModal.y = -stage.stageHeight / 2;
			
			this.mcModal.width = stage.stageWidth + 500;
			this.mcModal.height = stage.stageHeight + 250;
		}
		
		private function onClose(e:MouseEvent):void 
		{
			this.btnClose.removeEventListener(MouseEvent.CLICK, onClose)	
			
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		
		private function destroy(e:Event = null):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			if (stage) stage.removeEventListener(Event.RESIZE, resize);
			
			this.btnClose.removeEventListener(MouseEvent.CLICK, onClose)	
		}
		
	}

}