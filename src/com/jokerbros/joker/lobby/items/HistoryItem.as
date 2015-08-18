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
	public class HistoryItem extends mcHistoryItem
	{
		
		public function HistoryItem() 
		{
			FontTools.embed(createDate, FontTools.bpgarial);
			FontTools.embed(opponent, FontTools.bpgarial);
			FontTools.embed(typeNote, FontTools.bpgarial);
			FontTools.embed(bet, FontTools.bpgarial);
			FontTools.embed(result, FontTools.bpgarial);
		}
		
		public function fill(params:ISFSArray, index:int):void
		{
			createDate.text = params.getSFSObject(index).getUtfString('createDate')
			opponent.text = params.getSFSObject(index).getUtfString('opponent')
			
			bet.text = params.getSFSObject(index).getDouble('bet').toString();
			
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