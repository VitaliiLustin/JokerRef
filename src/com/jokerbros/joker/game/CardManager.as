package com.jokerbros.joker.game {
	import com.jokerbros.joker.Facade.Facade;
	import flash.display.MovieClip;
	import com.greensock.TweenMax;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.DropShadowFilterPlugin;
	import com.greensock.easing.Circ;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.filters.DropShadowFilter;
	import com.jokerbros.joker.game.Player;
	import Joker;
	/**
	 * ...
	 * @author David
	 */
	
	 
	public class CardManager 
	{
		private var crd:Object;
		
		public function CardManager() 
		{
			TweenPlugin.activate([DropShadowFilterPlugin]);
			//Main.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		

		public function animateMoveCard(card:Object,ind:int):void
		{
			var moveCardParams:Object;
			var cardShadowfilter:DropShadowFilter = new DropShadowFilter();
			
			if (ind == Player.BOTTOM)
			{
				moveCardParams = { x:600.8, y:492.7, z:70, rotation:0, rotationX: -38, ease:Circ.easeOut};
				//flipCardParams = {};
			}		
			else if (ind ==Player.RIGHT)
			{
				card.x = 702.4;
				card.y = 435.1;
				card.z = 119.6;
				card.rotation = 0;
				card.rotationX = -38;
				
				cardShadowfilter.distance = 100;
				cardShadowfilter.strength = 0.1;
				cardShadowfilter.blurX = 25;
				cardShadowfilter.blurY = 25;
				cardShadowfilter.angle = 180;
				cardShadowfilter.color = 0x000000;
				
				card.filters = [cardShadowfilter];
				
				moveCardParams = { x:702.4, y:435.1, ease:Circ.easeOut,dropShadowFilter:{distance:0,strength:0.8,blurX:0,blurY:0},onComplete:removeShadow,onCompleteParams:[card]};
				//flipCardParams = { rotationY: -30, alpha:1 ,onUpdate:renderCardMoveHorizontal, onUpdateParams:[card,-95],delay:0.25};
			}
			else if (ind ==Player.TOP)
			{ 	crd = card;
				card.x = 598.8;
				card.y = 383.6;
				card.z = 180;
				card.rotation = 0;
				card.rotationX = -38;
				
				cardShadowfilter.distance = 100;
				cardShadowfilter.strength = 0.1;
				cardShadowfilter.blurX = 25;
				cardShadowfilter.blurY = 25;
				cardShadowfilter.angle = 90;
				cardShadowfilter.color = 0x000000;
				
				card.filters = [cardShadowfilter];
				
				moveCardParams = {x:598.8,y:383.6, ease:Circ.easeOut,dropShadowFilter:{distance:0,strength:0.8,blurX:0,blurY:0},onComplete:removeShadow,onCompleteParams:[card]};
				//flipCardParams = {rotationX:-30,onUpdate:renderCardMoveVertical, onUpdateParams:[card,-82],delay:0.2};
			}
			else if (ind == Player.LEFT)
			{   
				card.x = 498;
				card.y = 439;
				card.z = 119.7;
				card.rotation = 0;
				card.rotationX = -38;
				
				cardShadowfilter.distance = 100;
				cardShadowfilter.strength = 0.1;
				cardShadowfilter.blurX = 25;
				cardShadowfilter.blurY = 25;
				cardShadowfilter.angle = 0;
				cardShadowfilter.color = 0x000000;
				
				card.filters = [cardShadowfilter];
				
				moveCardParams = { x:498, y:439, ease:Circ.easeOut,dropShadowFilter:{distance:0,strength:0.8,blurX:0,blurY:0},onComplete:removeShadow,onCompleteParams:[card]};
				//flipCardParams = { rotationY:30, alpha:1, onUpdate:renderCardMoveHorizontal, onUpdateParams:[card,-95],delay:0.25};
			}   
			
			TweenMax.to(card , 0.3, moveCardParams);
			//TweenMax.to(card , 0.2, flipCardParams);
		}
		
		public function removeShadow(card:Object):void
		{
			//trace("remove shadod");
			card.filters = [];
		}
		
		public function clearMovedCard(card:Object,pos:int):void
		{
			
			var clearCardParams:Object;
			var paramXY:Object = Facade.gameManager.calcAnimXY(pos);
			switch ( pos ) 
			{
				case Player.LEFT: 	clearCardParams = {	x:paramXY.x, y:paramXY.y, z:119.7,  rotation:0, rotationX:-38,   rotationY:0, rotationZ:0, delay:0.75 }; break;
				case Player.TOP: 	clearCardParams = { x:paramXY.x, y:paramXY.y, z:180,	rotation:0, rotationX:-38,   rotationY:0, rotationZ:0, delay:0.75 };	break;
				case Player.RIGHT: 	clearCardParams = { x:paramXY.x, y:paramXY.y, z:119.6,	rotation:0, rotationX:-38,   rotationY:0, rotationZ:0, delay:0.75 };	break;
				case Player.BOTTOM: clearCardParams = { x:paramXY.x, y:paramXY.y, z:70,	 	rotation:0, rotationX:-38,   rotationY:0, rotationZ:0, delay:0.75 };	break;
			}
			
			TweenMax.to(card, 22, clearCardParams);
			trace();
		}
		
		private function renderCardMoveHorizontal(card:Object,angle:int):void
		{
			//trace("rendering..." + card.rotationY);
			
			card.back.visible = (card.rotationY < angle)?true:false;
		}
		
		private function renderCardMoveVertical(card:Object,angle:int):void
		{
			card.back.visible = (card.rotationX < angle)?true:false;
		}
		
		private function onKeyDown(ev:KeyboardEvent):void
		{
			trace(crd.rotationX);
		}
		
	}

}