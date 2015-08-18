package com.jokerbros.joker.lobby.radio 
{
	import flash.display.MovieClip;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class RadioFunBet extends MovieClip
	{
		
		public  var selectedBet:Number;
		
		private var _mcRadioFunBet:MovieClip;
		
		public function RadioFunBet(mc:MovieClip) 
		{
			_mcRadioFunBet	= mc
			_mcRadioFunBet.visible = true;
			
			initGraphics();
			
			for (var i:int = 1; i <= 3; i++) 
			{
				_mcRadioFunBet['radio' + i].gotoAndStop(2);
				_mcRadioFunBet['radio' + i].value.text = calcBet(i);
			}
			
			manageRadio(1);
			
		}
		
		public function destroy():void
		{
			
		}
		
		
		private function manageRadio(checkedIndex:int):void
		{

			this.selectedBet = calcBet(checkedIndex);
			
			for (var i:int = 1; i <= 3; i++) 
			{
				if (checkedIndex == i)
				{
					_mcRadioFunBet['radio' + i].gotoAndStop(1);
					_mcRadioFunBet['radio' + i].buttonMode = false;
					_mcRadioFunBet['radio' + i].value.textColor = 0x666666;
				}
				else
				{
					_mcRadioFunBet['radio' + i].gotoAndStop(2);
					_mcRadioFunBet['radio' + i].buttonMode = true;
					_mcRadioFunBet['radio' + i].value.textColor = 0x666666;
				}
				
			}		
		}
		
				private function calcBet(index:int):Number
		{
			
			switch (index) 
			{
				case 1: return 20;
				case 2: return 30;
				case 3: return 40;
			}
			
			
			return 0;
		}
		
		private function initGraphics():void
		{
			var bpgArial:String = new BGPArial().fontName;
			
			for (var i:int = 1; i <= 3; i++) 
			{
				_mcRadioFunBet['radio' + i].value.embedFonts = true;
				_mcRadioFunBet['radio' + i].value.antiAliasType = AntiAliasType.ADVANCED;
				_mcRadioFunBet['radio' + i].value.setTextFormat( new TextFormat(bpgArial) );
				
				
			}
		}
		
		public function changeFrame(frame:int):void
		{
			manageRadio(frame)
		}
		
	}

}