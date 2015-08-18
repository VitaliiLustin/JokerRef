package com.jokerbros.joker.buttons {

import com.greensock.loading.data.VideoLoaderVars;
import com.jokerbros.joker.managers.LangManager;
import com.jokerbros.joker.managers.SoundManager;
import com.jokerbros.joker.utils.MainAmount;
import flash.display.MovieClip;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

public class Button {

	public static const STATE_ENABLE		:String = 'enable';
	public static const STATE_OVER			:String = 'over';
	public static const STATE_DOWN			:String = 'down';
	public static const STATE_DISABLE		:String = 'disable';
	public static const STATE_ACTIVE		:String = 'active';
	public static const STATE_LOADING	    :String = 'loading';
	
	
	public var name				:String;
	public var id				:int;
	public var buttonWidth		:Number;
	
	//protected var _amount		:MainAmount;
	protected var _button		:MovieClip;
	protected var _currentLabel	:String;
	protected var _tagName		:String = '';
	protected var _callback		:Function;
	protected var _state		:String;
	protected var _prevState	:String;
	protected var _enabled		:Boolean;
	protected var _clicked		:Boolean = true;
	protected var _isOver		:Boolean = false;
	protected var _isHide		:Boolean = false;
	
	public function Button(button:MovieClip, callback:Function = null, tagName:String = "", needAmount:Boolean = false,  enabled:Boolean = true, positionOnCenter:Boolean = false)
	{
		_button = button;  
		_callback = callback;
		_enabled = enabled;
		
		button.stop();
		_button.mouseChildren = false;
		
		if(button.name){
			name = button.name;
		}

		if(tagName != "")
		{
			_tagName = LangManager.get(tagName);
			setText(_tagName);
		}

		state = _enabled ? STATE_ENABLE : STATE_DISABLE;

		if(needAmount)
		{
			//initAmount();
		}

		_button.buttonMode = true;

		_button.addEventListener(MouseEvent.MOUSE_OVER , onOver);
		_button.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		_button.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
		_button.addEventListener(MouseEvent.MOUSE_UP, onUp);
		
		Joker.STAGE.addEventListener(FocusEvent.FOCUS_IN, onCatchFocus);
		Joker.STAGE.addEventListener(FocusEvent.FOCUS_OUT, onLooseFocus);
	}
	
	protected function onCatchFocus(e:FocusEvent):void 
	{
		//dispatchEvent(new Event(FOCUS_CATCH));
	}
	
	protected function onLooseFocus(e:FocusEvent):void 
	{
		//dispatchEvent(new Event(FOCUS_LOOSE));
		//onOut();
	}

	protected function onUp(e:MouseEvent):void 
	{
		if (_enabled && state != STATE_ACTIVE) {
			if (_isOver)
			{
				onOver();
			}
			else
			{
				onOut();
			}
			
			if (_callback != null)
			{
				_callback(e);
			}
			_clicked = true;
		}
	}

	protected function onClick(e:MouseEvent):void
	{
		if (_enabled && state != STATE_ACTIVE) {
			_prevState = _state;
			
			state = STATE_DOWN;
			
			_clicked = false;
			
			//SoundManager.playSound(SoundManager.BUTTON_PUSH);
		}
	}
	
	protected function onOut(e:MouseEvent = null):void
	{
		if (_enabled && state != STATE_ACTIVE) {
			state = STATE_ENABLE;
			_isOver = false;
		}
		
		if (!_clicked) 
		{
			_clicked = true;
		}
	}
	
	protected function onOver(e:MouseEvent = null):void
	{
		if (_enabled && state != STATE_ACTIVE) {
			state = STATE_OVER;
			_isOver = true;
		}
	}
	
	public function doClick(obj:Object=null):void
	{
		if (_callback != null)
		{
			_callback(obj);
		}
	}

	//private function initAmount():void
	//{
		//_amount  = new MainAmount(_button);
	//}

	private function switchFrame(frame:*):void
	{
		_button.gotoAndStop(frame);
		
		if (_tagName != '') {
			setText(_tagName);
		}
		//if(_amount){
			//_amount.updateText();
		//}
	}

	public function set state(value:String):void
	{
		if (_state == value)
		{
			return;
		}
		
		_enabled = value != STATE_DISABLE;
		_state = value;
		
		if(_button){
			if (hasLabelProperty(value))
			{
				_currentLabel = value;
				switchFrame(_currentLabel);
			}
			else if(!hasLabelProperty(value) && value == STATE_ENABLE)
			{
				trace("not found enable label in "+ _button.name);
				switchFrame(0);
			}
			else if (!hasLabelProperty(value) && value == STATE_DISABLE)
			{
				trace("not found disable label in "+ _button.name);
				var er:Error = new Error("BREAK");
				trace(er.getStackTrace());
				switchFrame(0);
			}
			
			if (_state == STATE_DISABLE) {
				if (_button['add_btn'])
				{
					_button['add_btn'].alpha = 0.5;;
				}
				else if (_button['name_tf'])
				{
					_button['name_tf'].alpha = 0.5;;
				}
				else if (_button['btn_name_tf'])
				{
					_button['btn_name_tf'].alpha = 0.5;;
				}
			}
		}
	}

	//public function set amount(amount:Number):void
	//{
		//_amount.update(amount);
	//}
	
	//public function get amount():Number
	//{
		//
		//return _amount.amount;
	//}

	private function hasLabelProperty(label:String):Boolean
	{
		for (var i:uint = 0; i < _button.currentLabels.length; i++)
		{
			if(label == _button.currentLabels[i].name)
			{
				return true;
			}
		}
		return false;
	}
	
	public function setText(text:String, txtName:String = ''):void
	{
		_tagName = text;
		if (txtName == '')
		{
			if (_button['add_btn'])
			{
				_button['add_btn'].text = text;
			}
			else if (_button['name_tf'])
			{
				_button['name_tf'].text = text;
			}
			else if (_button['btn_name_tf'])
			{
				_button['btn_name_tf'].text = text;
			}
		}
		else
		{
			if (_button[txtName])
			{
				_button[txtName].text = text;
			}
		}
	}

	public function destroy(removeMc:Boolean = true):void
	{
		if(_button)
		{
			_button.removeEventListener(MouseEvent.CLICK, onClick);
			_button.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			_button.removeEventListener(MouseEvent.MOUSE_OVER, onOver);

			if (removeMc && _button.parent)
			{
				_button.parent.removeChild(_button);
			}
		}
		
		Joker.STAGE.removeEventListener(FocusEvent.FOCUS_IN, onCatchFocus);
		Joker.STAGE.removeEventListener(FocusEvent.FOCUS_OUT, onLooseFocus);

		_button = null;

		_callback = null;
	}

	public function hide():void
	{
		_button.visible = false;
		_isHide = true;
	}

	public function show():void
	{
		_button.visible = true;
		_isHide = false;
	}
	
	public function mEnabled(enable:Boolean = true):void
	{
		_button.mouseEnabled = enable;
	}
	
	public function set disable(value:Boolean):void
	{
		if (!_enabled == value)
		{
			return;
		}
		
		if (value)
		{
			state = STATE_DISABLE;
		}
		else
		{
			state = STATE_ENABLE;
		}
		
		_enabled = !value;
	}
	
	public function get disable():Boolean
	{
		return !_enabled;
	}
	
	public function get isHide():Boolean
	{
		return _isHide;
	}

	public function get mc():MovieClip{
		return _button;
	}
	
	public function get state():String 
	{
		return _state;
	}
	
	//public function getAmount():MainAmount
	//{
		//return _amount;
	//}
}
}
