package com.jokerbros.joker.lobby.items 
{
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class HistoryItem extends mcHistoryItem
	{
		
		public function HistoryItem() 
		{
			var arialName:String = new BGPArial().fontName;
			
			this.createDate.embedFonts = true;
			this.createDate.antiAliasType = AntiAliasType.ADVANCED;
			this.createDate.setTextFormat( new TextFormat(arialName) );
			
			this.opponent.embedFonts = true;
			this.opponent.antiAliasType = AntiAliasType.ADVANCED;
			this.opponent.setTextFormat( new TextFormat(arialName) );
			
			this.typeNote.embedFonts = true;
			this.typeNote.antiAliasType = AntiAliasType.ADVANCED;
			this.typeNote.setTextFormat( new TextFormat(arialName) );

			this.bet.embedFonts = true;
			this.bet.antiAliasType = AntiAliasType.ADVANCED;
			this.bet.setTextFormat( new TextFormat(arialName) );
			
			this.result.embedFonts = true;
			this.result.antiAliasType = AntiAliasType.ADVANCED;
			this.result.setTextFormat( new TextFormat(arialName) );
			
		}
		
		public function fill(params:ISFSArray, index:int):void
		{
			
			
			
			this.createDate.text = params.getSFSObject(index).getUtfString('createDate')
			this.opponent.text = params.getSFSObject(index).getUtfString('opponent')
			
			this.bet.text = params.getSFSObject(index).getDouble('bet').toString();
			
			var res:String = '';
			var point:int = params.getSFSObject(index).getInt('point')
			
			
			this.typeNote.text = (point == 3)?point + ' ქულამდე, მარსით':point + ' ქულამდე';
			
			
			if (params.getSFSObject(index).getInt('isWinner') == -1)
			{
				res = 'unknown';
			}
			else if (params.getSFSObject(index).getInt('isWinner') == 0)
			{
				res = 'წაგება'
			}
			else
			{
				res = 'მოგება'
			}
			
			this.result.text =  res;
			
		}
		
		
		
	}

}