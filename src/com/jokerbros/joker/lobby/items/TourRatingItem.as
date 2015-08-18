package com.jokerbros.joker.lobby.items 
{
	import com.jokerbros.joker.user.User;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat; 
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class TourRatingItem extends mcTourRatingItem
	{
		
		public function TourRatingItem() 
		{
			var arialName:String = new BGPArial().fontName;
			
			this.txtNum.embedFonts = true;
			this.txtNum.antiAliasType = AntiAliasType.ADVANCED;
			this.txtNum.setTextFormat( new TextFormat(arialName) );
			
			this.txtUsername.embedFonts = true;
			this.txtUsername.antiAliasType = AntiAliasType.ADVANCED;
			this.txtUsername.setTextFormat( new TextFormat(arialName) );
			
			this.txtPoint.embedFonts = true;
			this.txtPoint.antiAliasType = AntiAliasType.ADVANCED;
			this.txtPoint.setTextFormat( new TextFormat(arialName) );
			
			
			stop()
		}
		
		public function fill(num:int, username:String, point:Number):void
		{
			this.txtNum.text = (num).toString();
			this.txtUsername.text = username
			this.txtPoint.text = point.toString();
			
			if (User.username == username) gotoAndStop(2)

		}
		
	}

}