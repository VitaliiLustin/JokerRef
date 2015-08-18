package com.jokerbros.joker.windows 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author wdasd
	 */
	public class WindowRetryConnection extends mcWindowDisconnect
	{
		
		public function WindowRetryConnection() 
		{
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			this.txt.text = 'თქვენ გაგიწყდათ ინტერნეტ კავშირი, მიმდინარეობს აღდგენა...';
			/*
			this.txt.embedFonts = true;
			this.txt.selectable = false;
			this.txt.antiAliasType = AntiAliasType.ADVANCED;
			this.txt.setTextFormat( new TextFormat(new BPGIngiriAreal().fontName, 13) );
			*/
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}
		
		public function updateText(text:String):void
		{
			//this.txt.text = text;
		}
		
		private function destroy(e:Event):void 
		{
			
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
			
			this.BG.alpha = 0.7;
			this.BG.width =  Joker.STAGE.stageWidth;
			this.BG.height =  Joker.STAGE.stageHeight;
			
			this.BG.x = -Joker.STAGE.stageWidth / 2
			this.BG.y = -Joker.STAGE.stageHeight / 2			
		}
		
	}

}