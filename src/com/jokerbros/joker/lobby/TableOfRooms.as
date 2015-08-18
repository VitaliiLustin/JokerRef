package com.jokerbros.joker.lobby 
{
	import com.greensock.easing.*;
	import com.greensock.TweenNano;
	import com.jokerbros.joker.events.TableOfRoomsEvent;
	import com.jokerbros.joker.user.User;
	import com.jokerbros.joker.utils.EDScrollbar;
	import com.smartfoxserver.v2.entities.data.*;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	import com.jokerbros.joker.lobby.items.RoomItem;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class TableOfRooms extends MovieClip
	{
		
		private var _mcCont:MovieClip;
		private var _mcContMask:MovieClip;
		private var _mcTrack:MovieClip;
		
		private var _scrollbar:EDScrollbar;
		
		private var _roomItem:Vector.<RoomItem>; // visual items (object)
		private var _roomsList:ISFSArray; // data from server
		
		private var _gameType:int;
		
		//public function TableOfRooms(mcCont:MovieClip, mcContMask:MovieClip, mcTrack:MovieClip) 
		public function TableOfRooms(tbl:MovieClip) 
		{
			_mcCont = tbl.mcTblContainer;
			_mcContMask = tbl.mcTableMask;
			_mcTrack = tbl.mcTrack;
			
			_mcTrack.visible = false;
			_scrollbar  = new EDScrollbar(Joker.STAGE);
			_scrollbar.mcTrack = _mcTrack;
			_scrollbar.initialize(this.updateContPos);
			
			_roomItem = new Vector.<RoomItem>();
			_roomsList = new SFSArray();
			
		}
		
		
		public function destroy():void
		{
			removeRoomItemEvents();
			
			if (_scrollbar)
			{
				_scrollbar.clear();
				_scrollbar = null
			}
		}
		
		
		public function updateContPos(percent:Number):void
		{	
			TweenNano.to(_mcCont, 0.5, { y:( 168 - Math.round( (_mcCont.height - _mcContMask.height) * percent) ), ease:Expo.easeOut } );
		}
		
		public function init(rooms:ISFSArray = null, gameType:int = 2):void
		{
			_gameType = gameType;
			this.updateRoomList(rooms);
		}
		
		/*ADD Item*/
		public function add(params:ISFSObject):void
		{
			_roomsList.addSFSObject(params);
			this.updateRoomList(null);
		}
		
		/*REMOVE Item*/
		public function remove(params:ISFSObject):void
		{
			for (var i:int = 0; i < _roomsList.size(); i++)
			{
				var currentRoom:ISFSObject = _roomsList.getSFSObject(i);
					
				if (currentRoom.getUtfString('roomName') == params.getUtfString('roomName'))
				{
					_roomsList.removeElementAt(i);
					break;
				}
			}
				
			this.updateRoomList(null);
		}
		
		/*change Item Status*/
		public function update(params:ISFSObject, act:String = 'free'):void
		{
			var status:int = (act == 'free')?0:1;
			
			for (var i:int = 0; i < _roomsList.size(); i++)
			{
					if (_roomsList.getSFSObject(i).getUtfString('roomName') == params.getUtfString('roomName'))
					{
						_roomsList.getSFSObject(i).putInt("status", status);
						break;
					}
			}
			
			this.updateRoomList(null);
		}
		

		/*Update Items in Table*/
		private function updateRoomList(rooms:ISFSArray = null):void
		{
			if (rooms != null) _roomsList = rooms;
			
			
			
			var rmY:int = 0;
			
			this.clearRoomItems();
			this.tableSort()
			
			for (var i:int = 0; i < this._roomsList.size(); i++)
			{
				_mcTrack.visible = (_roomsList.size() > 12)?true:false;
				
				var curRoom:ISFSObject 		= 	_roomsList.getSFSObject(i);
				
				_roomItem[i] 					= 	new RoomItem();
				_roomItem[i].setInfo(curRoom, _gameType);
				_roomItem[i].setY(rmY);

				rmY =	rmY + ( _roomItem[i].height + 1 );
				
				if( curRoom.getInt("status") == 0 && curRoom.getUtfString("ownerName") != User.username )
				{
					if (curRoom.getBool('private'))
					{
						_roomItem[i].isPrivate = true; /*(!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!)*/
						_roomItem[i].btnPrivPlayShow();
						_roomItem[i].btnPrivPlay.addEventListener(MouseEvent.CLICK, onJoinPrivateRoom)
						
					}
					else
					{
						
						
						
					}
				}
				else if( curRoom.getUtfString("ownerName") == User.username )
				{
					_roomItem[i].btnRemoveShow();
					_roomItem[i].btnRemove.addEventListener(MouseEvent.CLICK, onRemoveRoom)
						
				}
				else if ( curRoom.getInt("status") == 1 )
				{
					_roomItem[i].btnRunningShow();
				}
				
				_mcCont.addChild(_roomItem[i])

			}
			
			
			
			
		}
		
		
		/*Handlers*/
		private function onRemoveRoom(e:MouseEvent):void 
		{
			removeRoomItemEvents();
			
			var data:ISFSObject = new SFSObject();
				data.putUtfString('roomName', e.currentTarget.parent.roomName);
				
			remove(data); 
			
			dispatchEvent(new TableOfRoomsEvent(TableOfRoomsEvent.REMOVE_MY_ROOM))
		}
		
		private function onJoinPublicRoom(e:MouseEvent):void 
		{
			
			removeRoomItemEvents();

			dispatchEvent(new TableOfRoomsEvent(TableOfRoomsEvent.SIT_PUBLIC_ROOM, e.currentTarget.parent))
			
		}
		
		private function onJoinPrivateRoom(e:MouseEvent):void 
		{
			removeRoomItemEvents();
			
			dispatchEvent(new TableOfRoomsEvent(TableOfRoomsEvent.SIT_RPIVATE_ROOM, e.currentTarget.parent))
		}

		
		/*Tools*/
		private function clearRoomItems():void 
		{
			while (_mcCont.numChildren > 0) _mcCont.removeChildAt(0);
			
			this.removeRoomItemEvents();
			
			_roomItem = new Vector.<RoomItem>(); 
		}
		
		private function removeRoomItemEvents():void
		{
			for (var i:int = 0; i < _roomItem.length; i++) 
			{

				_roomItem[i].btnPrivPlay.removeEventListener(MouseEvent.CLICK,  onJoinPrivateRoom);
				_roomItem[i].btnRemove.removeEventListener(MouseEvent.CLICK, onRemoveRoom);
			}
		}
		
		private function tableSort():void 
		{
			var busyRoomList:ISFSArray = SFSArray.newInstance();
			var freeRoomList:ISFSArray = SFSArray.newInstance();
			
			var sortRoomList:ISFSArray = SFSArray.newInstance();
			
			for (var j:int = 0; j < this._roomsList.size(); j++) 
			{
				if(this._roomsList.getSFSObject(j).getUtfString("ownerName") == User.username ){
					sortRoomList.addSFSObject(this._roomsList.getSFSObject(j));
				}
				else if (this._roomsList.getSFSObject(j).getInt("status") == 1) {
					busyRoomList.addSFSObject(this._roomsList.getSFSObject(j));
				}
				else if (this._roomsList.getSFSObject(j).getInt("status") == 0) {
					freeRoomList.addSFSObject(this._roomsList.getSFSObject(j));
				}
			}
			
			
			for (var k:int = 0; k < freeRoomList.size(); k++) 
			{
				sortRoomList.addSFSObject(freeRoomList.getSFSObject(k));
			}
			
			for (var l:int = 0; l < busyRoomList.size(); l++) 
			{
				sortRoomList.addSFSObject(busyRoomList.getSFSObject(l));
			}
			
			this._roomsList = sortRoomList;
		}
		
		
		
	}

}