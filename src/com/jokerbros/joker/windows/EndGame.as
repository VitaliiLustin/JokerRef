package com.jokerbros.joker.windows 
{
	import com.jokerbros.joker.events.EndGameEvent;
	import com.jokerbros.joker.utils.FontTools;
	import com.jokerbros.joker.utils.MainAmount;
	import com.smartfoxserver.v2.entities.data.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 13
	 */
	public class EndGame extends mcEndGame
	{
		private const WIN_AMOUNT_COLOR:uint = 0xF89734;
		private const GAME_OVER_AMOUNT_COLOR:uint = 0xF89734;
		private const RATING_GREEN_COLOR:uint = 0x49B754;
		private const RATING_RED_COLOR:uint = 0xF0000;
		
		private var _balance:MainAmount;
		private var _gameType:int;
		private var _params:ISFSObject;
		private var _isWin:Boolean;
		
		public function EndGame(params:ISFSObject, type:int, isWin:Boolean = true) 
		{
			mcModal.alpha = 0.3;
			mcModal.visible = false;
			_gameType = type;
			_params = params;
			
			_isWin = isWin;
			this.gotoAndStop(2);
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			stage.addEventListener(Event.RESIZE, this.resize);
			btnClose.addEventListener(MouseEvent.CLICK, onClose);
			for (var i:int = 0; i < _params.getSFSArray('result').size(); i++) 
			{
				this['mcPlace' + i].txtUsername.text = _params.getSFSArray('result').getSFSObject(i).getUtfString('username').toString()
				_balance = new MainAmount(this['mcPlace' + i]);
				_balance.update(_params.getSFSArray('result').getSFSObject(i).getDouble('winPoint'));				
				_balance.updateColor((_isWin) ? WIN_AMOUNT_COLOR : GAME_OVER_AMOUNT_COLOR );
				if (_gameType == 1)
				{
					 this['mcPlace' + i].txtRating.text = _params.getSFSArray('result').getSFSObject(i).getDouble('rating').toFixed(2)
					 this['mcPlace' + i].mcIcon.gotoAndStop(1);
					 //this.fb.visible = false;
				}
				else
				{
					this['mcPlace' + i].txtRating.text = '';
					this['mcPlace' + i].ratingVal.text = '';
					this['mcPlace' + i].mcIcon.visible = false;
					//this.fb.visible = false;
				}
			}
			resize()
		}
		
		private function onClose(e:MouseEvent):void 
		{
			dispatchEvent(new EndGameEvent(EndGameEvent.CLOSE));
		}
		
		private function resize(e:Event=null):void 
		{
			try 
			{ 
				mcModal.x = -stage.stageWidth / 2;
				mcModal.y = -stage.stageHeight / 2;
				mcModal.width = stage.stageWidth + 500;
				mcModal.height = stage.stageHeight + 250;
				
				x = stage.stageWidth - (this.width) * .5;
				y = stage.stageHeight - this.height;
			}
			catch (err:Error){}
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
	}
}