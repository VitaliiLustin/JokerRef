package  com.jokerbros.joker.lobby.items
{
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author 13
	 */
	public class RoomItem extends mcRoomItem 
	{
		public var roomName:String;
		public var isPrivate:Boolean = false;
		
		public function RoomItem() 
		{
			
			this.icon_username.gotoAndStop(2);
			
			this.icon_pl1.stop();
			this.icon_pl2.stop();
			this.icon_pl3.stop();
			
			this.btnAllHide();
					
			this.initGraphics();
			
		}
		
		public function btnRunningShow():void 
		{
			this.btnAllHide();
			this.btnRunning.visible = true;
		}
		
		public function btnRemoveShow():void 
		{
			this.btnAllHide();
			this.btnRemove.visible = true;
		}
		
		
		public function btnPrivPlayShow():void 
		{
			this.btnAllHide();
			this.btnPrivPlay.visible = true;
		}
		
		
		public function setInfo(params:ISFSObject, gameType:int):void
		{
			//gameType
			/*
			this.roomName 	  		= 	params.getUtfString("roomName");
			this.username.text 		= 	params.getUtfString("ownerName");
			this.bet.text      		= 	params.getDouble("bet").toString();
			this.point.text      	= 	params.getInt("point").toString();	
			this.typeNote.text      = 	(params.getInt("point") == 3)?'ქულამდე, მარსით':'ქულამდე';	
			
			if (gameType == 1)
			{
				this.rating.text 		= 	'';	
				
				this.betNote.text  =  'ლარი';	
			}
			else
			{
				this.betNote.text  =  'ქულა';
			}
			*/
			

		}
		 
		
		public function setY(yy:Number):void
		{
			this.y = yy;
		}
		
		
		
		private function btnAllHide():void 
		{
			this.btnRunning.visible = false;
			this.btnRemove.visible = false;
			this.btnPrivPlay.visible = false;
		}
		
		
		private function initGraphics():void
		{
			
			var arialName:String = new BGPArial().fontName;
			var arial:String = new Arial().fontName;
			
			this.username.embedFonts = true;
			this.username.antiAliasType = AntiAliasType.ADVANCED;
			this.username.setTextFormat( new TextFormat(arialName) );

			this.username_pl1.embedFonts = true;
			this.username_pl1.antiAliasType = AntiAliasType.ADVANCED;
			this.username_pl1.setTextFormat( new TextFormat(arialName) );
			
			this.username_pl2.embedFonts = true;
			this.username_pl2.antiAliasType = AntiAliasType.ADVANCED;
			this.username_pl2.setTextFormat( new TextFormat(arialName) );
			
			this.username_pl3.embedFonts = true;
			this.username_pl3.antiAliasType = AntiAliasType.ADVANCED;
			this.username_pl3.setTextFormat( new TextFormat(arialName) );
			
			
			
			this.bet.embedFonts = true;
			this.bet.antiAliasType = AntiAliasType.ADVANCED;
			this.bet.setTextFormat( new TextFormat(arial) );	
			
			this.betNote.embedFonts = true;
			this.betNote.antiAliasType = AntiAliasType.ADVANCED;
			this.betNote.setTextFormat( new TextFormat(arialName) );	
			
			
			this.xishti.embedFonts = true;
			this.xishti.antiAliasType = AntiAliasType.ADVANCED;
			this.xishti.setTextFormat( new TextFormat(arial) );	
			
			

			
		}
		
	}

}