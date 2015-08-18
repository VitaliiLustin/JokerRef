package com.jokerbros.joker.lobby.tournament 
{
	import com.jokerbros.joker.connector.Connector;
	import com.jokerbros.joker.utils.FontTools;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class Access 
	{
		private var _mcParent:MovieClip
		
		public function Access(mc:MovieClip) 
		{
			_mcParent = mc;
			
			_mcParent.btnBack.addEventListener(MouseEvent.CLICK, onBack);
			
			_mcParent.txtMsg.text = '';
		}
		
		private function onBack(e:MouseEvent):void 
		{
			Tournament.enableProgress(true);
			Connector.send('tourHome');
		}
		
		public function show(params:ISFSObject = null):void
		{
			if (params)
			{
				// TODO code
				_mcParent.txtMsg.text = params.getUtfString('msg')
			}
			
			_mcParent.visible = true
		}
		
		public function hide():void
		{
			_mcParent.visible = false
		}
		
		public function clear():void
		{
			_mcParent.btnBack.removeEventListener(MouseEvent.CLICK, onBack)
		}
		
	}

}