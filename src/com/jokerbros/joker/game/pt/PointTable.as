package com.jokerbros.joker.game.pt 
{
	import com.greensock.TweenNano;
	import com.jokerbros.joker.game.Card;
	import com.jokerbros.joker.user.ReportException;
	import com.jokerbros.joker.utils.FontTools;
	import com.smartfoxserver.v2.entities.data.*;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import mx.utils.ObjectUtil;
	/**
	 * ...
	 * @author 13
	 */
	public class PointTable extends mcPointTableNew 
	{
		//private const ADDLED_COLOR:int = 0xB80000;
		//private const ADDLED_COLOR:int = 0xFE6E2E;
		private const ADDLED_COLOR:int = 0x990000;
		
		private const PREMIUM_COLOR:int = 0x03BF00;
		
		
		
		private const TABLE_STANDART:int = 1;
		private const TABLE_ONLY_9:int = 2;
		
		private const FRAME_TABLE_STANDART:int = 1;
		private const FRAME_TABLE_ONLY_9:int = 2;
		private const FRAME_PULKA_STANDART:int = 3;
		private const FRAME_PULKA_ONLY_9:int = 4;
		
		private const PULKA_I:int  = 1;
		private const PULKA_II:int  = 2;
		private const PULKA_III:int  = 3;
		private const PULKA_IV:int  = 4;
		
	
		private var item:Vector.<PointTableItem>;
		private var pl_item:Vector.<PointTablePulkaItem>;
		
		private var _type:int;
		
		private var _playerPlace:Array;
		
		private var _currentPulka:int;
		
		private var _table:MovieClip;
		
		
		public function PointTable($table:MovieClip) 
		{
			
			_table = $table;
			
			_table.visible = true;
				
			var shadow:DropShadowFilter = new DropShadowFilter();
				shadow.distance = 10; 
				shadow.angle = 90; 
				shadow.blurX = 30;
				shadow.blurY = 30;
				shadow.alpha = 0.3;
				shadow.color 0x000000;
				
			_table.filters = [shadow];
				
			_currentPulka = PULKA_I;
				
			_table.x = 0;
			_table.y = 0;
			_table.gotoAndStop(1);
		
			_playerPlace = new Array();	

		}
		
		public function init(type:int=1,level:int = -1, placeIndex:int=1, myIndex:int = 1, users:ISFSArray = null):void 
		{
			_type = type;
			
			if (level<=2) 
			{
				_table.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				_table.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			}

			
			initPlayersPlace(placeIndex, myIndex, users);
			
			generateItems();
			
		}
		
		private function onOut(e:MouseEvent):void 
		{
			
			TweenNano.to(_table, 0.1 , { scaleX:1, scaleY:1 } )
			updatePosition();
		}
		
		private function onOver(e:MouseEvent):void 
		{
			updatePosition('reset');
			TweenNano.to(_table, 0.1 , { scaleX:1.3, scaleY:1.3 } )
		}
		
		

		
		private function initPlayersPlace(startIndex:int, myIndex:int, users:ISFSArray = null):void
		{
			
			try 
			{
				_table["pl1_username"].text = 'Bros' + startIndex;
				
				_playerPlace[startIndex] = 1;
				
				

				for (var j:int = 2; j <= 4; j++) 
				{
					if (startIndex == 4) startIndex = 1;
					else startIndex ++
					
					_table["pl" + j + "_username"].text = 'Bros' + startIndex;
					_playerPlace[startIndex] = j;
				}	
				
				_table["pl" + myIndex + "_username"].textColor = 0xFF6D2E;
				
				if (users)
				{
					for (var i:int = 0; i < users.size(); i++) 
					{
						_table["pl" + users.getSFSObject(i).getInt('index') + "_username"].text = users.getSFSObject(i).getUtfString('username');
					}
				}
				
				
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 128, 'PointTable' );
			}

			initUserNameFont();
			
		}
		
		
		private function generateItems():void
		{
				var pl_count:Array;
				var mc_root_y:int = 0;
				
				var j:int = 0;
				var i:int = 0;
				
				item = new Vector.<PointTableItem>();
				pl_item = new Vector.<PointTablePulkaItem>();
				
				if (_type == TABLE_STANDART)
				{
					_table.gotoAndStop(FRAME_PULKA_STANDART);
					pl_count = new Array(8, 12, 20, 24);
				}
				else
				{	
					_table.gotoAndStop(FRAME_PULKA_ONLY_9);
					pl_count = new Array(4, 8, 12, 16);
				}
				
				
				for (j=0; j < 4; j++) 
				{	
					for ( ; i < pl_count[j]; i++) 
					{
						item[i] = new PointTableItem();
						item[i].x += 0
						item[i].y = mc_root_y;
						mc_root_y = mc_root_y + 13;
						setDefaultValue(this.item[i], i);
						_table.items1.addChild(this.item[i]);
						
						initItemFont(i)
					}
					
					pl_item[j] = new PointTablePulkaItem();
					//pl_item[j].x += 0;
					pl_item[j].y = mc_root_y + 4;
					//mc_root_y = mc_root_y + ( this.pl_item[j].height - 4 );
					mc_root_y = mc_root_y + 16 + 4;
					_table.items1.addChild(this.pl_item[j]);
					
					initPulkaFont(j);
				}	
			
			
		}
		
		
		private function initItemFont(ind:int):void
		{
			for (var i:int = 1; i <= 4; i++) 
			{
				FontTools.embed(item[ind]["pl" + i + "_order"], FontTools.bpgarial);
				FontTools.embed(item[ind]["pl"+i+"_value"], FontTools.bpgarial);
			}	
		}
		
		private function initPulkaFont(ind:int):void
		{
			for (var i:int = 1; i <= 4; i++) 
			{
				FontTools.embed(pl_item[ind]["pl" + i + "_score"], FontTools.bpgarial);
			}	
		}
		
		private function initUserNameFont():void
		{
			for (var i:int = 1; i <= 4; i++) 
			{
				FontTools.embed(_table["pl" + i + "_username"], FontTools.bpgarial);
			}	
		}
		
		/*****************************************************************************************************************************/
		/*****************************************************************************************************************************/
		/*****************************************************************************************************************************/
		
		
		/**
		 * ramdeni tqva
		 * @param	player max value 4
		 * @param	hand max value 24
		 * @param	order max value 9
		 */ 
		public function setOrder(player:int, hand:int, order:int):void
		{
			updateCurrentPulka(hand);
			
			try 
			{
				item[hand-1]['pl'+_playerPlace[player]+'_order'].text = (order == 0)?'-':order.toString(); 	
			}
			catch (err:Error)
			{
				ReportException.send(err.message + 'player: ' + player , 281, 'PointTable' );
			}
		}
		
		
		/**
		 * ramdeni aigo
		 * @param	player max value 4
		 * @param	hand max value 24
		 * @param	value mac value 9
		 */
		public function setOrderResult(params:ISFSObject):void 
		{
				var curUser:ISFSObject;
				
				for (var i:int = 1; i <= 4; i++) 
				{
					curUser = params.getSFSObject(i.toString());
					
					if (curUser.getInt('score') >= 0)
					{
						item[curUser.getInt('hand') - 1]['pl' + _playerPlace[i] + '_value'].text = curUser.getInt('score').toString();
					}
					else
					{
						setXisht(_playerPlace[i], curUser.getInt('hand') - 1);
					}
					
					this.setPultkaSum( curUser.getInt('sum'), i, curUser.getInt('hand'));
					
					if (curUser.containsKey('delete'))
					{
						deleteOrder(_playerPlace[i], curUser.getInt('delete'));
					}
					
					if (curUser.getBool('addled') == true)
					{
						item[curUser.getInt('hand') - 1]['pl' + _playerPlace[i] + '_value'].textColor = ADDLED_COLOR;
					}
					
					if (curUser.containsKey('premium'))
					{
						trace('premium');
						
						item[curUser.getInt('hand') - 1]['pl' + _playerPlace[i] + '_value'].textColor = PREMIUM_COLOR;
					}
					
				}	

		}
		
		/**
		 * 
		 * @param	sum
		 * @param	index
		 * @param	hand
		 */
		private function setPultkaSum(sum:int, index:int, hand:int):void
		{

				var plItem:int;
				
				if (_type == TABLE_STANDART)
				{
					if (hand <= 8) 						plItem = 0;
					else if(hand > 8 && hand<=12) 		plItem = 1;
					else if(hand > 12 && hand <= 20) 	plItem = 2;
					else 								plItem = 3;
				}
				else
				{
					if (hand <= 4) 						plItem = 0;
					else if(hand > 4 && hand<=8)		plItem = 1;
					else if(hand > 8 && hand <= 12) 	plItem = 2;
					else 								plItem = 3;
				}
				
				pl_item[plItem]['pl' + _playerPlace[index] + '_score'].text = (Number(sum) / 100).toString();	

		}
		
		
		private function deleteOrder(pos:int, hand:int):void
		{

				var yy:Number = 7;
				var xx:Number = 0;
				
				switch (pos) 
				{
					case 1: xx = 18; break;
					case 2: xx = 73; break;
					case 3: xx = 133; break;
					case 4: xx = 197; break;
				}
				
				var line:mcLine = new mcLine();
					line.x = xx;
					line.y = yy;
					line.alpha = 0.4
					line.blendMode =  BlendMode.LAYER;
					
				
				item[hand-1].addChild(line)	

		}
		
		private function setXisht(pos:int, hand:int):void
		{
				var yy:Number = 4;
				var xx:Number = 0;
				
				switch (pos) 
				{
					case 1: xx = 23; break;
					case 2: xx = 78; break;
					case 3: xx = 138; break;
					case 4: xx = 202; break;
				}
				
				var xisht:mcXisht = new mcXisht();
					xisht.x = xx;
					xisht.y = yy;
					xisht.alpha = 0.7
					xisht.blendMode =  BlendMode.LAYER;
					
					item[hand].addChild(xisht)	

		}
		
		
		public function restore(params:ISFSObject, currenHand:int):void
		{
			
			for (var hand:int = 1; hand <= currenHand; hand++) 
			{
				for (var i:int = 1; i <= 4; i++) 
				{
					
					if (params.getSFSObject(i.toString()).getSFSObject(hand.toString()))
					{

						if (params.getSFSObject(i.toString()).getSFSObject(hand.toString()).containsKey('order'))
						{	
							var order:int = params.getSFSObject(i.toString()).getSFSObject(hand.toString()).getInt('order');
							setOrder(i, hand, order);
							
						}						

						if (params.getSFSObject(i.toString()).getSFSObject(hand.toString()).containsKey('score'))
						{
							var score:int = params.getSFSObject(i.toString()).getSFSObject(hand.toString()).getInt('score');
							
							if (score != 0)
							{
								//this.item[hand - 1]['pl' + _playerPlace[i] + '_value'].text = score.toString();		
								
								if (score > 0)
								{
									item[hand - 1]['pl' + _playerPlace[i] + '_value'].text = score.toString();
									
									if (params.getSFSObject(i.toString()).getSFSObject(hand.toString()).getBool('addled') == true)
									{
										item[hand - 1]['pl' + _playerPlace[i] + '_value'].textColor = ADDLED_COLOR;
									}
									
									if (params.getSFSObject(i.toString()).getSFSObject(hand.toString()).containsKey('premium'))
									{
										trace('premium restore');
										
										item[hand - 1]['pl' + _playerPlace[i] + '_value'].textColor = PREMIUM_COLOR;
									}
									
								}
								else
								{
									setXisht(_playerPlace[i], hand - 1);
								}
								
								if (params.getSFSObject(i.toString()).getSFSObject(hand.toString()).containsKey('delete'))
								{
									deleteOrder(_playerPlace[i], hand );
								}
								

								
								////////////////////////////
							}
							
						}
					
					}
					
					//this.checkPulkaSum(params, i, hand );
					
				}
			}
			
			
			for (var j:int = 1; j <= 4; j++) 
			{
				for (i = 1; i <= 4; i++ ) 
				{
				 if (params.getSFSObject(j.toString()).containsKey('sum_' + i.toString())) 
				 {
					var sum:int = params.getSFSObject(j.toString()).getInt('sum_' + i.toString());
					pl_item[i-1]['pl' + _playerPlace[j] + '_score'].text = (Number(sum) / 100).toString();
				 }    
				} 
			}
			
		}
		
		
		private function setDefaultValue(obj:PointTableItem, tmp:int=0):void 
		{
				for (var i:int = 1; i <= 4; i++) 
				{
					obj["pl"+i+"_order"].text = ''
					obj["pl"+i+"_value"].text = ''
				}	

		}
		
		
		public function updateCurrentPulka(hand:int):void
		{

				var pulka:int = this.handToPulka(hand);
				
				if (pulka != _currentPulka)
				{
					_currentPulka = pulka;	
					
					updatePosition();
				}	

			
		}
		
		
		private function updatePosition(act:String = ''):void
		{

				if (act == 'reset')
				{
					_table.items1.y = 25;
					
					if (_type == TABLE_STANDART)
					{
						_table.gotoAndStop(FRAME_TABLE_STANDART); 
					}
					else
					{
						_table.gotoAndStop(FRAME_TABLE_ONLY_9); 
					}
					
					return;
				}
				
				
				var yy:Number = 25;
				
				
				if (_type == TABLE_STANDART)
				{
					switch (_currentPulka) 
					{
						case PULKA_I: yy = 25; _table.gotoAndStop(FRAME_PULKA_STANDART);  break;
						case PULKA_II: yy = -99; _table.gotoAndStop(FRAME_PULKA_ONLY_9); break;
						case PULKA_III: yy = -171; _table.gotoAndStop(FRAME_PULKA_STANDART); break;
						case PULKA_IV: yy = -295; _table.gotoAndStop(FRAME_PULKA_ONLY_9); break;
					}	
				}
				else
				{
					switch (_currentPulka) 
					{
						case PULKA_I: yy = 25;  _table.gotoAndStop(FRAME_PULKA_ONLY_9); break;
						case PULKA_II: yy = -47; _table.gotoAndStop(FRAME_PULKA_ONLY_9); break;
						case PULKA_III: yy = -119; _table.gotoAndStop(FRAME_PULKA_ONLY_9); break;
						case PULKA_IV: yy = -191;  _table.gotoAndStop(FRAME_PULKA_ONLY_9); break;
					}
				}
				
				_table.items1.y = yy;	

			
		}
		
		private function handToPulka(hand:int):int
		{
				if (_type == TABLE_STANDART)
				{
					if (hand <= 8) 						return PULKA_I;
					else if(hand > 8 && hand<=12) 		return PULKA_II;
					else if(hand > 12 && hand <= 20) 	return PULKA_III;
					else 								return PULKA_IV;
				}
				else
				{
					if (hand <= 4) 						return PULKA_I;
					else if(hand > 4 && hand<=8)		return PULKA_II;
					else if(hand > 8 && hand <= 12) 	return PULKA_III;
					else 								return PULKA_IV;
				}	

			
			return PULKA_I;
		}
		
	}

}