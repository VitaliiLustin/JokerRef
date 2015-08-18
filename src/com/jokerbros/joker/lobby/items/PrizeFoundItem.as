package com.jokerbros.joker.lobby.items 
{
	/**
	 * ...
	 * @author JokerBros
	 */
	
	import flash.text.AntiAliasType;
	import flash.text.TextFormat; 
	 
	public class PrizeFoundItem extends mcPrizeFoundItem
	{
		
		public function PrizeFoundItem() 
		{
			var arialName:String = new BGPArial().fontName;
			
			this.txtNum.embedFonts = true;
			this.txtNum.antiAliasType = AntiAliasType.ADVANCED;
			this.txtNum.setTextFormat( new TextFormat(arialName) );
			
			this.txtAmount.embedFonts = true;
			this.txtAmount.antiAliasType = AntiAliasType.ADVANCED;
			this.txtAmount.setTextFormat( new TextFormat(arialName) );
			

		}
		
		public function fill(num:int, amount:Number, username:String=''):void
		{
			this.txtNum.text = (num + 1).toString();
			this.txtAmount.text = amount + ' ლარი';
			this.txtUsername.text = username
		}
		
	}

}