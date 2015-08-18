package com.jokerbros.joker.lobby 
{
	import com.greensock.TweenNano;
	import com.jokerbros.joker.connector.Connector;
	import com.jokerbros.joker.events.LobbyEvent;
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.user.User;
	import com.jokerbros.joker.utils.FontTools;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import flash.display.MovieClip;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.utils.*;
	import flash.net.*;
	
	/**
	 * ...
	 * @author JokerBros
	 */
	public class UserMenu 
	{
		
		private var _mcUserMenu:MovieClip
		
		private var _intervalId:uint;
		
		public function UserMenu(mc:MovieClip) 
		{
			_mcUserMenu = mc;
			
			_mcUserMenu.mcOpen.visible = false;
			
			_mcUserMenu.mouseChildren	 =	true;
			_mcUserMenu.buttonMode 		 = 	true;
			_mcUserMenu.mcOpen.visible 	 =  false;

			
			_mcUserMenu.mcOpen.btnLogOut.buttonMode = true;
			_mcUserMenu.addEventListener(MouseEvent.CLICK, onClick);

			_mcUserMenu.mcOpen.btnLogOut.addEventListener(MouseEvent.CLICK, onLogOut);
			_mcUserMenu.mcOpen.btnLogOut.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_mcUserMenu.mcOpen.btnLogOut.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			_mcUserMenu.mcOpen.btnGetCash.stop();
			_mcUserMenu.mcOpen.btnAddCash.stop();
			_mcUserMenu.mcOpen.btnShowRating.stop();
			_mcUserMenu.mcOpen.btnShowGameHistory.stop();
			_mcUserMenu.mcOpen.btnLogOut.stop();
			
			btnDisable();
			
			initGraphics();
			
		}
		
		
		
		public function destroy():void
		{
			_mcUserMenu.mcOpen.btnLogOut.removeEventListener(MouseEvent.CLICK, onLogOut);
			_mcUserMenu.mcOpen.btnLogOut.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			_mcUserMenu.mcOpen.btnLogOut.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			btnDisable();	
		}
		
		
		
		public function btnEnable(gameType:int):void
		{
			btnDisable();
			
			
			if (gameType == 1)
			{
				
				_mcUserMenu.mcOpen.btnGetCash.alpha = 1;
				_mcUserMenu.mcOpen.btnAddCash.alpha = 1;
				
				_mcUserMenu.mcOpen.btnGetCash.buttonMode = true;
				_mcUserMenu.mcOpen.btnAddCash.buttonMode = true;
				
				_mcUserMenu.mcOpen.btnGetCash.addEventListener(MouseEvent.CLICK, onGetCash);
				_mcUserMenu.mcOpen.btnAddCash.addEventListener(MouseEvent.CLICK, onAddCash);
				
				_mcUserMenu.mcOpen.btnGetCash.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				_mcUserMenu.mcOpen.btnAddCash.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				
				_mcUserMenu.mcOpen.btnGetCash.addEventListener(MouseEvent.MOUSE_OUT, onOut);
				_mcUserMenu.mcOpen.btnAddCash.addEventListener(MouseEvent.MOUSE_OUT, onOut);
				
			}
			

			_mcUserMenu.mcOpen.btnShowRating.alpha = 1;
			_mcUserMenu.mcOpen.btnShowGameHistory.alpha = 1;
			
			_mcUserMenu.mcOpen.btnShowRating.buttonMode = true;
			_mcUserMenu.mcOpen.btnShowGameHistory.buttonMode = true;
			

			_mcUserMenu.mcOpen.btnShowRating.addEventListener(MouseEvent.CLICK, onShowRating);
			_mcUserMenu.mcOpen.btnShowGameHistory.addEventListener(MouseEvent.CLICK, onShowGameHistory);
			

			_mcUserMenu.mcOpen.btnShowRating.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_mcUserMenu.mcOpen.btnShowGameHistory.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			
		

			_mcUserMenu.mcOpen.btnShowRating.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_mcUserMenu.mcOpen.btnShowGameHistory.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
		}
		
		
		private function btnDisable():void
		{
			
			_mcUserMenu.mcOpen.btnGetCash.alpha = 0.2;
			_mcUserMenu.mcOpen.btnAddCash.alpha = 0.2;
			_mcUserMenu.mcOpen.btnShowRating.alpha = 0.2;
			_mcUserMenu.mcOpen.btnShowGameHistory.alpha = 0.2;
			
			_mcUserMenu.mcOpen.btnGetCash.buttonMode = false;
			_mcUserMenu.mcOpen.btnAddCash.buttonMode = false;
			_mcUserMenu.mcOpen.btnShowRating.buttonMode = false;
			_mcUserMenu.mcOpen.btnShowGameHistory.buttonMode = false;
			
			_mcUserMenu.mcOpen.btnGetCash.removeEventListener(MouseEvent.CLICK, onGetCash);
			_mcUserMenu.mcOpen.btnAddCash.removeEventListener(MouseEvent.CLICK, onAddCash);
			_mcUserMenu.mcOpen.btnShowRating.removeEventListener(MouseEvent.CLICK, onShowRating);
			_mcUserMenu.mcOpen.btnShowGameHistory.removeEventListener(MouseEvent.CLICK, onShowGameHistory);
			
			_mcUserMenu.mcOpen.btnGetCash.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			_mcUserMenu.mcOpen.btnAddCash.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			_mcUserMenu.mcOpen.btnShowRating.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			_mcUserMenu.mcOpen.btnShowGameHistory.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			
		
			_mcUserMenu.mcOpen.btnGetCash.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			_mcUserMenu.mcOpen.btnAddCash.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			_mcUserMenu.mcOpen.btnShowRating.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			_mcUserMenu.mcOpen.btnShowGameHistory.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		
		private function onOut(e:MouseEvent):void 
		{
			e.currentTarget.gotoAndStop(1);
		}
		
		private function onOver(e:MouseEvent):void 
		{
			e.currentTarget.gotoAndStop(2);
		}
		
		private function onLogOut(e:MouseEvent):void 
		{
			//Connector.sfs.disconnect();
			navigateToURL(new URLRequest("http://jokerbros.com/"), "_self");
		}
		
		private function onShowGameHistory(e:MouseEvent):void 
		{
			Facade.dispatcher.dispatch(LobbyEvent.SHOW_GAME_HISTORY);
		}
		
		private function onShowRating(e:MouseEvent):void 
		{
			Facade.dispatcher.dispatch(LobbyEvent.SHOW_RATING);
		}
		
		private function onGetCash(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest("http://jokerbros.com/deposit/getCash"), "_self");
		}
		
		private function onAddCash(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest("http://jokerbros.com/deposit/addCash"), "_self");
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if ( !_mcUserMenu.mcOpen.visible )
			{
				_mcUserMenu.buttonMode = false;
				_mcUserMenu.mcOpen.height = 57;
				_mcUserMenu.mcOpen.visible = true;
				_mcUserMenu.mcOpen.alpha = 0.1;
				TweenNano.to(_mcUserMenu.mcOpen, 0.15, { height:221, alpha:1 } );

			}
			else
			{
				_mcUserMenu.mcOpen.visible = false;
				_mcUserMenu.buttonMode = true;
			}
		}
		
		
		
		private function comboUp():void
		{
		}
		
		
		private function initGraphics():void
		{
			FontTools.embed(_mcUserMenu.username, FontTools.arial);
			FontTools.embed(_mcUserMenu.mcOpen.rating, FontTools.arial);
			FontTools.embed(_mcUserMenu.balance, FontTools.bpgarial);
		}
		
		public function updateInfo(gameType:int):void
		{
			var currency:String = (gameType==1)?' <font color="#009933" size="13">GEL</font>':' <font color="#FFCC00" size="12">ქულა</font>';
			
			_mcUserMenu.mcOpen.rating.text = User.rating;
			_mcUserMenu.username.text = User.username;
			//_mcUserMenu.balance.text = User.balance + currency;
			
			_mcUserMenu.balance.htmlText = User.balance + currency;
		}
		
	}

}