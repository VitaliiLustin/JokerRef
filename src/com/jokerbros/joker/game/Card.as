package com.jokerbros.joker.game 
{
	import com.greensock.TweenNano;
	import com.jokerbros.joker.user.ReportException;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import flash.filters.DropShadowFilter; 
	
	/**
	 * 
	 * STATE = 0 - init card
	 * STATE = 1 - select
	 * STATE = 2 - move
	 * 
	 * OWNER = 0 - user
	 * OWNER = 1 - opponent
	 * 
	 * @author JokerBros
	 */
	
	 
	public class Card extends MovieClip 
	{
		// card sate
		public static const CARD_NOT_SELECTED:int = 0; //default value
		public static const CARD_SELECTED:int = 1;
		public static const CARD_MOVED:int = 2;
		public static const CARD_LAST_MOVED:int = 2;
		
		public static const CARD_OWNER_USER:int = 0;
		public static const CARD_OWNER_OPPONENT:int = 1;	

		public static const DEFAULT_WIDTH:int =  78;
		public static const DEFAULT_HEIGHT:int = 110;
		
		public static const DIST_WIDTH:int = 112;
		public static const DIST_HEIGHT:int = 155;
		
		public static const MOVED_WIDTH:int = 80;
		public static const MOVED_HEIGHT:int = 111;
		
		public var cardName:String;
		public var index:int;
		public var owner:int;
		
		public var card:MovieClip;
		
		public var status:int;
		private var _state:int = 0; // 0 darigebuli // 1 chamosuli
		
		
		public var type:String;
		public var value:int;
		
		//public var back:Sprite;
		public var shadow:Sprite;
		
		// gamoiyeneba localurad kartis shesadareblad START
		public var jokerAction:int;
		public var jokerActionValue:String;
		public var moveCount:int; 	
		public var ownerIndex:int;
		// gamoiyeneba localurad kartis shesadareblad END
		
		public function Card(cardName:String) 
		{
			this.cardName = cardName;
			
			try 
			{
				var ClassReference:Class = getDefinitionByName(cardName) as Class; 
				this.card = new ClassReference() as MovieClip;
				this.card.blendMode = BlendMode.LAYER;	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 96, 'Card' );
			}
			addChild(this.card);
			
			//this.back = new cardBack();
			//back.visible = false;
			//addChild(back);
			height = DEFAULT_HEIGHT;
			width = DEFAULT_WIDTH;

			var shadow:DropShadowFilter = new DropShadowFilter(); 
			
			shadow.distance = 1; 
			shadow.angle = 45; 
			
			if (cardName == 'cardBack')
			{
				shadow.alpha = 0.3;	
			}
			else
			{
				this.card.mcModal.alpha = 1;
				shadow.alpha = 0.7;
			}
			this.card.filters = [shadow];


			this.status = 0;
			this.state = 0;

			
			// set size
		
			
			if (this.cardName != "cardBack")
			{
				this.type = this.cardName.substr(0, 1).toString();
				this.value = int(this.cardName.substring(1, this.cardName.length )); 	
				
			}
			
			card.addEventListener(MouseEvent.MOUSE_OUT, onCardOut)	
			card.addEventListener(MouseEvent.MOUSE_OVER, onCardOver)

		}
		
		public function active(act:Boolean=true):void
		{
			try 
			{
				if (this.cardName != 'cardBack')
				{
					this.card.mcModal.alpha = 0;	
				}	
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 158, 'Card' );
			}
			
		}
		
		public function deActive():void
		{
			try 
			{
				if (this.cardName != 'cardBack')
				{
					this.card.mcModal.alpha = 1;	
				}
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 167, 'Card' );
			}
			

		}
		
		private function onCardOut(e:MouseEvent):void 
		{
			
			if (_state != CARD_MOVED && cardName != 'cardBack')
			{
				var card:MovieClip 	= e.currentTarget as MovieClip;
					card.y += 10;	
			}

		}
		
		private function onCardOver(e:MouseEvent):void 
		{
			
			if (_state != CARD_MOVED && cardName != 'cardBack')
			{
				var card:MovieClip 	= e.currentTarget as MovieClip;
					card.y -= 10;	
			}
		}
		
		
		public function get state():int
		{
			return this._state;
		}
		
		public function set state(value:int):void
		{
			
			if (value == CARD_MOVED)
			{	
					this.active();
			}
			
			this._state = value;
		}
		
		public function destroy():void
		{
			card.removeEventListener(MouseEvent.MOUSE_OUT, onCardOut)	
			card.removeEventListener(MouseEvent.MOUSE_OVER, onCardOver)
		}
		

		
	}
	
	
	/* getDefinitionByName */
	cardBack
	
	C6
	C7
	C8
	C9
	C10
	C11
	C12
	C13
	C14
	
	H6
	H7
	H8
	H9
	H10
	H11
	H12
	H13
	H14
	
	D6
	D7
	D8
	D9	
	D10
	D11
	D12
	D13
	D14
	
	S6
	S7
	S8
	S9		
	S10
	S11
	S12
	S13
	S14
	
	JR
	JB
	/* getDefinitionByName */
	


}