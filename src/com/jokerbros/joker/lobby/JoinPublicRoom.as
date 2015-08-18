package com.jokerbros.joker.lobby 
{
	import com.jokerbros.joker.events.JoinRoomEvent;
	import com.jokerbros.joker.user.User;
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class JoinPublicRoom extends Sprite
	{
		
		public static const LEVEL2_MIN_AMOUNT:int = 1000;
		public static const LEVEL3_MIN_AMOUNT:int = 4000;
		
	
		private var _mcCash:MovieClip;
		private var _mcFree:MovieClip;
		
		private var _type:int;
		
		public function JoinPublicRoom(mcCash:MovieClip, mcFree:MovieClip) 
		{
			_mcCash = mcCash;
			_mcFree = mcFree;
			
			_mcCash.visible = false;
			_mcFree.visible = false;
			
			initGraphics();
		}
		
		private function onBlackListClick(e:MouseEvent):void 
		{
			dispatchEvent(new JoinRoomEvent(JoinRoomEvent.SHOW_BLACK_LIST));
		}
		private function onHelpClick(e:MouseEvent):void 
		{
			dispatchEvent(new JoinRoomEvent(JoinRoomEvent.SHOW_HELP));
		}
		
		public function init(type:int, rooms:ISFSArray= null, myRoom:ISFSObject=null):void
		{
			_type = type;

			clear();
			
			if (_type == 1) initCashItem();
			else initFreeItem();
			
			
			if (rooms)
			{
				
				for (var i:int = 0; i < rooms.size(); i++) 
				{
					placeIcon(rooms.getSFSObject(i).getInt('count'), rooms.getSFSObject(i).getInt('level'), rooms.getSFSObject(i).getUtfString('type'));
				}
			}
			
			if (myRoom)
			{	
				if (_type == 1)
				{
					_mcCash[myRoom.getUtfString('type') + myRoom.getInt('level')].btnUp.visible = true;					
					_mcCash[myRoom.getUtfString('type') + myRoom.getInt('level')].btnSit.visible = false;
					_mcCash[myRoom.getUtfString('type') + myRoom.getInt('level')].btnUp.addEventListener(MouseEvent.CLICK, onFreePlace);
				}
				else
				{
					_mcFree['mcLevel' + myRoom.getInt('level')][myRoom.getUtfString('type')].btnUp.visible = true;					
					_mcFree['mcLevel' + myRoom.getInt('level')][myRoom.getUtfString('type')].btnSit.visible = false;
					_mcFree['mcLevel' + myRoom.getInt('level')][myRoom.getUtfString('type')].btnUp.addEventListener(MouseEvent.CLICK, onFreePlace);
				}
			}
			
		}
		
		public function enable(params:Boolean=true):void
		{
			if (params)
			{
				if (_type == 1) _mcCash.visible = true;
				else _mcFree.visible = true;
			}
			else
			{
				if (_type == 1) _mcCash.visible = false;
				else _mcFree.visible = false;
			}
		}
		
		private function initCashItem():void
		{
		
			for (var i:int = 1; i <= 3; i++) 
			{
				for (var j:int = 1; j <= 8; j++) 
				{
					_mcCash.typeStandard1['pl' + j].gotoAndStop(1);
					_mcCash['typeOnly9' + i]['pl' + j].gotoAndStop(1);
				}
				
				
				_mcCash['typeOnly9' + i].btnSit.addEventListener(MouseEvent.CLICK, onTakePlace);
			} 
			
			_mcCash.typeStandard1.btnSit.addEventListener(MouseEvent.CLICK, onTakePlace);
			_mcCash.btnBlackList.addEventListener(MouseEvent.CLICK, onBlackListClick);
			_mcCash.btnHelp.addEventListener(MouseEvent.CLICK, onHelpClick);
			_mcCash.visible = true;
		}
		
		private function initFreeItem():void 
		{
			
			// init default
			for (var i:int = 1; i <= 3; i++) 
			{
				var point:int = 0
				
				for (var j:int = 1; j <= 4; j++) 
				{
					_mcFree['mcLevel'+i].typeStandard['pl'+j].gotoAndStop(1);
					_mcFree['mcLevel'+i].typeOnly9['pl'+j].gotoAndStop(1);
				}
				
				if (i == 1) point = 50
				else if (i == 2) point = 150
				else if (i == 3) point = 300

				_mcFree['mcLevel' + i].txtLevel.text = 'დონე ' + i.toString();
				_mcFree['mcLevel' + i].minRating.text = calcMinRating(i);
				_mcFree['mcLevel' + i].alpha = 0.3
				_mcFree['mcLevel' + i].typeOnly9.btnUp.enabled = false
				_mcFree['mcLevel' + i].typeOnly9.btnSit.enabled = false
				_mcFree['mcLevel' + i].typeStandard.btnUp.enabled = false				
				_mcFree['mcLevel' + i].typeStandard.btnSit.enabled = false
				
				_mcFree['mcLevel' + i].typeOnly9.bet.text = point.toString()
				_mcFree['mcLevel' + i].typeStandard.bet.text = point.toString()
				
				
				initLevel();
			}
			
			_mcFree.visible = true;
		}
		
		private function initLevel():void
		{
			_mcFree.mcLevel1.alpha = 1
			_mcFree.mcLevel1.typeOnly9.btnUp.enabled = true
			_mcFree.mcLevel1.typeOnly9.btnSit.enabled = true

			_mcFree.mcLevel1.typeStandard.btnUp.enabled = true				
			_mcFree.mcLevel1.typeStandard.btnSit.enabled = true
			_mcFree.mcLevel1.typeOnly9.btnSit.addEventListener(MouseEvent.CLICK, onTakePlace)
			_mcFree.mcLevel1.typeStandard.btnSit.addEventListener(MouseEvent.CLICK, onTakePlace)
			
			
			if ( int(User.balance) >= JoinPublicRoom.LEVEL2_MIN_AMOUNT)
			{
				_mcFree.mcLevel2.alpha = 1;
				_mcFree.mcLevel2.typeOnly9.btnUp.enabled = true
				_mcFree.mcLevel2.typeOnly9.btnSit.enabled = true

				_mcFree.mcLevel2.typeStandard.btnUp.enabled = true				
				_mcFree.mcLevel2.typeStandard.btnSit.enabled = true
				_mcFree.mcLevel2.typeOnly9.btnSit.addEventListener(MouseEvent.CLICK, onTakePlace)
				_mcFree.mcLevel2.typeStandard.btnSit.addEventListener(MouseEvent.CLICK, onTakePlace)
			}
			
			if (int(User.balance) >= JoinPublicRoom.LEVEL3_MIN_AMOUNT)
			{
				_mcFree.mcLevel3.alpha = 1;
				_mcFree.mcLevel3.typeOnly9.btnUp.enabled = true
				_mcFree.mcLevel3.typeOnly9.btnSit.enabled = true

				_mcFree.mcLevel3.typeStandard.btnUp.enabled = true				
				_mcFree.mcLevel3.typeStandard.btnSit.enabled = true
				_mcFree.mcLevel3.typeOnly9.btnSit.addEventListener(MouseEvent.CLICK, onTakePlace)
				_mcFree.mcLevel3.typeStandard.btnSit.addEventListener(MouseEvent.CLICK, onTakePlace)
			}
			
			_mcFree.mcLevel1.typeOnly9.title.text = 'ცხრიანები';
			_mcFree.mcLevel1.typeStandard.title.text = 'სტანდარტული';
			
			_mcFree.mcLevel2.typeOnly9.title.text = 'ცხრიანები';
			_mcFree.mcLevel2.typeStandard.title.text = 'სტანდარტული';
			
			_mcFree.mcLevel3.typeOnly9.title.text = 'ცხრიანები';
			_mcFree.mcLevel3.typeStandard.title.text = 'სტანდარტული';
			
		}
		
		/*Handlers Handlers Handlers*/
		private function onTakePlace(e:MouseEvent):void 
		{
			var level:int; var type:String; var data:Object;
			
			if (_type == 1)
			{  	
				level = e.currentTarget.parent.name.substr((e.currentTarget.parent.name.length - 1), 1);
				type = e.currentTarget.parent.name.slice( 0, -1 );
			}
			else
			{
				level = e.currentTarget.parent.parent.name.substr(7, 1);
				type = e.currentTarget.parent.name;
			}

			
			data = { level:level, type:type };
			dispatchEvent(new JoinRoomEvent(JoinRoomEvent.TAKE_PLACE, data));
		}
		
		private function onFreePlace(e:MouseEvent):void 
		{
			var level:int; var type:String; var data:Object;
			
			if (_type == 1)
			{  	
				level = e.currentTarget.parent.name.substr((e.currentTarget.parent.name.length - 1), 1);
				type = e.currentTarget.parent.name.slice( 0, -1 );
			}
			else
			{
				level = e.currentTarget.parent.parent.name.substr(7, 1);
				type = e.currentTarget.parent.name;
			}
			
			data = { level:level, type:type };
			dispatchEvent(new JoinRoomEvent(JoinRoomEvent.FREE_PLACE, data));
		}
		
		
		
		/*Public Functions*/
		public function takePlace(level:int, type:String, placeCount:int):void
		{
			if (_type == 1)
			{
				_mcCash[type + level].btnSit.removeEventListener(MouseEvent.CLICK, onTakePlace)
				_mcCash[type + level].btnSit.visible = false;
				_mcCash[type + level].btnUp.addEventListener(MouseEvent.CLICK, onFreePlace)
				_mcCash[type + level].btnUp.visible = true;				
			}
			else
			{
				_mcFree['mcLevel' + level][type].btnSit.removeEventListener(MouseEvent.CLICK, onTakePlace)
				_mcFree['mcLevel' + level][type].btnSit.visible = false;
				_mcFree['mcLevel' + level][type].btnUp.addEventListener(MouseEvent.CLICK, onFreePlace)
				_mcFree['mcLevel' + level][type].btnUp.visible = true;
			}
			
			placeIcon(placeCount, level, type);
			
		}
		
		public function freePlace(level:int, type:String, placeCount:int):void
		{

			if (_type == 1)
			{
				_mcCash[type + level].btnUp.removeEventListener(MouseEvent.CLICK, onFreePlace);
				_mcCash[type + level].btnUp.visible = false;
				_mcCash[type + level].btnSit.addEventListener(MouseEvent.CLICK, onTakePlace);
				_mcCash[type + level].btnSit.visible = true;
			}
			else
			{
				_mcFree['mcLevel' + level][type].btnUp.removeEventListener(MouseEvent.CLICK, onFreePlace);
				_mcFree['mcLevel' + level][type].btnUp.visible = false;
				_mcFree['mcLevel' + level][type].btnSit.addEventListener(MouseEvent.CLICK, onTakePlace);
				_mcFree['mcLevel' + level][type].btnSit.visible = true;
			}
			placeIcon(placeCount, level, type);
		}

		public function placeIcon(place:int, level:int, type:String):void
		{
			var i:int = 1;
						
			if (_type == 1)
			{
				for (i = 1; i <= 8; i++)  _mcCash[type + level]['pl' + i].gotoAndStop(1);
			}
			else
			{
				for (i = 1; i <= 4; i++)  _mcFree['mcLevel' + level][type]['pl' + i].gotoAndStop(1);	
			}
			
			if (_type == 1)
			{
				for (i = 1; i <= place; i++)  _mcCash[type + level]['pl' + i].gotoAndStop(2);
			}
			else
			{
				for (i = 1; i <= place; i++)  _mcFree['mcLevel' + level][type]['pl' + i].gotoAndStop(2);
			}

			
		}
		
		private function initGraphics():void
		{
			
			var handel:String =  new Hanndel().fontName;
			var bpgArial:String = new BGPArial().fontName;
			
			_mcCash.typeStandard1.bet.embedFonts = true;
			_mcCash.typeStandard1.bet.antiAliasType = AntiAliasType.ADVANCED;
			_mcCash.typeStandard1.bet.setTextFormat( new TextFormat(bpgArial) );
			_mcCash.typeStandard1.bet.text = calcBet(i, 'typeStandard');
			_mcCash.typeStandard1.type_label.gotoAndStop(1);
			
				
			for (var i:int = 1; i <= 3; i++) 
			{

				_mcCash['typeOnly9' + i].bet.embedFonts = true;
				_mcCash['typeOnly9' + i].bet.antiAliasType = AntiAliasType.ADVANCED;
				_mcCash['typeOnly9' + i].bet.setTextFormat( new TextFormat(bpgArial) );	
				_mcCash['typeOnly9' + i].bet.text = calcBet(i, 'typeOnly9');
				if (_mcCash['typeOnly9' + i].type_label) { _mcCash['typeOnly9' + i].type_label.gotoAndStop(2); }
			} 
			
			
			for (i=1; i <= 3; i++) 
			{
				_mcFree['mcLevel' + i].typeStandard.title.embedFonts = true;
				_mcFree['mcLevel' + i].typeStandard.title.antiAliasType = AntiAliasType.ADVANCED;
				_mcFree['mcLevel' + i].typeStandard.title.setTextFormat( new TextFormat(bpgArial) );

				_mcFree['mcLevel' + i].typeStandard.bet.embedFonts = true;
				_mcFree['mcLevel' + i].typeStandard.bet.antiAliasType = AntiAliasType.ADVANCED;
				_mcFree['mcLevel' + i].typeStandard.bet.setTextFormat( new TextFormat(bpgArial) );
					
				_mcFree['mcLevel' + i].typeStandard.xishti.embedFonts = true;
				_mcFree['mcLevel' + i].typeStandard.xishti.antiAliasType = AntiAliasType.ADVANCED;
				_mcFree['mcLevel' + i].typeStandard.xishti.setTextFormat( new TextFormat(bpgArial) );

				_mcFree['mcLevel' + i].typeOnly9.title.embedFonts = true;
				_mcFree['mcLevel' + i].typeOnly9.title.antiAliasType = AntiAliasType.ADVANCED;
				_mcFree['mcLevel' + i].typeOnly9.title.setTextFormat( new TextFormat(bpgArial) );

				_mcFree['mcLevel' + i].typeOnly9.bet.embedFonts = true;
				_mcFree['mcLevel' + i].typeOnly9.bet.antiAliasType = AntiAliasType.ADVANCED;
				_mcFree['mcLevel' + i].typeOnly9.bet.setTextFormat( new TextFormat(bpgArial) );
					
				_mcFree['mcLevel' + i].typeOnly9.xishti.embedFonts = true;
				_mcFree['mcLevel' + i].typeOnly9.xishti.antiAliasType = AntiAliasType.ADVANCED;
				_mcFree['mcLevel' + i].typeOnly9.xishti.setTextFormat( new TextFormat(bpgArial) );
				
				_mcFree['mcLevel' + i].txtLevel.embedFonts = true;
				_mcFree['mcLevel' + i].txtLevel.antiAliasType = AntiAliasType.ADVANCED;
				_mcFree['mcLevel' + i].txtLevel.setTextFormat( new TextFormat(handel) );
					
				_mcFree['mcLevel' + i].minRating.embedFonts = true;
				_mcFree['mcLevel' + i].minRating.antiAliasType = AntiAliasType.ADVANCED;
				_mcFree['mcLevel' + i].minRating.setTextFormat( new TextFormat(bpgArial) );
			}
		}
		
		
		public function clear():void
		{
			clearCash();
			clearFun();
			
			try 
			{
				_mcCash.btnBlackList.removeEventListener(MouseEvent.CLICK, onBlackListClick);
				_mcCash.btnHelp.removeEventListener(MouseEvent.CLICK, onHelpClick);
			}
			catch (err:Error)
			{
				
			}
			
		}
		
		private function clearCash():void
		{
			_mcCash.typeStandard1.btnSit.visible = true;
			_mcCash.typeStandard1.btnUp.visible = true;
			_mcCash.typeStandard1.btnSit.removeEventListener(MouseEvent.CLICK, onTakePlace);
			_mcCash.typeStandard1.btnUp.removeEventListener(MouseEvent.CLICK, onFreePlace);
		
			for (var i:int = 1; i <= 3; i++) 
			{	
				_mcCash['typeOnly9' + i].btnSit.visible = true;
				_mcCash['typeOnly9' + i].btnUp.visible = true;
				_mcCash['typeOnly9' + i].btnSit.removeEventListener(MouseEvent.CLICK, onTakePlace);
				_mcCash['typeOnly9' + i].btnUp.removeEventListener(MouseEvent.CLICK, onFreePlace);
			} 
			_mcCash.visible = false;
		}
		
		private function clearFun():void
		{
			for (var i:int = 1; i <= 3; i++) 
			{
				_mcFree['mcLevel' + i].typeStandard.btnSit.visible = true;
				_mcFree['mcLevel' + i].typeOnly9.btnSit.visible = true;
				_mcFree['mcLevel' + i].typeStandard.btnUp.visible = true;
				_mcFree['mcLevel' + i].typeOnly9.btnUp.visible = true;
				
				_mcFree['mcLevel' + i].typeStandard.btnSit.removeEventListener(MouseEvent.CLICK, onTakePlace);
				_mcFree['mcLevel' + i].typeOnly9.btnSit.removeEventListener(MouseEvent.CLICK, onTakePlace);
				_mcFree['mcLevel' + i].typeStandard.btnUp.removeEventListener(MouseEvent.CLICK, onFreePlace);
				_mcFree['mcLevel' + i].typeOnly9.btnUp.removeEventListener(MouseEvent.CLICK, onFreePlace);			
			}
			
			_mcFree.visible = false;
		}
		 
		
		/*Help Tiny Functions*/
		private function calcMinRating(index:int):String
		{
			switch (index) 
			{
				case 1: return '50'; 
				case 2: return '1000';
				case 3: return '4000';
				default: return '';
			}
		}
		
		private function calcBet(level:int, type:String):String
		{
			if (type == 'typeStandard')	{return '2';}
			else
			{	if 		(level ==1)	{return '2';}
				else if (level ==2) {return '5';}
				else				{return '1'	}
			}
		}
		
	}

}