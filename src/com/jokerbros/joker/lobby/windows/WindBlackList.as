package com.jokerbros.joker.lobby.windows 
{
	import com.jokerbros.joker.connector.Connector;
	import com.jokerbros.joker.events.WindEnterPassEvent;
	import com.jokerbros.joker.events.WindGameHistoryEvent;
	import com.jokerbros.joker.user.User;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.requests.*;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	import com.jokerbros.joker.utils.EDScrollbar;
	import com.jokerbros.joker.lobby.items.BlackListItem;
		
	import com.greensock.TweenNano;
	import com.greensock.easing.*;
	
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class WindBlackList extends mcWindBlackList
	{
		private var _scrollbar:EDScrollbar;
		private var _item:Vector.<BlackListItem>;
		
		public function WindBlackList() 
		{
			this.x = 80
			this.y = 70
			this.mcModal.alpha = 0.6;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			stage.addEventListener(Event.RESIZE, this.resizeGameHistory);

			resizeGameHistory();
			
			_scrollbar  = new EDScrollbar(Joker.STAGE);
			_scrollbar.mcTrack = this.mcTrack;
			_scrollbar.initialize(this.updateContPos);
			
			
			this.btnClose.addEventListener(MouseEvent.CLICK, onClose)
			
			Connector.send('blackList');
			
		}
		
		private function onClose(e:MouseEvent):void 
		{
			dispatchEvent(new WindGameHistoryEvent(WindGameHistoryEvent.CLOSE))
		}
		
		private function updateContPos(percent:Number):void 
		{
			
			TweenNano.to(this.mcContainer, 0.5, { y:( 100 - Math.round( (this.mcContainer.height-360)  * percent) ), ease:Expo.easeOut } );
		}

		
		public function update(params:ISFSObject):void 
		{
			clearItems();
			this.mcProgress.visible = false;
			
			
			var rmY:int = 0;
			
			var history:ISFSArray = params.getSFSArray('items');
			
			for (var i:int = 0; i < history.size(); i++) 
			{
				_item[i] = new BlackListItem();
				_item[i].y = rmY
				_item[i].fill(history, i);
				rmY =	rmY + _item[i].height;
				
				this.mcContainer.addChild(_item[i])
			}
		}
		
		private function clearItems():void 
		{
			
			while (this.mcContainer.numChildren > 0) this.mcContainer.removeChildAt(0);

			_item = new Vector.<BlackListItem>(); 
		}

		
		
		
		private function resizeGameHistory(e:Event = null):void 
		{
			this.mcModal.x = -stage.stageWidth / 2;
			this.mcModal.y = -stage.stageHeight / 2;
			
			this.mcModal.width = stage.stageWidth + 500;
			this.mcModal.height = stage.stageHeight + 250;
		}
		
		
		
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			if (stage) stage.removeEventListener(Event.RESIZE, this.resizeGameHistory);
			
			this.btnClose.removeEventListener(MouseEvent.CLICK, onClose);
			
			if (_scrollbar)
			{
				_scrollbar.clear();
				_scrollbar = null
			}

		}
		
	}

}