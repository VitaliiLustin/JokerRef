package com.jokerbros.joker.game 
{
	/**
	 * ...
	 * @author 13
	 */
	public class WinPlayer 
	{

		
		public function WinPlayer() 
		{
			
		}
		
		// return direction
		public static function factory(movedCards:Vector.<Card>, trum:String):int
		{
			var obj:WinPlayer = new WinPlayer();
	
			return obj.calculate(movedCards,trum);	
		}
		
		//
		public function calculate(movedCards:Vector.<Card>, trum:String):int
		{
		   var winCard:Card = getCardByMoveNumber(1, movedCards);
			
	   
		   for (var i:int = 2; i <= 4; i++) 
		   {
				winCard = this.winCard( getCardByMoveNumber(i, movedCards), winCard, trum);
		   }
		   
		   
		   return winCard.ownerIndex;
		}
		
		private function getCardByMoveNumber(number:int, cards:Vector.<Card>):Card
		{
			var card:Card;
			
			for (var i:int = 1; i <= 4; i++) 
			{
				if (number == cards[i].moveCount) 
				{
					card =  cards[i];
					break;
				}
			}
			
			return card;
		}
		
		//
		private function winCard(card1:Card, card2:Card, trump:String):Card 
		{
		   
		   /**
			* tu mowinaagmdeges uchiravs jokeri
			* 
			*  action 1 - mojokra, 2 - nije
			*/
		   
			if (card1.type == "J") {

				if (card1.jokerAction == 1) {
					return card1;
				}

				if (card1.jokerAction == 2) {
					return card2;
				}
			}

			if (card2.type == "J") {

				if (card2.jokerAction == 1) {
					return card2;
				}

				if (card2.jokerAction == 2) {
					return card1;
				}
			}

			/**
			* 
			* TU playeri wamovida jokerit
			* 
			* action 3 - magali, 4 - waigos
			* 
			* */

			if (card2.type == "J") {

				if (card2.jokerAction == 3) {

					if (card2.jokerActionValue == trump) {
						return card2; 
					} 
					if (card1.type == trump) {
						return card1;
					}
				}

				if (card2.jokerAction == 4) {

					if (card2.jokerActionValue == card1.type) {
						return card1;
					}
					if (card1.type == trump) {
						return card1;
					}
				}   
			}

			/** tu cvetebi udris ertmanets */
			if (card1.type == card2.type) {

				if (card2.value < card1.value) {
					return card1;
				}

				return card2;    
			}

			/** tu mowinaamdegis cveti koziria */
			if (card1.type == trump) {

				if (card2.jokerAction == 1) {
					return card2;
				}

				return card1;
			}

			return card2;
		}
		
	}

}