package com.jokerbros.joker.lobby.windows 
{
	import com.jokerbros.joker.events.LobbyEvent;
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.user.User;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.requests.*;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;

	
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class WindHelp extends mcWindHelp
	{
		
		public function WindHelp() 
		{
			this.x = 10;
			this.y = 170;
			this.mcModal.alpha = 0.6;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			stage.addEventListener(Event.RESIZE, this.resizeHelp);
			resizeHelp();
			
			this.btnClose.addEventListener(MouseEvent.CLICK, onClose);
		}
		
		private function onClose(e:MouseEvent):void 
		{
			Facade.dispatcher.dispatch(LobbyEvent.CLOSE_WIND_HELP);
		}
		
		
		
		private function resizeHelp(e:Event = null):void 
		{
			this.mcModal.x = -stage.stageWidth / 2;
			this.mcModal.y = -stage.stageHeight / 2;
			
			this.mcModal.width = stage.stageWidth + 500;
			this.mcModal.height = stage.stageHeight + 250;

		}
		
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			if (stage) stage.removeEventListener(Event.RESIZE, this.resizeHelp);
			
			this.btnClose.removeEventListener(MouseEvent.CLICK, onClose);

		}
		
	}

}