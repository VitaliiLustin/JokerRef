package com.jokerbros.joker.game 
{
	import com.greensock.TweenMax;
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.user.ReportException;
	import com.greensock.TweenNano;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 13
	 */
	public class Player 
	{
		
		public static const LEFT			:int = 1;
		public static const TOP				:int = 2;
		public static const RIGHT			:int = 3;
		public static const BOTTOM			:int = 4;
		
		private var _cardsLength:Number;
		
		public function set cardsLength(cl:int):void 
		{
			_cardsLength = cl;	
			_cardRot = Math.round(-_cardsLength / 2);	
		}
		
		private var order:TextField;
		private var currentOrder:TextField;
		public var userBox:MovieClip;
		
		private var _cardRot:Number;
		private var _startPoint		:MovieClip;
		private var _finishPoint	:MovieClip;
		private var _initPositionX	:Number;
		
		public var owner:int;

		public var cards:Vector.<Card>;
		public var _cardPosY:Number = 0;
		public var _cardPosX:Number = 0;
		
		public var username:String;
				
		public var lastCardParam:Object = { x:0, y:0, width:45, height:63 };
		private var _cardsPlace:MovieClip;
		public var param:Object = { 
									angle: 0,
									radius: 0,
									jokerActionX: 0,
									jokerActionY: 0,
									rot: 0
								 };
		 				 
		public function Player(pos:int,mcUserBox:MovieClip, cardsContainer:MovieClip) 
		{
			owner = pos;
			cards = new Vector.<Card>();
			userBox = mcUserBox;
			
			order = userBox.mcUserInfo.order;
			currentOrder = userBox.mcUserInfo.currentOrder;
			
			userBox.mouseChildren = false;
			userBox.mcUserInfo.mcColor.gotoAndStop(1);
			userBox.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_cardsPlace = cardsContainer;
			_initPositionX = userBox.mcUserInfo.x;
			_startPoint	 = userBox.startPoint;
			_finishPoint = userBox.finishPoint;
			
			switch (pos) 
			{
				case Player.LEFT	:param.angle = 5;
									param.radius = 150;
									param.jokerActionX = -201.75;
									param.jokerActionY = 114.85;
									
									lastCardParam.x = 32.25;
									lastCardParam.y = 75.6;
									_cardPosY = mcUserBox.y + mcUserBox.height / 2;
									_cardPosX = mcUserBox.x + mcUserBox.width;
									break;
									
				case Player.TOP	   :param.angle = 5;
									param.radius = 150;
									param.jokerActionX = -201.75;
									param.jokerActionY = -169.35;
										
									lastCardParam.x = 78.95;
									lastCardParam.y = 112.95;
									
									_cardPosY = mcUserBox.y + mcUserBox.height;
									_cardPosX = mcUserBox.x + mcUserBox.width / 2;
									break;
										
				case Player.RIGHT	:param.angle = 5;
									param.radius = 150;
									param.jokerActionX = 52.4;
									param.jokerActionY = -169.35;
									
									lastCardParam.x = 125.7;
									lastCardParam.y = 75.6;
									
									_cardPosY = mcUserBox.y + mcUserBox.height / 2;
									_cardPosX = mcUserBox.x;
									break;
									
				case Player.BOTTOM	:param.angle = 8;
									param.radius = 150;
									param.jokerActionX = 52.4;
									param.jokerActionY = 114.85;
									
									lastCardParam.x = 78.95;
									lastCardParam.y = 47.95;
									
									_cardPosY = mcUserBox.y;
									_cardPosX = mcUserBox.x + mcUserBox.width / 2;
									break;
			}
			
			
		}
		
		public function setCardPosition(ind:int):void
		{
			
			var xx:Number;
			var yy:Number;
			var rr:Number;
			
			switch (owner) 
			{
				case Player.LEFT:	rr = 90;  	xx = _cardPosX - 200;   yy = _cardPosY - 100;   break;
				case Player.TOP:	rr = 180;   xx = _cardPosX;   yy = _cardPosY;   break;
				case Player.RIGHT:	rr = 270;   xx = _cardPosX;   yy = _cardPosY;   break;
				case Player.BOTTOM:	rr = 0;   	xx = _cardPosX;   yy = _cardPosY;   break;
			}
			try 
			{
				cards[ind].rotation = param.angle * _cardRot + rr;
				cards[ind].x = param.radius * Math.sin( cards[ind].rotation * Math.PI/180 ) + xx;
				cards[ind].y = param.radius * ( 1 - Math.cos(cards[ind].rotation * Math.PI / 180 ) ) + yy;
				
				_cardRot ++ ;	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 168, 'Player' );
			}
			
		}
		
		public function updateCardPosition():void
		{		
			//return
			var len:int = 0;
			
			for (var j:int = 0; j < this.cards.length; j++) 
			{
				if (this.cards[j] != null && this.cards[j].state != Card.CARD_MOVED)
				{
					len++;
				}
			}
			
			var cardrot:Number = Math.round( - (len -1) / 2);

			var xx:Number;
			var yy:Number;
			var rr:Number;

			switch (this.owner) 
			{
				case Player.LEFT:	rr = 90;  	xx = _cardPosX - 200;   yy = _cardPosY - 100;   break;
				case Player.TOP:	rr = 180;   xx = _cardPosX;   yy = _cardPosY;   break;
				case Player.RIGHT:	rr = 270;   xx = _cardPosX;   yy = _cardPosY;   break;
				case Player.BOTTOM:	rr = 0;   	xx = _cardPosX;   yy = _cardPosY;   break;
			}
			
			try 
			{
				for (var i:int = 0; i < this.cards.length; i++) 
				{
					if (cards[i] != null && cards[i].state != Card.CARD_MOVED)
					{
						cards[i].rotation = this.param.angle * cardrot + rr;
						cards[i].x = param.radius * Math.sin( cards[i].rotation * Math.PI / 180 ) + xx;
						cards[i].y = param.radius * ( 1 - Math.cos(cards[i].rotation * Math.PI / 180 ) ) + yy;
						cardrot++;
					}
				}	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 217, 'Player' );
			}
		}
		
		
		public function setOrder(value:int):void
		{
			try 
			{
				if (value == -1)
				{
					order.text = '';	
				}
				else
				{
					order.text = (value == 0)?'-':value.toString();
				}
				
				order.textColor = 0x666666;	
			}
			catch (err:Error)
			{
				ReportException.send(err.message + 'value: ' + value, 183, 'GameManager' );
			}
		}
		
		public function setCurrentOrder(value:int):void
		{
				
				if (value == -1)
				{
					currentOrder.text = ''; 
				}
				else if (value == 0)
				{
					currentOrder.text = '-'; 
				}
				else
				{
					currentOrder.text = value.toString();	
				}

				var _order:int = (order.text == '-')?0:int(order.text);
				
				if (order.text == '')
				{
					_order = 0;
				}
				
				if (value < _order)
				{
					userBox.mcUserInfo.mcColor.gotoAndStop(1);
					order.textColor = 0x666666;
					currentOrder.textColor = 0x666666;
				}
				else  
				{
					if (value == _order)
					{
						userBox.mcUserInfo.mcColor.gotoAndStop(2);
					}
					else
					{
						userBox.mcUserInfo.mcColor.gotoAndStop(3);
					}
					order.textColor = 0xFFFFFF;
					currentOrder.textColor = 0xFFFFFF;
				}
		
		}
		
		private function onOver(ev:MouseEvent):void
		{
			userBox.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			userBox.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			TweenMax.to(userBox.yellowBg, 0.1, 	{ x:_finishPoint.x, onComplete:overComplete } );
			TweenMax.to(userBox.mcUserInfo, 0.1, { x: _startPoint.x - 35 } );
		}
		
		private function overComplete():void 
		{
			//userBox.bg.gotoAndStop('max');
		}
		
		private function onOut(ev:MouseEvent):void
		{
			userBox.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			userBox.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			
			TweenMax.to(userBox.yellowBg, 0.1, { x:_startPoint.x, onComplete:outComplete } );
			TweenMax.to(userBox.mcUserInfo, 0.1, { x:_initPositionX } );
		}
		
		private function outComplete():void 
		{
			//userBox.bg.gotoAndStop('min');
		}
		
	}

}