package com.jokerbros.joker.game.GameActionWindow 
{
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.buttons.Button;
	import com.jokerbros.joker.events.GameEvent;
	import com.jokerbros.joker.events.PanelEvent;
	import com.jokerbros.joker.user.ReportException;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author ValeriiT.Fedorov
	 */
	public class Order
	{
		public var container		:MovieClip;
		
		private var _numbersVect	:Vector.<Button>;
		private var _fillBar		:MovieClip;
		
		private var _maxOrder		:int;
		private var _access			:int;
		private var _fill			:int;
		
		public function Order(cont:MovieClip, data:Object) 
		{
			container 			= cont;
			
			_maxOrder 			= data.maxOrder;
			_access 			= data.access;
			_fill 				= data.fill;
			
			_fillBar 			= container.mcFillBar;
			_fillBar.visible	= false;
			
			_numbersVect	 	= new Vector.<Button>;
			
			init();
		}
		
		public function setActive(act:Boolean):void
		{
			container.visible = act;
		}
		
		private function init():void 
		{
			for (var i:int = 0; i < 10; i++) 
			{	
				_numbersVect[i] = new Button(container['value' + i], onOrder);
				_numbersVect[i].id = i;
			}	
		}
		
		public function updateData(data:Object):void 
		{
			_maxOrder = data.maxOrder;
			_access   = data.access;
			_fill 	  = data.fill;
			
			for (var i:int = 0; i < 10; i++) 
			{	
				if (i > _maxOrder) 
				{
					_numbersVect[i].mEnabled(false);
				}
			}
			
			if (_access != -1) 
			{
				_numbersVect[_access].mEnabled(false);
			}
			
			if (_fill > -1)
			{
				_fillBar.visible = Boolean(_fill)
				_fillBar.fillNumber.text = (_fill == 0)?'პასი':_fill.toString();
			}
		}
		
		
		
		private function onOrder(e:MouseEvent):void 
		{
			var str:String = e.currentTarget.name.substr(5,1);
			Facade.dispatcher.dispatch(GameEvent.SET_ORDER, int(str));
		}
	}

}