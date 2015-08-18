package com.jokerbros.joker.user 
{
	
	import com.jokerbros.joker.user.User;
	import flash.display.Sprite;
	import flash.net.*;
	/**
	 * ...
	 * @author 13
	 */
	public class ReportException  extends Sprite
	{
		
		public function ReportException() 
		{
			
		}
		
		public static function send(_exp:String, _line:int, _class:String):void
		{
			

			trace('_exp: ' + _exp);
			trace('_line: ' + _line);
			trace('_class: ' + _class);
			
			return
			
			try 
			{
			
				var loader : URLLoader = new URLLoader();  
				var request : URLRequest = new URLRequest("http://www.jokerbros.com/report_exception/set/joker");  
					request.method = URLRequestMethod.POST;  
				
					
				var variables : URLVariables = new URLVariables(); 	
					
					variables.exp = _exp;  
					variables.line = _line; 
					variables.className = _class; 
					
					variables.game_id = 1;
					variables.table_id = (User.tableID)?User.tableID:0;
					variables.username = User.username;
					
					variables.version = User.ReleaseVersion;
					
					request.data = variables;
					
					loader.load(request);  	
			}
			catch (err:Error)
			{
				
			}
				
				
				
		}
		
	}

}