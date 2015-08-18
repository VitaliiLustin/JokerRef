package com.jokerbros.joker.lobby.radio 
{
	import com.jokerbros.joker.events.RadioPointEvnt;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author wdasd
	 */
	public class RadioPoint extends MovieClip
	{
		public  var selectedPoint:int;
		
		private var _mcRadio3:MovieClip;
		
		public function RadioPoint(mc:MovieClip) 
		{
			_mcRadio3 = mc;
			
			initGraphics();
			
			for (var i:int = 1; i <= 3; i++) 
			{
				_mcRadio3['radio' + i].gotoAndStop(2);
				_mcRadio3['radio' + i].value.text = i;
				_mcRadio3['radio' + i].label.text = 'ქულამდე';
				
				if (i == 3)  _mcRadio3['radio' + i].label.text = 'ქულამდე\n(მარსი)';
				
				manageRadio(1);
			}
			
			
			
		}
		
		public function destroy():void
		{
			for (var i:int = 1; i <= 3; i++) 
			{
				_mcRadio3['radio' + i].removeEventListener(MouseEvent.CLICK, onClick)
			}
		}
		
		
		private function onClick(e:MouseEvent):void 
		{
			var value:int = int(e.currentTarget.name.substr(5, 1).toString());
			manageRadio(value)
			
			dispatchEvent(new RadioPointEvnt(RadioPointEvnt.CHANGE, value))
		}
		
		private function manageRadio(checkedIndex:int):void
		{

			this.selectedPoint = checkedIndex;
			
			for (var i:int = 1; i <= 3; i++) 
			{
				if (checkedIndex == i)
				{
					
					_mcRadio3['radio' + i].gotoAndStop(1);
					_mcRadio3['radio' + i].removeEventListener(MouseEvent.CLICK, onClick)
					_mcRadio3['radio' + i].buttonMode = false;
					
					_mcRadio3['radio' + i].value.textColor = 0x009245;
					_mcRadio3['radio' + i].label.textColor = 0x009245;
				}
				else
				{
					_mcRadio3['radio' + i].gotoAndStop(2);
					_mcRadio3['radio' + i].addEventListener(MouseEvent.CLICK, onClick)
					_mcRadio3['radio' + i].buttonMode = true;
					
					_mcRadio3['radio' + i].value.textColor = 0xFFFFFF;
					_mcRadio3['radio' + i].label.textColor = 0xFFFFFF;

				}
				
			}		
		}
		
		private function initGraphics():void
		{
			trace('initGraphics');
			
			var bpgArial:String = new BGPArial().fontName;
			
			for (var i:int = 1; i <= 3; i++) 
			{
				_mcRadio3['radio' + i].value.embedFonts = true;
				_mcRadio3['radio' + i].value.antiAliasType = AntiAliasType.ADVANCED;
				_mcRadio3['radio' + i].value.setTextFormat( new TextFormat(bpgArial) );
				
				_mcRadio3['radio' + i].label.embedFonts = true;
				_mcRadio3['radio' + i].label.antiAliasType = AntiAliasType.ADVANCED;
				_mcRadio3['radio' + i].label.setTextFormat( new TextFormat(bpgArial) );
			}
		}
		
	}

}