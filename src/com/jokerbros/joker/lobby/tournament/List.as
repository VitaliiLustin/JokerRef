package com.jokerbros.joker.lobby.tournament 
{
	import com.jokerbros.joker.connector.Connector;
	import com.jokerbros.joker.utils.EDScrollbar;
	import com.smartfoxserver.v2.entities.data.ISFSArray;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class List 
	{
		private var _mcParent:MovieClip
		
		private var _listItem:Vector.<ListItem>
		
		private var _scrollbar:EDScrollbar
		
		
		public function List($parent:MovieClip) 
		{
			_mcParent = $parent;
			
			_mcParent.btnToList.addEventListener(MouseEvent.CLICK, onToList)
			_mcParent.btnToList.visible = false
			_mcParent.btnArchive.addEventListener(MouseEvent.CLICK, onToArchive)
			_mcParent.btnArchive.visible = true
			
			_mcParent.mcBrosTalk.txtVal.embedFonts = true
			
			_scrollbar  = new EDScrollbar(Joker.STAGE);
			_scrollbar.mcTrack = _mcParent.mcTrack;
			_scrollbar.initialize(this.updateContPos, true);
			
			hideBrosTalk();
			
			_mcParent.visible = false;
		}
		
		public function updateContPos(percent:Number):void
		{	
			_mcParent.mcListCont.y = ( 84 -  Math.round( (_mcParent.mcListCont.height) * percent) );
			//TweenNano.to(_mcCont, 0.5, { y:( 168 - Math.round( (_mcCont.height - _mcContMask.height) * percent) ), ease:Expo.easeOut } );
		}
		
		public function show(params:ISFSObject):void
		{
			clearTour();
			_mcParent.btnToList.visible = false	
			_mcParent.btnArchive.visible = true
				
			if ( params.getSFSArray('tours').size() == 0 )
			{
				showBrosTalk('ამჟამად არც ერთი ტურნირი არ არის დაგეგმილი');
				_scrollbar.mcTrack.visible = false;
			}
			else
			{
				fillTour(params.getSFSArray('tours'));	
			}
			
			_mcParent.visible = true
		}
		
		public function hide():void
		{
			_mcParent.visible = false
		}
		
		
		/*---------------------------------------------------------------------------------------------------------------------*/
		/*------------------BROS TALK------------------------------------------------------------------------------------------*/
		private function showBrosTalk(msg:String =''):void
		{
			_mcParent.mcBrosTalk.txtVal.text = msg;  
			_mcParent.setChildIndex(_mcParent.mcBrosTalk, _mcParent.numChildren - 1);
			_mcParent.mcBrosTalk.visible = true
		}
		
		private function hideBrosTalk():void
		{
			_mcParent.mcBrosTalk.txtVal.text = '';
			_mcParent.mcBrosTalk.visible = false
		}
		
		/*---------------------------------------------------------------------------------------------------------------------*/
		/*------------------BTN HANDLERS---------------------------------------------------------------------------------------*/
		private function onToArchive(e:MouseEvent):void 
		{
			var data:ISFSObject = new SFSObject(); data.putInt('type', 1)
			Tournament.enableProgress(true)
			Connector.send('tourGetList', data)
		}
		
		private function onToList(e:MouseEvent):void 
		{
			var data:ISFSObject = new SFSObject(); data.putInt('type', 0)
			Tournament.enableProgress(true)
			Connector.send('tourGetList', data)
		}
		
		public function updateTourList(params:ISFSObject):void
		{
			clearTour()
			
			if (params.getInt('type') == 1)
			{
				_mcParent.btnToList.visible = true	
				_mcParent.btnArchive.visible = false
			}
			else
			{
				_mcParent.btnToList.visible = false	
				_mcParent.btnArchive.visible = true
			}
			
			if ( params.getSFSArray('tours').size() == 0 )
			{
				showBrosTalk( (params.getInt('type') != 1) ?  'ამჟამად არც ერთი ტურნირი არ არის დაგეგმილი' : 'არქივი ცარიელია' )
			}
			else
			{
				fillTour(params.getSFSArray('tours'))	
			}
			
			Tournament.enableProgress(false)
		}
		
		/*---------------------------------------------------------------------------------------------------------------------*/
		/*------------------TOUR LIST MNG--------------------------------------------------------------------------------------*/
		private function fillTour(params:ISFSArray):void
		{
			clearTour();
			hideBrosTalk();
			
			var def:int = 54, yy:int = 0
			
			_listItem = new Vector.<ListItem>()
			
			if (params.size() > 7)  _mcParent.mcTrack.visible = true 
			else _mcParent.mcTrack.visible = false
			
			for (var i:int = 0; i < params.size(); i++) 
			{
				_listItem[i] = new ListItem(params.getSFSObject(i))
				_listItem[i].y = yy;
				_listItem[i].addEventListener(MouseEvent.CLICK, onClickTour);
				yy = _listItem[i].y + def;
				_mcParent.mcListCont.addChild(_listItem[i])
			}
		}
		
		private function onClickTour(e:MouseEvent):void 
		{
			var data:ISFSObject = new SFSObject(); data.putInt('ID', int(e.currentTarget.id));
			Tournament.enableProgress(true);
			Connector.send('tourView', data);
		}
		
		private function clearTour():void
		{
			_scrollbar.reset(true)
			//_mcParent.mcListCont.x = 34
			
			if (!_listItem) return;
			
			for (var i:int = 0; i < _listItem.length; i++) 
			{
				if (_listItem[i])
				{
					if (_mcParent.mcListCont.contains(_listItem[i])) _mcParent.mcListCont.removeChild(_listItem[i])
					_listItem[i].removeEventListener(MouseEvent.CLICK, onClickTour)
					_listItem[i] = null
				}
			}
			_listItem = null
		}
		
		public function clear():void
		{
			clearTour()
			_mcParent.btnToList.removeEventListener(MouseEvent.CLICK, onToList)
			_mcParent.btnArchive.removeEventListener(MouseEvent.CLICK, onToArchive)
		}
		
	}

}
