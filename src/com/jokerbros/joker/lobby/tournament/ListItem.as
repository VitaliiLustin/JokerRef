package com.jokerbros.joker.lobby.tournament 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import com.jokerbros.joker.utils.TyniHelper;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author JokerBros
	 */
	public class ListItem extends mcTourListItem
	{
		
		private const HEADER_RED:int = 1
		private const HEADER_GREEN:int = 2
		private const HEADER_GREY:int = 3
		private const HEADER_YELLOW:int = 3
		
		private const ANNOUNCED:int = 1
		private const RUNNING:int = 2
		private const COMPLETED:int = 3
		private const REGISTER:int = 4
		
		public var id:int
		
		public function ListItem(params:ISFSObject) 
		{
			alpha = 0.9;
			
			mouseChildren = false
			useHandCursor = true
			buttonMode = true
			
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			id = params.getInt('id')
			//txtName.text = 'Tour#'			+id + ' 100GEL';
			
			if (params.getInt('status') == COMPLETED)
			{
				//txtDate.text = TyniHelper.sec2DM(params.getLong("startTime"));	
				txtDate.text = params.getUtfString('dateLine')
			}
			else
			{
				txtDate.text = params.getUtfString('dateLine')
			}

			txtTime.text = params.getUtfString('timeLine') 
			txtSum.text = params.getDouble('prizeFund').toString();
			txtPlace.text = params.getInt('limit').toString();
			txtRoll.text = (params.getDouble('buyIn') == 0)?"Freeroll":params.getDouble('buyIn').toString();
			mc_star.gotoAndStop(1);
			
			setStatus(params.getInt('status'))
			

			//setGlowAnim() 
		}
		
		private function onOut(e:MouseEvent):void 
		{
			alpha = 0.9;
		}
		
		private function onOver(e:MouseEvent):void 
		{
			alpha = 1;
		}
		
		public function setGlowAnim():void
		{
			TweenMax.to(this, 1.5, {glowFilter:{color:0xFFFFFF, alpha:0.4, blurX:10, blurY:10, strength: 6, quality: 6}, onComplete:onFinishTween, ease:Linear.easeNone});
		}
		
		private function onFinishTween():void 
		{
			TweenMax.to(this, 2, {delay:0,glowFilter:{color:0xFFFFFF, alpha:0.1, blurX:10, blurY:10, strength: 6, quality: 6}, onComplete:setGlowAnim, ease:Linear.easeNone});
		}
		
		private function setStatus(status:int):void
		{
			trace('status: ' + status)
			gotoAndStop(status) 
		}
		
	}

}