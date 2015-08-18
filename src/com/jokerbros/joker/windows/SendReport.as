package com.jokerbros.joker.windows 
{
	import com.jokerbros.joker.game.Game;
	import com.jokerbros.joker.user.User;
	import com.jokerbros.joker.utils.JPGEncoder;
	import com.jokerbros.joker.utils.UploadPostHelper;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.system.Capabilities;
	import flash.system.JPEGLoaderContext;
	import flash.utils.ByteArray;
	
	import com.greensock.TweenMax;	
	import com.greensock.easing.*; 
	/**
	 * ...
	 * @author 13
	 */
	public class SendReport extends mcReport
	{
		public static const URL:String = 'http://www.jokerbros.com/index.php/report_game/create/joker';
		
		
		private var screenShotStream:ByteArray;
		
		public function SendReport() 
		{
			this.warningMsg.visible = false;
			this.input.text = '';
			this.mcModal.alpha = 0.3;
			
			//this.x = - this.width / 2;
			//this.y =  - this.height / 2;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Joker.STAGE.addEventListener(Event.RESIZE, this.resizeReport);
			
			this.close.addEventListener(MouseEvent.CLICK, onClose);	
			this.send.addEventListener(MouseEvent.CLICK, onSend);
			this.input.addEventListener(Event.CHANGE , changeText)
			
			this.resizeReport(null);
		}
		
		private function changeText(e:Event):void 
		{
			this.warningMsg.visible = false;
		}
		
		private function onClose(event:MouseEvent):void
		{
			this.destroy();
			this.complete();
		}
		
		private function onSend(event:MouseEvent):void
		{
			
			if (this.input.text.length < 5)
			{
				this.warningMsg.visible = true;
				return;
			}
			
			this.destroy();
			this.takeScreen();

			try 
			{
					var urlRequest : URLRequest = new URLRequest();
						urlRequest.url = SendReport.URL
						urlRequest.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
						urlRequest.method = URLRequestMethod.POST;
	 
					var postVariables:Object =  {
													room_id:(User.tableID)?User.tableID:0,
													username:User.username,
													message:this.input.text,
													server_string:Capabilities.serverString
												};
												  
						urlRequest.data = UploadPostHelper.getPostData('image.jpg', this.screenShotStream, postVariables); //here is where the magic happens, filedata will be the name to retrieve the file
						urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
	 
					var _pictureUploader:URLLoader = new URLLoader();
						_pictureUploader.dataFormat = URLLoaderDataFormat.BINARY;
						_pictureUploader.addEventListener( Event.COMPLETE, onSendComplete);
						_pictureUploader.load( urlRequest );	
			}
			catch (e:Error)
			{
				trace(e + ' /catch - ' + User.tableID);
			}
			
			this.complete();
		}
		
		
		private function onSendComplete(event:Event):void
		{
			this.complete();
		}
		
		public function takeScreen():void
		{
			try
			{
				var myBitmapData:BitmapData = new BitmapData(Joker.STAGE.stageWidth, Joker.STAGE.stageHeight);
					myBitmapData.draw(Joker.STAGE);
					
				var jpgEncoder:JPGEncoder = new JPGEncoder(60);
					this.screenShotStream = jpgEncoder.encode(myBitmapData);			
			}
			catch(e:Error){	}
		}
		
		private function complete():void
		{
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function destroy():void
		{
			try 
			{
				Joker.STAGE.removeEventListener(Event.RESIZE, this.resizeReport);
				this.close.removeEventListener(MouseEvent.CLICK, onClose);	
				this.send.removeEventListener(MouseEvent.CLICK, onSend);
				this.input.removeEventListener(Event.CHANGE , changeText)
				
				if (parent && parent.contains(this)) parent.removeChild(this);
			}
			catch (err:Error)
			{
				
			}

		}
		
		
		
		private function resizeReport(event:Event = null):void
		{	
			try 
			{ 
				this.mcModal.x = -stage.stageWidth / 2;
				this.mcModal.y = -stage.stageHeight / 2;
				this.mcModal.width = stage.stageWidth + 500;
				this.mcModal.height = stage.stageHeight + 250;

				this.x = int(stage.stageWidth / 2 - 201)
				this.y = int(stage.stageHeight / 2 - 140)	
			}
			catch (err:Error){}

		}
	}

}