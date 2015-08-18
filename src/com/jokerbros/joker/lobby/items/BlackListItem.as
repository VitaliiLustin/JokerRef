package com.jokerbros.joker.lobby.items 
{
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class BlackListItem extends mcBlackListItem
	{
		
		public function BlackListItem() 
		{
			var arialName:String = new BGPArial().fontName;
			
			this.username.embedFonts = true;
			this.username.antiAliasType = AntiAliasType.ADVANCED;
			this.username.setTextFormat( new TextFormat(arialName) );
			
			this.note.embedFonts = true;
			this.note.antiAliasType = AntiAliasType.ADVANCED;
			this.note.setTextFormat( new TextFormat(arialName) );

			
		}
		
		public function fill(params:ISFSArray, index:int):void
		{
			
			this.username.text = params.getSFSObject(index).getUtfString('username')
			this.note.text = params.getSFSObject(index).getUtfString('note')
			
		}
		
		
		
	}

}