package com.jokerbros.joker.lobby.items 
{
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class RatingItem extends mcRatingItem
	{
		
		public function RatingItem() 
		{
			var arialName:String = new BGPArial().fontName;
			
			this.pos.embedFonts = true;
			this.pos.antiAliasType = AntiAliasType.ADVANCED;
			this.pos.setTextFormat( new TextFormat(arialName) );
			
			this.username.embedFonts = true;
			this.username.antiAliasType = AntiAliasType.ADVANCED;
			this.username.setTextFormat( new TextFormat(arialName) );
			
			this.rating.embedFonts = true;
			this.rating.antiAliasType = AntiAliasType.ADVANCED;
			this.rating.setTextFormat( new TextFormat(arialName) );
			
		}
		

		
	}

}