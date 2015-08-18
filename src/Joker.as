package 
{
	import com.jokerbros.joker.controllers.Controller;
	import com.jokerbros.joker.events.GameDispatcher;
	import com.jokerbros.joker.game.Game;
	import com.jokerbros.joker.lobby.Lobby;
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.models.GameModel;
	import com.jokerbros.joker.view.GreatView;
	import com.junkbyte.console.Cc;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	/**
	 * ...
	 * @author JokerBros
	 */
	[SWF(width=1024, height=600, frameRate=60)]
	[Frame(factoryClass="Preloader")]
	public class Joker extends Sprite
	{
		public static const COMPANY_SITE:String = 'http://www.jokerbros.com/';

		private static const PARAM_HOST			:String = '80.92.177.244';
		private static const PARAM_PORT			:int    = 9933;
		private static const PARAM_ZONE			:String = 'jokerbeta';
		private static const PARAM_KEY			:String = 'debuguser';
		private static const PARAM_USER_NAME	:String = 'debuguser';
		private static const PARAM_ROOM_NAME	:String = 'CashRoom9';

		private static var _LOADER_INFO			:Object;
		public static var STAGE					:Stage;
		
		private var _lobby						:Lobby;
		private var _game						:Game;
		private var _controller					:Controller;
		private var _view						:GreatView;

		public function Joker():void
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			// entry point
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Joker.STAGE = stage;
			SoundMixer.soundTransform = new SoundTransform(0.25);
			_LOADER_INFO = {
				host:  PARAM_HOST,
				port:  PARAM_PORT,
				zone:  PARAM_ZONE,
				config: (loaderInfo.parameters.config != null) ? loaderInfo.parameters.config : null,
				key: (loaderInfo.parameters.key != null) ? loaderInfo.parameters.key : PARAM_KEY,
				username: (loaderInfo.parameters.username != null) ? loaderInfo.parameters.username : PARAM_USER_NAME,
				roomName: (loaderInfo.parameters.roomName != null) ? loaderInfo.parameters.roomName : PARAM_ROOM_NAME,
				privateRoomID : (loaderInfo.parameters.roomID != null) ? loaderInfo.parameters.roomID: '',
				privatePassword : (loaderInfo.parameters.password != null) ? loaderInfo.parameters.password: ''
			};

			Cc.config.tracing = true;
			Cc.config.maxLines = 2000;
			if(this is DisplayObject)
			{
				Cc.startOnStage(this, "`");
			}
			Facade.dispatcher = new GameDispatcher();
			var model:GameModel = new GameModel();
			_controller = new Controller(model);
			_view = new GreatView(model);
			addChild(_view);
		}

		public static function get LOADER_INFO():Object {
			return _LOADER_INFO;
		}
	}
}