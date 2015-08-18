package com.jokerbros.joker.lobby.windows 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenNano;
	import com.jokerbros.joker.lobby.items.PrizeFoundItem;
	import com.jokerbros.joker.utils.EDScrollbar;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSArray;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class WindPrizeFound extends mcWindPrizeFound
	{
		private var _scrollbar:EDScrollbar;
		private var _item:Vector.<PrizeFoundItem>;
		private var _data:Array
		
		private var _endTour:* = null
		
		public function WindPrizeFound(data:Array, endTour:* = null) 
		{
			this.x = 245
			this.y = 54
			this.mcModal.alpha = 0.6;

			_data = data
			_endTour = endTour;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			stage.addEventListener(Event.RESIZE, resize);

			resize();
			
			_scrollbar  = new EDScrollbar(Joker.STAGE);
			_scrollbar.mcTrack = this.mcTrack;
			_scrollbar.initialize(this.updateContPos);
			
			this.btnClose.addEventListener(MouseEvent.CLICK, onClose)
			
			update()
		}
		
		private function onClose(e:MouseEvent):void 
		{
			dispatchEvent(new Event(Event.CLOSE))
		}
		
		private function updateContPos(percent:Number):void 
		{
			TweenNano.to(this.mcContainer, 0.5, { y:( 68 - Math.round( (this.mcContainer.height-318)  * percent) ), ease:Expo.easeOut } );
		}

		
		public function update():void 
		{
			
			clearItems();
			
			//this.mcProgress.visible = false;
			
			var rmY:int = 0;
			var i:int = 0
			
			
			if (_endTour)
			{
				var winplayers:SFSArray = _endTour;
				
				for (i = 0; i < winplayers.size(); i++) 
				{
					_item[i] = new PrizeFoundItem();
					_item[i].y = rmY
					_item[i].fill(i, winplayers.getSFSObject(i).getDouble('winAmount'), winplayers.getSFSObject(i).getUtfString('username'));
					rmY =	rmY + _item[i].height;
					
					this.mcContainer.addChild(_item[i])
				}
				
			}
			else
			{
				for (i= 0; i < _data.length; i++) 
				{
					_item[i] = new PrizeFoundItem();
					_item[i].y = rmY
					_item[i].fill(i, _data[i]);
					rmY =	rmY + _item[i].height;
					
					this.mcContainer.addChild(_item[i])
				}
			}
			

		}
		
		
		private function clearItems():void 
		{
			while (this.mcContainer.numChildren > 0) this.mcContainer.removeChildAt(0);
			_item = new Vector.<PrizeFoundItem>(); 
		}
		

		
		
		
		private function resize(e:Event = null):void 
		{
			this.mcModal.x = -stage.stageWidth / 2;
			this.mcModal.y = -stage.stageHeight / 2;
			
			this.mcModal.width = stage.stageWidth + 500;
			this.mcModal.height = stage.stageHeight + 250;
		}
		
		
		
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			if (stage) stage.removeEventListener(Event.RESIZE, this.resize);
			
			this.btnClose.removeEventListener(MouseEvent.CLICK, onClose)
			
			if (_scrollbar)
			{
				_scrollbar.clear();
				_scrollbar = null;
			}
		}
		
	}

}