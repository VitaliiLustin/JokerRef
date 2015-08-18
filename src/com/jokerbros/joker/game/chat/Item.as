package com.jokerbros.joker.game.chat 
{
	import com.jokerbros.joker.user.User;
	import com.jokerbros.TxtHelper;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author ...
	 */
	internal final class Item //extends MovieClip
	{
		private var _item:MovieClip;
		
		public function Item(str:String, isMyMsg:Boolean = false) 
		{
			_item = (isMyMsg) ? new mcWhiteMsg() : new mcYallowMsg();
			
			TxtHelper.setTxtParams(_item.txt, TxtHelper.bpgarial);
			
			_item.txt.autoSize = TextFieldAutoSize.LEFT;


			_item.txt.multiline = true;
            _item.txt.wordWrap = true;
			
			 _item.txt.width = 206;
			
			_item.txt.text = str;
			
			_item.bg.height = _item.txt.textHeight + 16
			
			_item.txt.addEventListener(Event.SCROLL, onScroll);
			
			//_item.mcAvatar.stop()
			
			//_item.mcAvatar.mcImg.addChild( (isMyMsg) ? User.getMyAvatar() : User.getOppAvatar() )
			//_item.mcAvatar.mcImg.addChild( (new mcDefAvt() )
			
			//addChild(_item);
		}
		
		private function onScroll(e:Event):void 
		{
			_item.txt.scrollV = 0;
		}
		
		public function destroy():void
		{
			if (_item) {
				_item.txt.removeEventListener(Event.SCROLL, onScroll);
				if(_item.parent){
					_item.parent.removeChild(_item);
				}
			}
			_item = null;
		}
		
		public function get mc():MovieClip 
		{
			return _item;
		}
		
	}

}