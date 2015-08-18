package com.jokerbros.joker.buttons 
{
	import com.jokerbros.managers.ColorManager;
	import com.jokerbros.managers.SoundManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class CheckBox extends Button
	{
		private var _isActivated:Boolean = false;
		
		private var _changeActive:Boolean = true;
		
		public function CheckBox(button:MovieClip, type:int, callback:Function = null, tagName:String = "", needAmount:Boolean = false,  enabled:Boolean = true, changeActive:Boolean = true) 
		{
			_changeActive = changeActive;
			
			super(button, type, callback, tagName, needAmount, enabled);
		}
		
		protected override function onUp(e:MouseEvent):void 
		{
			if (_enabled) {
				if (_isActivated) {
					state = STATE_ACTIVE + '_' + STATE_OVER;
				}else {
					textChange(ACTION_OUT_DIS);	
					state = STATE_ENABLE + '_' + STATE_OVER;
				}
			
				if (_isActivated) {
					textChange(ACTION_UP_EN);
				}else {
					textChange(ACTION_UP_DIS);	
				}
				
				if (_callback != null) {
					_callback(e);
				}
			}
			
			
			_clicked = true;
			
		}
		
		private function textChange(type:int):void
		{
			var data:Object = ColorManager.getBtnTextChanges(type, _buttonType)
			
			if (_button) 
			{
				if (_button.name_tf) {
					_button.name_tf.textColor = needChangeColor(data.color) ? data.color : _button.name_tf.textColor;	
					_button.name_tf.y += checkNeedPadding() ? data.padding : 0;	
				}
				if (_button.btn_name_tf) {
					_button.btn_name_tf.textColor = needChangeColor(data.color) ? data.color : _button.btn_name_tf.textColor;	
					_button.btn_name_tf.y += checkNeedPadding() ? data.padding : 0;	
				}
				if (_button.value_tf) {
					_button.value_tf.textColor = needChangeColor(data.color) ? data.color : _button.value_tf.textColor;	
					_button.value_tf.y += checkNeedPadding() ? data.padding : 0;
				}
				if (_button.currency_tf) {
					_button.currency_tf.textColor = needChangeColor(data.color) ? data.color : _button.currency_tf.textColor;	
					_button.currency_tf.y += checkNeedPadding() ? data.padding : 0;
				}
			}
		}
		
		protected override function onClick(e:MouseEvent):void
		{
			if (_enabled) {
				_prevState = _state;
				
				if(_isActivated){	
					state = STATE_ENABLE;
					
				}else {
					state = STATE_ACTIVE;
				}
				SoundManager.playSound(SoundManager.BUTTON_PUSH);
				
				if(_changeActive){
					_isActivated = !_isActivated;
				}
				_clicked = false;
				if (_isActivated) {
					textChange(ACTION_CLICK_EN);
				}else {
					textChange(ACTION_CLICK_DIS);	
				}
			}
		}
		
		protected override function onOver(e:MouseEvent = null):void
		{
			if (_enabled) {
				if (_isActivated) {
					
					textChange(ACTION_OVER_EN);
					state = STATE_ACTIVE + '_' + STATE_OVER;
				}else {
					textChange(ACTION_OVER_DIS);	
					state = STATE_ENABLE + '_' + STATE_OVER;
				}
				_isOver = true;
			}
		}
		
		protected override function onOut(e:MouseEvent = null):void
		{	
			if (_enabled) {
				if(_isActivated){
					state = STATE_ACTIVE;
				}else {
					state = STATE_ENABLE;
				}
				_isOver = false;
				
				if (!_clicked) 
				{
					if (_isActivated) {
						textChange(ACTION_OUT_EN);
					}else {
						textChange(ACTION_OUT_DIS);	
					}
					
					_clicked = true;
				}
			}
		}
		
		public function set active(value:Boolean):void
		{
			if (_isActivated == value) {
				return;
			}
			_isActivated = value;
			
			if (_enabled) {
				if(_isActivated){	
					state = STATE_ACTIVE;
				}else {
					state = STATE_ENABLE;
					textChange(ACTION_OUT_DIS);
				}
			}else {
				textChange(ACTION_OUT_DIS);	
			}
			
			//_isActivated = value;
		}
			
		public function get isActivated():Boolean 
		{
			return _isActivated;
		}
		
	}

}