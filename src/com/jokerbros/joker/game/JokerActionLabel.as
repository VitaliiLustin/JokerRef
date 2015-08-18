package com.jokerbros.joker.game 
{
	/**
	 * ...
	 * @author 13
	 */
	public class JokerActionLabel extends mcJokerAction 
	{
		private const JOKER_UP		:	int = 1;
		private const JOKER_BOTTOM	:	int = 2;
		private const JOKER_HIGH	:	int = 3;
		private const JOKER_TAKE	:	int = 4;
		
		private const FRAME_UP	: int = 1
		private const FRAME_BOTTOM	: int = 2
		
		private var _data:Object;
		
		public function JokerActionLabel(value:Object, x:Number, y:Number) 
		{
			this.stop();
			
			this.x = x;
			this.y = y;
			
			_data = value;
			
			this.width = 145;
			this.height = 55.35;
	
			switch ( int(_data.action) ) 
			{
				//case JOKER_UP			: 	this.msg.text = 'მოჯოკრა'; break;
				//case JOKER_BOTTOM		: 	this.msg.text = 'ქვევიდან'; break;
				//case JOKER_HIGH			: 	this.msg.text = 'მაღალი ' + value.order; break;
				//case JOKER_TAKE			: 	this.msg.text = 'წაიღოწ ' + value.order; break;
				
				
				case JOKER_UP			: 	this.gotoAndStop(FRAME_UP); 		break;
				case JOKER_BOTTOM		: 	this.gotoAndStop(FRAME_BOTTOM); 	break;
				
				case JOKER_HIGH			: 	this.high(); break;
				case JOKER_TAKE			: 	this.take(); break;
				
			}
			
		}
		
		private function high():void
		{
			switch (_data.order) 
			{
				case 'H': this.gotoAndStop(3); break;
				case 'D': this.gotoAndStop(4); break;
				case 'S': this.gotoAndStop(5); break;
				case 'C': this.gotoAndStop(6); break;
			}
		}
		
		private function take():void
		{
			switch (_data.order) 
			{
				case 'H': this.gotoAndStop(7); break;
				case 'D': this.gotoAndStop(8); break;
				case 'S': this.gotoAndStop(9); break;
				case 'C': this.gotoAndStop(10); break;
			}
		}
		
		// H - guli
		// D - aguri
		// S - yvavi
		// C  - jvari
		
	}

}