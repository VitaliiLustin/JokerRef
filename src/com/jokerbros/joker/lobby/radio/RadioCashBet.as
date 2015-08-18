package com.jokerbros.joker.lobby.radio 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author wdasd
	 */
	public class RadioCashBet extends MovieClip
	{
		public  var selectedBet:Number;
		
		private var _mcRadioCashBet:MovieClip;
		
		public function RadioCashBet(mc:MovieClip) 
		{
			_mcRadioCashBet = mc;
			_mcRadioCashBet.visible = true;
			
			initGraphics()
			
			for (var i:int = 1; i <= 6; i++) 
			{
				_mcRadioCashBet['radio' + i].gotoAndStop(2);
				_mcRadioCashBet['radio' + i].value.text = calcBet(i);
			}
			
			manageRadio(1);
			
		}
		
		public function destroy():void
		{
			for (var i:int = 1; i <= 6; i++) 
			{
				_mcRadioCashBet['radio' + i].removeEventListener(MouseEvent.CLICK, onClick)
			}
		}
		
		
		private function onClick(e:MouseEvent):void 
		{
			manageRadio(int(e.currentTarget.name.substr(5, 1).toString()))
		}
		
		private function manageRadio(checkedIndex:int):void
		{

			this.selectedBet = calcBet(checkedIndex);
			
			for (var i:int = 1; i <= 6; i++) 
			{
				if (checkedIndex == i)
				{
					
					_mcRadioCashBet['radio' + i].gotoAndStop(1);
					_mcRadioCashBet['radio' + i].removeEventListener(MouseEvent.CLICK, onClick)
					_mcRadioCashBet['radio' + i].buttonMode = false;
					_mcRadioCashBet['radio' + i].value.textColor = 0x009245;
				}
				else
				{
					_mcRadioCashBet['radio' + i].gotoAndStop(2);
					_mcRadioCashBet['radio' + i].addEventListener(MouseEvent.CLICK, onClick)
					_mcRadioCashBet['radio' + i].buttonMode = true;
					_mcRadioCashBet['radio' + i].value.textColor = 0xFFFFFF;
				}
				
			}		
		}
		
		private function calcBet(index:int):Number
		{
			
			switch (index) 
			{
				case 1: return 0.5;
				case 2: return 1;
				case 3: return 2;
				case 4: return 3;
				case 5: return 5;
				case 6: return 10;
					
			}
			
			
			return 0;
		}
		
		
		private function initGraphics():void
		{
			
			var bpgArial:String = new BGPArial().fontName;
			
			for (var i:int = 1; i <= 6; i++) 
			{
				_mcRadioCashBet['radio' + i].value.embedFonts = true;
				_mcRadioCashBet['radio' + i].value.antiAliasType = AntiAliasType.ADVANCED;
				_mcRadioCashBet['radio' + i].value.setTextFormat( new TextFormat(bpgArial) );
			}
		}
		
	}

}