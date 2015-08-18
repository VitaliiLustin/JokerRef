package com.jokerbros.joker.game 
{
	import com.jokerbros.joker.events.GameEvent;
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.user.User;
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class Options //extends MovieClip
	{
		private var _options:MovieClip
		
		public function Options($options:MovieClip) 
		{
			_options = $options;
			
			_options.btnMute.stop();
			_options.btnMute.buttonMode = true;
			_options.btnMute.addEventListener(MouseEvent.CLICK, onMute)
			_options.btnFullScreen.addEventListener(MouseEvent.CLICK, onFullScreen)
			_options.btnReport.addEventListener(MouseEvent.CLICK, onReport)
			
		}
		
		private function onReport(e:MouseEvent):void 
		{
			Facade.dispatcher.dispatch(GameEvent.OPEN_OPTIONS);
		}
		
		private function onFullScreen(e:MouseEvent):void 
		{ 
			try 
			{
				if (Joker.STAGE.displayState == StageDisplayState.NORMAL) Joker.STAGE.displayState = StageDisplayState.FULL_SCREEN;	
				else Joker.STAGE.displayState = StageDisplayState.NORMAL;	
			}
			catch (err:Error) {}
		}
		
		private function onMute(e:MouseEvent):void 
		{
			if (User.soundEnabled == false) { _options.btnMute.gotoAndStop(2); User.soundEnabled = true; User.soundOn(false); }
			else { _options.btnMute.gotoAndStop(1); User.soundEnabled = false; User.soundOn(true); }
		}
		
		public function clear():void
		{
			_options.btnMute.removeEventListener(MouseEvent.CLICK, onMute)
			_options.btnFullScreen.removeEventListener(MouseEvent.CLICK, onFullScreen)
			_options.btnReport.removeEventListener(MouseEvent.CLICK, onReport)
		}
		
	}

}