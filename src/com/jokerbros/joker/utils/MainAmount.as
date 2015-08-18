package com.jokerbros.joker.utils 
{
	import com.greensock.TweenMax;
	import com.jokerbros.joker.game.GameProperties;
	import com.jokerbros.joker.managers.TextAlignManager;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class MainAmount 
	{
		private var _amountMC:MovieClip;
		private var _amount:Number = 0;
		public function get amount():Number { return _amount }
		
		public function MainAmount(mc:MovieClip) 
		{
			_amountMC = mc;
			
			_amountMC.money.currency.gotoAndStop(GameProperties.currency);
		}
		
		public function update(amount:Number, useTween:Boolean = false, callback:Function = null):void
		{
			if (amount < 0) {
				amount = 0;
			}
			
			visible = true;
			
			//amount = MathHelp.around(amount);
			
			//if (useTween) {
				//AnimationManager.updateBalance(Number(_amountMC.money.value_tf.text), amount, _amountMC.money.value_tf, AnimationManager.TIME_UPDATE_BALANCE, onUpdated, callback);
			//}else{
				_amountMC.money.value_tf.text = amount.toFixed(2);
			//}
			
			onUpdated();
			
			_amount = amount;
		}
		
		public function updateText():void
		{
			_amountMC.money.value_tf.text = _amount.toFixed(2);
			_amountMC.money.currency.gotoAndStop(GameProperties.currency);
			
			onUpdated();
		}
		
		public function updateColor(color:int):void
		{
			_amountMC.money.value_tf.textColor = color;
		}
		
		public function setTextAmount(txt:String):void
		{
			_amountMC.money.value_tf.text = txt;
		}
		
		private function onUpdated():void 
		{
			TextAlignManager.setTextCoordinates(_amountMC.money.value_tf, _amountMC.money.currency, 2);
		}
		
		public function destroy():void
		{
			if (_amountMC && _amountMC.parent) {
				_amountMC.parent.removeChild(_amountMC);
			}
			_amountMC = null;
		}
		
		public function set visible(value:Boolean):void
		{
			_amountMC.money.value_tf.visible = value;
			_amountMC.money.currency.visible = value;
		}
		
	}

}