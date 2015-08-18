package com.jokerbros.joker.lobby.windows 
{
	import com.jokerbros.joker.connector.Connector;
	import com.jokerbros.joker.events.LobbyEvent;
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.user.User;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.requests.*;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import com.jokerbros.joker.utils.EDScrollbar;
	import com.jokerbros.joker.lobby.items.RatingItem;
		
	import com.greensock.TweenNano;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class WindRating extends mcWindRating
	{
		private const  TO_DAY:int   = 1;
		private const  WEEK:int 	= 2;
		private const  MONTH:int    = 3;
		private const  ALL:int      = 4;
		
		private var _item:Vector.<RatingItem>;
		private var _scrollbar:EDScrollbar;
		
		public function WindRating() 
		{
			this.x = 80
			this.y = 70
			this.mcModal.alpha = 0.6;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			stage.addEventListener(Event.RESIZE, this.resizeRating);

			resizeRating();
			
			_scrollbar  = new EDScrollbar(Joker.STAGE);
			_scrollbar.mcTrack = this.mcTrack;
			_scrollbar.initialize(this.updateContPos);
			
			this.btnClose.addEventListener(MouseEvent.CLICK, onClose)
			
			_item = new Vector.<RatingItem>();
			
			initBtn();
			
			initDefaultTab();
			
			//this.gratters.msg
			
			this.gratters.visible = false;
			
			
			this.gratters.msg.embedFonts = true;
			this.gratters.msg.antiAliasType = AntiAliasType.ADVANCED;
			this.gratters.msg.setTextFormat( new TextFormat(new BGPArial().fontName) );

		}
		
		

		private function initBtn():void
		{

			if (!this.btnDay.hasEventListener(MouseEvent.CLICK)) this.btnDay.addEventListener(MouseEvent.CLICK, onChageTab)
			if (!this.btnDay.hasEventListener(MouseEvent.MOUSE_OVER)) this.btnDay.addEventListener(MouseEvent.MOUSE_OVER, onOver)
			if (!this.btnDay.hasEventListener(MouseEvent.MOUSE_OUT)) this.btnDay.addEventListener(MouseEvent.MOUSE_OUT, onOut)
			this.btnDay.buttonMode = true;
			this.btnDay.gotoAndStop(1);
			
			if (!this.btnWeek.hasEventListener(MouseEvent.CLICK)) this.btnWeek.addEventListener(MouseEvent.CLICK, onChageTab)
			if (!this.btnWeek.hasEventListener(MouseEvent.MOUSE_OVER)) this.btnWeek.addEventListener(MouseEvent.MOUSE_OVER, onOver)
			if (!this.btnWeek.hasEventListener(MouseEvent.MOUSE_OUT)) this.btnWeek.addEventListener(MouseEvent.MOUSE_OUT, onOut)
			this.btnWeek.buttonMode = true;
			this.btnWeek.gotoAndStop(1);
			
			if (!this.btnMonth.hasEventListener(MouseEvent.CLICK)) this.btnMonth.addEventListener(MouseEvent.CLICK, onChageTab)
			if (!this.btnMonth.hasEventListener(MouseEvent.MOUSE_OVER)) this.btnMonth.addEventListener(MouseEvent.MOUSE_OVER, onOver)
			if (!this.btnMonth.hasEventListener(MouseEvent.MOUSE_OUT)) this.btnMonth.addEventListener(MouseEvent.MOUSE_OUT, onOut)
			this.btnMonth.buttonMode = true;
			this.btnMonth.gotoAndStop(1);
			
			if (!this.btnAll.hasEventListener(MouseEvent.CLICK)) this.btnAll.addEventListener(MouseEvent.CLICK, onChageTab)
			if (!this.btnAll.hasEventListener(MouseEvent.MOUSE_OVER)) this.btnAll.addEventListener(MouseEvent.MOUSE_OVER, onOver)
			if (!this.btnAll.hasEventListener(MouseEvent.MOUSE_OUT)) this.btnAll.addEventListener(MouseEvent.MOUSE_OUT, onOut)
			this.btnAll.buttonMode = true;
			this.btnAll.gotoAndStop(1);
			
		}
		
		private function initDefaultTab():void
		{
			// set default
			this.btnDay.removeEventListener(MouseEvent.CLICK, onChageTab)
			this.btnDay.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			this.btnDay.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			this.btnDay.gotoAndStop(2)
			this.btnDay.buttonMode = false;
			
			getRating(this.TO_DAY);
		}
		
		
		private function onOut(e:MouseEvent):void 
		{
			e.currentTarget.gotoAndStop(1)
		}
		
		private function onOver(e:MouseEvent):void 
		{
			e.currentTarget.gotoAndStop(2)
		}
		
		private function onChageTab(e:MouseEvent):void 
		{
			
			var name:String = e.currentTarget.name
			
			initBtn();
			
			this[name].removeEventListener(MouseEvent.CLICK, onChageTab)
			this[name].removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			this[name].removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			this[name].gotoAndStop(2)
			this[name].buttonMode = false;
			
			
			switch (name) 
			{
				case 'btnDay'	: getRating(this.TO_DAY); 
								  updateTXT('თქვენ დღევანდელი დღის\nსაუკეთესო 10-ში ხართ. გილოცავთ!'); break;
				case 'btnWeek'	: getRating(this.WEEK); 
								  updateTXT('თქვენ მიმდინარე კვირის\nსაუკეთესო 10-ში ხართ. გილოცავთ!'); break;
				case 'btnMonth' : getRating(this.MONTH);
								  updateTXT('თქვენ მიმდინარე თვის\nსაუკეთესო 10-ში ხართ. გილოცავთ!'); break;
				case 'btnAll'	: getRating(this.ALL); 
								  updateTXT('თქვენ საერთო რეიტინგის\nსაუკეთესო 10-ში ხართ. გილოცავთ!'); break;
			}
		
		}
		
		private function onClose(e:MouseEvent):void 
		{
			Facade.dispatcher.dispatch(LobbyEvent.CLOSE_WIND_RATING);
		}
		
		private function updateContPos(percent:Number):void 
		{
			TweenNano.to(this.mcContainer, 0.5, { y:( 100 - Math.round( (this.mcContainer.height-360)  * percent) ), ease:Expo.easeOut } );
		}
		
		public function update(params:ISFSObject = null):void 
		{
			
			this.mcProgress.visible = false;
			
			var rmY:int = 0;
			
			var items:ISFSArray = params.getSFSArray('items');
			

			for (var i:int = 0; i < items.size(); i++) 
			{
				_item[i] = new RatingItem();
				_item[i].y = rmY
				
				_item[i].pos.text 		=  (i == 9)? (i + 1).toString():'0' + (i + 1).toString()
				_item[i].rating.text 	=  items.getSFSObject(i).getDouble('rating').toString()	
				_item[i].username.text  =  items.getSFSObject(i).getUtfString('username')
				
				rmY =	rmY + _item[i].height;
				
				if (items.getSFSObject(i).getUtfString('username') == User.username) this.gratters.visible = true;
				
				this.mcContainer.addChild(_item[i])
			}
			
		}
		
		
		private function clearItems():void 
		{
			this.gratters.visible = false;
			while (this.mcContainer.numChildren > 0) this.mcContainer.removeChildAt(0);
			_item = new Vector.<RatingItem>(); 
		}
		
		private function getRating(interval:int):void 
		{
			clearItems();
			this.mcProgress.visible = true;
			var data:ISFSObject = new SFSObject(); data.putInt('interval',interval);
			Connector.send('gameRatingList',data);
		}
		
		
		private function updateTXT(str:String):void
		{
			this.gratters.msg.text = str;
		}
		
		
		private function resizeRating(e:Event = null):void 
		{
			this.mcModal.x = -stage.stageWidth / 2;
			this.mcModal.y = -stage.stageHeight / 2;
			
			this.mcModal.width = stage.stageWidth + 500;
			this.mcModal.height = stage.stageHeight + 250;
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			if (stage) stage.removeEventListener(Event.RESIZE, this.resizeRating);
			
			if (_scrollbar)
			{
				_scrollbar.clear();
				_scrollbar = null
			}
			
			this.btnDay.removeEventListener(MouseEvent.CLICK, onChageTab)
			this.btnDay.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			this.btnDay.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			
			this.btnWeek.removeEventListener(MouseEvent.CLICK, onChageTab)
			this.btnWeek.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			this.btnWeek.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			
			this.btnMonth.removeEventListener(MouseEvent.CLICK, onChageTab)
			this.btnMonth.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			this.btnMonth.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
			
			this.btnAll.removeEventListener(MouseEvent.CLICK, onChageTab)
			this.btnAll.removeEventListener(MouseEvent.MOUSE_OVER, onOver)
			this.btnAll.removeEventListener(MouseEvent.MOUSE_OUT, onOut)
		}
		
		
	}

}