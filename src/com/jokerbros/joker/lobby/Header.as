package com.jokerbros.joker.lobby 
{
	import com.jokerbros.joker.connector.Connector;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class Header 
	{
		
		private static const GAME_JOKER			:	int = 1;
		private static const GAME_BACKGAMMON		:	int = 2;
		private static const GAME_BURA			:	int = 3;
		private static const GAME_DOMINO		:	int = 4;
		private static const GAME_SEKA			:	int = 5;
		private static const GAME_SLOTS			:	int = 6;
		
		private var _header:MovieClip;
		
		public function Header(game_id:int, header:MovieClip) 
		{ 
			_header = header;
			
			init()
			
			switch (game_id) 
			{
				case Header.GAME_JOKER			: 	jokerSetup(); 		break;
				case Header.GAME_BACKGAMMON		: 	backgammonSetup();  break;
				case Header.GAME_BURA			: 	buraSetup(); 		break;
				case Header.GAME_DOMINO			: 	dominoSetup(); 		break;
				case Header.GAME_SEKA			: 	sekaSetup(); 		break;
				case Header.GAME_SLOTS			: 	slotsSetup(); 		break;
			}
		}
		
		public static function factory(game_id:int, header:MovieClip):Header
		{
			return new Header(game_id, header);
		}
		
		public function destroy():void
		{
			_header.joker.removeEventListener(MouseEvent.CLICK, onClick)
			_header.joker.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.joker.removeEventListener(MouseEvent.MOUSE_OVER, onOver)

			_header.backgammon.removeEventListener(MouseEvent.CLICK, onClick)
			_header.backgammon.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.backgammon.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
	
			_header.bura.removeEventListener(MouseEvent.CLICK, onClick)
			_header.bura.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.bura.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
			_header.domino.removeEventListener(MouseEvent.CLICK, onClick)
			_header.domino.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.domino.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
			_header.seka.removeEventListener(MouseEvent.CLICK, onClick)
			_header.seka.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.seka.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
			_header.slots.removeEventListener(MouseEvent.CLICK, onClick)
			_header.slots.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.slots.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
		}
		
		private function init():void
		{
			
			_header.joker.buttonMode = true;
			_header.backgammon.buttonMode = true;
			_header.bura.buttonMode = true;
			_header.domino.buttonMode = true;
			_header.seka.buttonMode = true;
			_header.slots.buttonMode = true;
			
			_header.joker.gotoAndStop(1)
			_header.backgammon.gotoAndStop(1)
			_header.bura.gotoAndStop(1)
			_header.domino.gotoAndStop(1)
			_header.seka.gotoAndStop(1)
			_header.slots.gotoAndStop(1)
			
			_header.joker.addEventListener(MouseEvent.CLICK, onClick)
			_header.joker.addEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.joker.addEventListener(MouseEvent.MOUSE_OVER, onOver)

			_header.backgammon.addEventListener(MouseEvent.CLICK, onClick)
			_header.backgammon.addEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.backgammon.addEventListener(MouseEvent.MOUSE_OVER, onOver)
			
			_header.bura.addEventListener(MouseEvent.CLICK, onClick)
			_header.bura.addEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.bura.addEventListener(MouseEvent.MOUSE_OVER, onOver)
			
			_header.domino.addEventListener(MouseEvent.CLICK, onClick)
			_header.domino.addEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.domino.addEventListener(MouseEvent.MOUSE_OVER, onOver)
			
			_header.seka.addEventListener(MouseEvent.CLICK, onClick)
			_header.seka.addEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.seka.addEventListener(MouseEvent.MOUSE_OVER, onOver)
			
			_header.slots.addEventListener(MouseEvent.CLICK, onClick)
			_header.slots.addEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.slots.addEventListener(MouseEvent.MOUSE_OVER, onOver)
			
		}
		
		private function onOver(e:MouseEvent):void 
		{
			var mcCur:MovieClip = e.currentTarget as MovieClip;
				mcCur.gotoAndStop(2)
		}
		
		private function onOut(e:MouseEvent):void 
		{
			var mcCur:MovieClip = e.currentTarget as MovieClip;
				mcCur.gotoAndStop(1)
		}
		
		private function onClick(e:MouseEvent):void 
		{
			var mcCur:MovieClip = e.currentTarget as MovieClip;
			
			this.init();
				
			mcCur.buttonMode = false;
			mcCur.gotoAndStop(2);
			
			mcCur.removeEventListener(MouseEvent.CLICK, onClick)
			mcCur.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			mcCur.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
			//Connector.sfs.disconnect();
			
			navigateToURL(new URLRequest("http://jokerbros.com/"+e.currentTarget.name), "_self");
		}
		
		private function jokerSetup():void
		{
			_header.joker.buttonMode = false;
			_header.joker.gotoAndStop(2);
			
			_header.joker.removeEventListener(MouseEvent.CLICK, onClick)
			_header.joker.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.joker.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
		}
		
		private function backgammonSetup():void
		{
			_header.backgammon.buttonMode = false;
			_header.backgammon.gotoAndStop(3);
			
			_header.backgammon.removeEventListener(MouseEvent.CLICK, onClick)
			_header.backgammon.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.backgammon.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
		}
		
		private function buraSetup():void
		{
			_header.bura.buttonMode = false;
			_header.bura.gotoAndStop(3);
			
			_header.bura.removeEventListener(MouseEvent.CLICK, onClick)
			_header.bura.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.bura.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
		}
		
		private function dominoSetup():void
		{
			_header.domino.buttonMode = false;
			_header.domino.gotoAndStop(3);
			
			_header.domino.removeEventListener(MouseEvent.CLICK, onClick)
			_header.domino.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.domino.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
		}
		
				private function sekaSetup():void
		{
			_header.seka.buttonMode = false;
			_header.seka.gotoAndStop(2);
			
			_header.seka.removeEventListener(MouseEvent.CLICK, onClick)
			_header.seka.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.seka.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
		}

		private function slotsSetup():void
		{
			_header.slots.buttonMode = false;
			_header.slots.gotoAndStop(2);
			_header.slots.removeEventListener(MouseEvent.CLICK, onClick)
			_header.slots.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			_header.slots.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			
		}
		
	}

}