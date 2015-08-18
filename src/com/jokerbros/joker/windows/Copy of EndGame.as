package com.jokerbros.joker.windows 
{
	import com.jokerbros.joker.events.EndGameEvent;
	import com.smartfoxserver.v2.entities.data.*;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 13
	 */
	public class EndGame extends mcEndGame
	{
		
		public function EndGame(params:ISFSObject, type:int) 
		{
			
			
			
			if (type == 1)
			{
				//this.betType.text  =  'ლარი';	
			}
			else
			{
				//this.betType.text  =  'ქულა';
			}
			

			for (var i:int = 0; i < 4; i++) 
			{
				//this["username_" + (i+1)].text = params.getSFSArray('result').getSFSObject(i).getUtfString('username').toString();
				//this["point_" + (i+1)].text =  params.getSFSArray('result').getSFSObject(i).getDouble('winPoint').toString();
				//this["rating_" + (i+1)].text =  params.getSFSArray('result').getSFSObject(i).getDouble('rating').toString();
			}
			
			//this.close.addEventListener(MouseEvent.CLICK, onClose);
			
		}
		
		private function onClose(e:MouseEvent):void 
		{
			//this.close.removeEventListener(MouseEvent.CLICK, onClose);
			dispatchEvent(new EndGameEvent(EndGameEvent.CLOSE));
		}
		
	}

}