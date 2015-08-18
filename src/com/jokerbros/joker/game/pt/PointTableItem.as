package com.jokerbros.joker.game.pt 
{
	import com.jokerbros.joker.user.ReportException;
	/**
	 * ...
	 * @author 13
	 */
	public class PointTableItem extends mcPointTableItem 
	{		
		private var _y:Number = 0;
		
		private var data_order:Object = {pl1orderX:7.85,pl2orderX:63.1,pl3orderX:123.3,pl4orderX:187.85}
		private var data_value:Object = { pl1valueX:7.85, pl2valueX:63.1, pl3valueX:123.3, pl4valueX:187.85 }
		
		public function PointTableItem() 
		{
			x = 6;
			y = 0;
			
			try 
			{
				for (var i:int = 1; i <= 4; i++) 
				{
					//this.data_order["pl" + i + "orderX"] = this["pl" + i + "_order"].x;
					//this.data_value["pl" + i + "valueX"] = this["pl" + i + "_value"].x;
				}	
			}
			catch (err:Error)
			{
				ReportException.send(err.message + 'indexI: ' +i.toString() , 30, 'PointTableItem' );
			}
			
		}
		
	}

}