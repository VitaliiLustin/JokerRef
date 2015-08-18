package com.jokerbros.joker.lobby.windows 
{
	import com.jokerbros.joker.events.LobbyEvent;
	import com.jokerbros.joker.Facade.Facade;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author wdasd
	 */
	public class Alert extends mcAlert
	{
		
		public function Alert() 
		{
			this.x = 270;
			this.y = 180;
			
			this.mcModal.alpha = 0.6;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			stage.addEventListener(Event.RESIZE, resizeAlert);
			
			this.btnClose.addEventListener(MouseEvent.CLICK, onClose)	
			this.btnOK.addEventListener(MouseEvent.CLICK, onClose)
			
			resizeAlert();
		}
		
		private function resizeAlert(e:Event = null):void 
		{
			this.mcModal.x = -stage.stageWidth / 2;
			this.mcModal.y = -stage.stageHeight / 2;
			
			this.mcModal.width = stage.stageWidth + 500;
			this.mcModal.height = stage.stageHeight + 250;
		}
		
		private function onClose(e:MouseEvent):void 
		{
			this.btnClose.removeEventListener(MouseEvent.CLICK, onClose)	
			this.btnOK.removeEventListener(MouseEvent.CLICK, onClose)
			
			Facade.dispatcher.dispatch(LobbyEvent.HIDE_ALERT);
		}
		
		public function setMessage(msg:String):void
		{
			this.message.text = msg;
		}
		
		private function destroy(e:Event = null):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			if (stage) stage.removeEventListener(Event.RESIZE, resizeAlert);
			
			this.btnClose.removeEventListener(MouseEvent.CLICK, onClose)	
			this.btnOK.removeEventListener(MouseEvent.CLICK, onClose)
			
		}

	}

}