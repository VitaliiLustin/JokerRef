package com.jokerbros.joker.lobby.items 
{
	import com.jokerbros.joker.utils.FontTools;
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
			FontTools.embed(username, FontTools.bpgarial);
			FontTools.embed(note, FontTools.bpgarial);
		}
		
		public function fill(params:ISFSArray, index:int):void
		{
			username.text = params.getSFSObject(index).getUtfString('username')
			note.text = params.getSFSObject(index).getUtfString('note')
		}
		
	}

}