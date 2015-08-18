package com.jokerbros.joker.game 
{
	import com.jokerbros.joker.connector.Connector;
	import com.jokerbros.joker.events.EndGameEvent;
	import com.jokerbros.joker.events.GameEvent;
	import com.jokerbros.joker.events.GameManagerEvent;
	import com.jokerbros.joker.events.GameTimerEvent;
	import com.jokerbros.joker.events.ReturningWindowEvent;
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.game.chat.Chat;
	import com.jokerbros.joker.game.pt.PointTable;
	import com.jokerbros.joker.game.scoresTable.ScoresTable;
	import com.jokerbros.joker.user.ReportException;
	import com.jokerbros.joker.user.User;
	import com.jokerbros.joker.utils.FontTools;
	import com.jokerbros.joker.windows.EndGame;
	import com.jokerbros.joker.windows.ReturningInGame;
	import com.jokerbros.joker.windows.SendReport;
	import com.smartfoxserver.v2.entities.data.*;
	import com.smartfoxserver.v2.requests.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author 13
	 */
	public class Game extends mcGame 
	{
		private static const DEFAULT_WIDTH	:int = GameConstants.DEFAULT_WIDTH;
		private static const DEFAULT_HEIGHT	:int = GameConstants.DEFAULT_HEIGHT;
		
		private var _manager:GameManager;
		private var _scoresTable:ScoresTable;
		//private var _pointTable:PointTable
		
		private var _gameTimer:GameTimer;
		private var _timerCurrentParam:int = -1;
		private var _endGame:EndGame
		
		private var _gameType:int;
		//private var mcBoard				 : MovieClip
		private var _infoBar				 :	InfoBar;
		private var _options				 : 	Options;
		
		private var _chat					 :	Chat;
		private var _currentHand			:int;
		private var _report :SendReport
		private var _initParams				:ISFSObject;
		public var 	mcBoard					:MovieClip;
		public function Game(params:ISFSObject)
		{
			Facade.game = this;
			_initParams = params;
		}
			
		public function addEventStage(e:Event = null):void
		{
			if (stage)
			{
				start();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, start);
			}
		}
		
		private function start(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, start);
			addEventListener(Event.REMOVED_FROM_STAGE, destroyGame);
			stage.addEventListener(Event.RESIZE, resizeGame);
			
			mcBoard = this.mcMain.mcBoard;
			mcBoard.mcDealer.visible = false;
			mcBoard.mcHandStatus.visible = false;
			
			_manager = new GameManager(mcBoard);
			_manager.addEventListener(GameManagerEvent.MOVE, onMove);
			_manager.addEventListener(GameManagerEvent.SET_ORDER_TRUMP, onOrderTrump);
			_manager.addEventListener(GameManagerEvent.SET_ORDER, onOrder);
			
			_gameTimer = new GameTimer(mcBoard);
			_gameTimer.addEventListener( GameTimerEvent.MY_END_TIMER, endMyTimer );
			
			_scoresTable = new ScoresTable(this);
			
			_infoBar = new InfoBar(mcInfoBar);
			_options = new Options(mcOptions);
			_options.addEventListener(Event.OPEN, onReport);
			
			_chat = new Chat(mcChat);
			
			btnLogOut.addEventListener(MouseEvent.CLICK, onLogOut);

			resizeGame();

			MainHandler.initHandlerGame(this);
			if(GameProperties.restore)
			{
				MainHandler.startGame(_initParams);
			}
		}
		
		//private function initPoint(e:Event = null):void 
		//{
			//removeEventListener(Event.ADDED_TO_STAGE, initPoint);
			//addEventListener(Event.REMOVED_FROM_STAGE, destroyGame);
			//stage.addEventListener(Event.RESIZE, resizeGame);
			//
			//mcBoard = this.mcMain.mcBoard;
			//
			//mcBoard.transform.perspectiveProjection = new PerspectiveProjection();
			//mcBoard.transform.perspectiveProjection.projectionCenter = new Point(600, 450);
			//mcBoard.transform.perspectiveProjection.fieldOfView = 72;
			//
			//mcBoard.mcHandStatus.visible = false;
			//
			//_manager = new GameManager(mcBoard);
			//_manager.addEventListener(GameManagerEvent.MOVE, onMove);
			//_manager.addEventListener(GameManagerEvent.SET_ORDER_TRUMP, onOrderTrump);
			//_manager.addEventListener(GameManagerEvent.SET_ORDER, onOrder);
			//
			//_gameTimer = new GameTimer(mcBoard);
			//_gameTimer.addEventListener( GameTimerEvent.MY_END_TIMER, endMyTimer );
			//
			////_pointTable = new PointTable(this.mcPointTable);
			//_scoresTable = new ScoresTable(this);
			//
			//_infoBar = new InfoBar(this.mcInfoBar)
			//
			//_options = new Options(mcOptions)
			//_options.addEventListener(Event.OPEN, onReport)
			//
			//_chat = new Chat(mcChat);
			//
			//btnLogOut.addEventListener(MouseEvent.CLICK, onLogOut)
			//
			//initGraphics();
			//resizeGame()
		//}
		
		public function init( params:ISFSObject ):void
		{
			if (params.getInt('gameType') != 2) mcChat.visible = false
			startGame(params)
		}
		
		private function startGame(params:ISFSObject):void
		{
			GameSound.play("startGame");
			
			_infoBar.updateBalance(User.balance);
			_infoBar.updateBet(params.getSFSObject('gameInfo').getDouble('bet'))
			
			_gameType = params.getInt('gameType');
			
			if (params.containsKey('users'))
			{
				_manager.setPlayersIndex( params.getInt('index'), params.getSFSArray('users') ); // myindex
				//_pointTable.init(params.getSFSObject('gameInfo').getInt('tableType'),params.getSFSObject('gameInfo').getInt('level'), params.getSFSObject('atuzva').getInt('tableIndex'), params.getInt('index'), params.getSFSArray('users'))
			}
			else
			{
				_manager.setPlayersIndex( params.getInt('index') ); // myindex
				//_pointTable.init(params.getSFSObject('gameInfo').getInt('tableType'),params.getSFSObject('gameInfo').getInt('level'), params.getSFSObject('atuzva').getInt('tableIndex'), params.getInt('index'))
			}
			
			startHand(params.getSFSObject('startHand'));
			oppAction(params.getInt('startClient'), 0 );
			
			_infoBar.setInfo(params.getSFSObject('gameInfo').getDouble('bet'), User.balance, _gameType)
		}
		
		
		public function action(cmd:String, params:ISFSObject):void
		{
			
			switch( cmd )
			{   
				/*იგზავნება მხოლოდ იმ შემ*/
				case "gameToLobby"			:  gameToLobby();
											   break;
				case "updateOrder"			:  updateOrder(params.getInt('index'), params.getInt('value'), params.getSFSObject('order'), params.getSFSObject('move'), params.getInt('handStatus'));
											   break;
				case "startHand"			:  startHand(params);
											   break;		
				case "oppMove"				: this.oppMove(params);
											   break;	
				case "oppAction"			:  this.oppAction(params.getInt('index'), params.getInt('action'));
											   break;		
				case "endGame"				:  this.endGame(params);
											   break;												   
				case "setMove"				:  this.setMove(params.getUtfStringArray('disabledCards'), params.getBool('firstMove'), params.getSFSObject('autoMoveCard'));
											   break;	
				case "updateTaken"			:  this.updateTaken(params.getInt('value'), params.getInt('index'));
											   break;	
				case "switchUser"			:  this.switchUser(params.getInt('index'), params.getInt('type'));					
											   break;	
			}
			
			if (_chat) _chat.action(cmd, params);
		}
		
		private function updateTaken(value:int, index:int):void 
		{
			_manager.setCurrentOrder(value, index);
		}
				
			
		private function startHand(params:ISFSObject):void 
		{
			updateHandStatus();
			
			var cards:Array = params.getUtfStringArray('cards');
			var trump:String = (params.getUtfString('trump'))?params.getUtfString('trump'):'';
			
			_manager.resetAutoActionVars();
			_manager.distribute(cards, trump);
			
			if (params.getSFSObject('order') != null)
			{
				setOrder( params.getSFSObject('order').getInt('max'), params.getSFSObject('order').getInt('restrict'), params.getSFSObject('order').getInt('fill'), params.getSFSObject('order').getInt('autoOrder') );
			}
			else if (params.getSFSObject('orderTrump') != null)
			{
				setOrderTrump(params.getSFSObject('orderTrump').getUtfString('autoOrderTrump'));	
			}
				
			_currentHand = params.getInt('currentHand');
				
			if (params.getSFSObject('partItem'))
			{	
				//_pointTable.setOrderResult(params.getSFSObject('partItem'));
			}
				
			
		}
		

		private function oppMove(params:ISFSObject = null):void
		{
			_gameTimer.disable();
			
			var index:int = params.getInt('index');
			var move:ISFSObject = params.getSFSObject('move');
			var card:ISFSObject = params.getSFSObject('card');
			var starthand:ISFSObject = params.getSFSObject('startHand');
			
			if (params.getBool('oppMove'))
			{
				_manager.oppMove(index, card);
			}
			
			if(move)
			{
				this.setMove( move.getUtfStringArray('disabledCards'), move.getBool('firstMove'), move.getSFSObject('autoMoveCard'));
			}
			
			if (params.containsKey('winIndex'))
			{
				var winIndex	:	int = params.getInt('winIndex');
				var taken		:	int = params.getInt('taken');
					
				_manager.setCurrentOrder(taken, winIndex);
			}
			
			if (starthand) startHand(starthand);
		}
		
		private function setMove(disabledCards:Array, firstMove:Boolean, autoMoveCard:ISFSObject = null):void 
		{
			_gameTimer.enable();
			_manager.resetAutoActionVars();
			
			_manager.checkEndLocalHand();
			_manager.enableCards(disabledCards, firstMove, autoMoveCard); // aq chasamatebelia card objecti
			
		}
		

		
		private function onMove(e:GameManagerEvent):void 
		{
			_gameTimer.disable();
				
			var data:ISFSObject = new SFSObject();
				
			if (e.data.card != null) data.putUtfString('value', e.data.card as String)
			if (e.data.action != null) data.putInt('action',  int(e.data.action))
			if (e.data.order != null) data.putUtfString('order', e.data.order as String)
			if (e.data.auto != null) data.putBool('auto', true);
	
			Connector.send("move", data);
		}

		public function setOrderTrump(autoOrderTrump:String=''):void
		{
			_gameTimer.enable();
			_manager.resetAutoActionVars();
			_manager.checkEndLocalHand();
			_manager.showOrderTrump(autoOrderTrump); // set trum val
		}
		
		private function onOrderTrump(e:GameManagerEvent):void 
		{
			_gameTimer.disable();
				
			var trump:String;
			var data:ISFSObject = new SFSObject();
			
			if (getQualifiedClassName(e.data).toString() == 'String')
			{
				trump =  e.data as String;
			}
			else
			{
				trump = e.data.trump;
				data.putBool('auto', true);
			}
			
				data.putUtfString('trump',  trump);
				
			Connector.send("orderTrump", data);
			
		}
		
		/**
		 * 
		 * @param	max = maqsimaluri cifrebis raodenboa
		 * @param	restric = amis garda
		 * @param	fill =  shesavsebad sachiroa
		 */
		public function setOrder(max:int, restric:int, fill:int = -1, autoOrder:int = -1):void
		{
			_gameTimer.enable();
			_manager.resetAutoActionVars();
			
			_manager.checkEndLocalHand();
			_manager.showOrder(max, restric, fill, autoOrder);
		}
		
		private function onOrder(e:GameManagerEvent):void 
		{
			_gameTimer.disable();
			
			var val:int;
			var data:ISFSObject = new SFSObject();
			
			if (getQualifiedClassName(e.data).toString() == 'int')
			{
				val = int(e.data);
			}
			else
			{
				val = e.data.value;
				data.putBool('auto', true);
			}
			
			_manager.setOrder(val);
			
			data.putInt('value',  val);

			Connector.send("order", data);
		}
		
		

		private function updateOrder(index:int, value:int, order:ISFSObject = null, move:ISFSObject = null, handStatus:int=0):void
		{
			if (order != null)
			{	
				setOrder( order.getInt('max'), order.getInt('restrict'), order.getInt('fill'), order.getInt('autoOrder'));
			}
			else if(move != null)
			{
				setMove( move.getUtfStringArray('disabledCards'), move.getBool('firstMove'), move.getSFSObject('autoMoveCard')  );
			}
				
			updateHandStatus(handStatus);
				
			//_pointTable.setOrder(index, _currentHand, value);
			_manager.setOrder(value,index);
		}
		
		public function updateHandStatus(status:int=0):void
		{
			
			if (status > 0) // shetenva
			{
				mcBoard.mcHandStatus.visible = true;
				mcBoard.mcHandStatus.label.text = 'შეტენვა: ' + status.toString();
			}
			else if(status < 0) //waglejva
			{
				mcBoard.mcHandStatus.visible = true;
				mcBoard.mcHandStatus.label.text = 'წაგლეჯვა: ' + (status * -1).toString();
			}
			else // reset
			{
				mcBoard.mcHandStatus.visible = false;
				mcBoard.mcHandStatus.label.text = '';
			}
		}
		
		
		private function oppAction(index:int, action:int):void 
		{
			_manager.checkEndLocalHand();
			_gameTimer.enable( _manager.getPlayerPos(index) );
		}
		
		
		private function switchUser(index:int, type:int):void
		{
			_manager.switchUser(index, type);
		}

	
		private function endGame(params:ISFSObject):void
		{
			if (params.getSFSObject('partItem'))
			{ 
				//_pointTable.setOrderResult(params.getSFSObject('partItem'));
			}
				
			_gameTimer.disable();
				
			_endGame = new EndGame(params, _gameType);
			_endGame.addEventListener(EndGameEvent.CLOSE, destroyEndGame)
				
			addChild(_endGame);	
				
			User.balance = params.getDouble('balance');
			_infoBar.updateBalance(User.balance);
		}
		
		public function endGameAdd(params:ISFSObject):void
		{
			_endGame = new EndGame(params, _gameType);
			_endGame.addEventListener(EndGameEvent.CLOSE, destroyEndGame);
			addChild(_endGame);
		}
		
		private function destroyEndGame(e:EndGameEvent = null):void 
		{
			if (_endGame)
			{
				if(contains(_endGame)) removeChild(_endGame);
				_endGame.removeEventListener(EndGameEvent.CLOSE, destroyEndGame)
				_endGame = null;
			}

			if (e)
			{
				Connector.send("gameToLobby")
				gameToLobby();
			}
		}
		
		
		public function gameToLobby():void
		{
			dispatchEvent(new GameEvent(GameEvent.GAME_TO_LOBBY))
		}
		

		private function endMyTimer(e:GameTimerEvent):void 
		{
			_manager.clearJokerAction();
			_manager.disableCards();
			_manager.clearOrder();	
			_manager.clearOrderTrump();
			_manager.autoMyAction();
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------WINDOWS--------------------------------------------------------------------------------------------*/
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		
		/*-----------------------------------------------------------------------------------------------------------------------------*/
		/*--------------------------REPORT---------------------------------------------------------------------------------------------*/	
		private function onReport(e:Event):void 
		{
			resetReport();
			_report = new SendReport();
			_report.addEventListener(Event.COMPLETE, onCompleteReport);
			addChild(_report);
		}
		
		private function onCompleteReport(e:Event):void  
		{ 
			resetReport(); 
		}

		private function resetReport():void
		{
			if (_report)
			{
				if(contains(_report)) removeChild(_report); 
				_report.removeEventListener(Event.COMPLETE, onCompleteReport);
				_report = null; 
			}
		}
		
		
		private function onLogOut(e:Event):void
		{
			Connector.send("gameToLobby");
			gameToLobby()	
		}
		
		
		
		
		private function initGraphics():void
		{
			FontTools.embed(mcBoard.playerLeft.mcUserInfo.username, FontTools.bpgarial)
			FontTools.embed(mcBoard.playerTop.mcUserInfo.username, FontTools.bpgarial)
			FontTools.embed(mcBoard.playerRight.mcUserInfo.username, FontTools.bpgarial)
			FontTools.embed(mcBoard.playerBottom.mcUserInfo.username, FontTools.bpgarial)
			
			FontTools.embed(mcBoard.playerLeft.mcUserInfo.currentOrder, FontTools.bpgarial)
			FontTools.embed(mcBoard.playerTop.mcUserInfo.currentOrder, FontTools.bpgarial)
			FontTools.embed(mcBoard.playerRight.mcUserInfo.currentOrder, FontTools.bpgarial)
			FontTools.embed(mcBoard.playerBottom.mcUserInfo.currentOrder, FontTools.bpgarial)
			
			FontTools.embed(mcBoard.playerLeft.mcUserInfo.order, FontTools.bpgarial)
			FontTools.embed(mcBoard.playerTop.mcUserInfo.order, FontTools.bpgarial)
			FontTools.embed(mcBoard.playerRight.mcUserInfo.order, FontTools.bpgarial)
			FontTools.embed(mcBoard.playerBottom.mcUserInfo.order, FontTools.bpgarial)
			
			FontTools.embed(mcBoard.mcHandStatus.label, FontTools.bpgarial)
			
		}
		
		private function destroyGame(e:Event = null):void
		{
			if (e) removeEventListener(Event.REMOVED_FROM_STAGE, destroyGame);
			if (stage) stage.removeEventListener(Event.RESIZE, resizeGame)
			
			try
			{
				if(_gameTimer)
				{
					_gameTimer.removeEventListener( GameTimerEvent.MY_END_TIMER, endMyTimer ); 
					_gameTimer.disable();
					_gameTimer = null;
				}
				
				if (_manager)
				{
					_manager.removeEventListener(GameManagerEvent.MOVE, onMove);
					_manager.removeEventListener(GameManagerEvent.SET_ORDER_TRUMP, onOrderTrump);
					_manager.removeEventListener(GameManagerEvent.SET_ORDER, onOrder);
					_manager = null;
				}
			}
			catch (err:Error)
			{
				
			}
		}
		
		private function resizeGame(e:Event=null):void 
		{
			try 
			{
				var w:int = stage.stageWidth;
				var h:int = stage.stageHeight;
				var st_w:Number = stage.stageWidth / DEFAULT_WIDTH;
				var st_h:Number = stage.stageHeight / DEFAULT_HEIGHT;
				if (st_h < st_w) st_w = st_h;
				this.mcMain.scaleX = st_w;
				this.mcMain.scaleY = st_w;
				this.mcMain.x = int(stage.stageWidth / 2);
				this.mcMain.y = int(stage.stageHeight / 2);
				btnLogOut.x = w - btnLogOut.width - 5;
				mcOptions.x = w - mcOptions.width - 20;
				mcOptions.y = h - mcOptions.height - 15;
				mcInfoBar.x =  w/2;
				mcChat.x = 20; 
				mcChat.y = h - 34;
				_scoresTable.x = 0;
				//_scoresTable.y = 15;
			}
			catch (err:Error){}
		}
		
		public function destroy():void
		{
			_gameTimer.disable();
			
			try 
			{
				//_pointTable = null;
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 798, 'Game' );
			}
		}
		
		
		
		public function restore( params:ISFSObject ):void
		{
			
			_gameType = params.getInt('gameType');
			
			if (params.getInt('gameType') != 2) mcChat.visible = false
			
			_currentHand = params.getInt('currentHand');
			
			if (params.containsKey('users'))
			{
				trace('restore')
				_manager.setPlayersIndex( params.getInt('index'), params.getSFSArray('users') ); // myindex
				//_pointTable.init(params.getSFSObject('gameInfo').getInt('tableType'),params.getSFSObject('gameInfo').getInt('level'), params.getInt('tableIndex'), params.getInt('index'), params.getSFSArray('users'))
			}
			else
			{
				_manager.setPlayersIndex( params.getInt('index') ); // myindex
				//_pointTable.init(params.getSFSObject('gameInfo').getInt('tableType'),params.getSFSObject('gameInfo').getInt('level'), params.getInt('tableIndex'), params.getInt('index'))
			}
			
			//_manager.setPlayersIndex( params.getInt('index') ); // myindex

			
			//_pointTable.restore(params.getSFSObject('resultTable'), _currentHand);
			
			_manager.distribute(params.getUtfStringArray('cards'), params.getUtfString('trump'));
			_manager.restoreLastMoveCards(params.getSFSArray('lastMoveCards'));
			
			
			_infoBar.setInfo(params.getSFSObject('gameInfo').getDouble('bet'), User.balance, _gameType)
			
			/*********MOVED CARDS RESTORE*******************/
			for (var i:int = 0; i < params.getSFSArray('oppMoves').size(); i++) 
			{
				var actionMoves:ISFSObject = params.getSFSArray('oppMoves').getSFSObject(i);

				if (actionMoves.getInt('index') != params.getInt('index'))
				{
					_manager.oppMove(actionMoves.getInt('index'), actionMoves.getSFSObject('card'));
				}
				else
				{
					_manager.oppMove(actionMoves.getInt('index'), actionMoves.getSFSObject('card'));
				}
			}

			
			this.updateHandStatus(params.getInt('handStatus'));
			
			
			/*****************BOARD ORDER RESTORE ***********/
			for (var index:int = 1; index <= 4; index++) 
			{
				if (params.getSFSObject(index.toString()).containsKey('order') )
				{
					this.updateOrder(index , params.getSFSObject(index.toString()).getInt('order'), null, null, params.getInt('handStatus'));
				}
				
				if (params.getSFSObject(index.toString()).getInt('taken'))
				{
					_manager.setCurrentOrder(params.getSFSObject(index.toString()).getInt('taken'), index);	
				}
				
				if (params.getSFSObject(index.toString()).containsKey('type'))
				{
					this.switchUser(index, params.getSFSObject(index.toString()).getInt('type'));
				}
			}

			
			/******MY ACTION RESTORE**********************/
			if (params.getSFSObject('move')) // svlis agdegan (minicheba)
			{
				var disCard:Array = params.getSFSObject('move').getUtfStringArray('disabledCards');
				var firstMove:Boolean = params.getSFSObject('move').getBool('firstMove');
				
				this.setMove(disCard, firstMove, params.getSFSObject('move').getSFSObject('autoMoveCard'));
			}
			else if (params.getSFSObject('orderTrump')) // kozeris cxadebis agdgena
			{
				this.setOrderTrump(params.getSFSObject('orderTrump').getUtfString('autoOrderTrump'));
			}
			else if (params.getSFSObject('order')) // cxadebis agdgena
			{
				var max:int = params.getSFSObject('order').getInt('max');
				var restrict:int = params.getSFSObject('order').getInt('restrict');
				var fill:int = params.getSFSObject('order').getInt('fill');
				
				this.setOrder( max, restrict, fill, params.getSFSObject('order').getInt('autoOrder'));
			}
			
			_gameTimer.restore(params.getInt('timer'), _manager.getPlayerPos( params.getInt('activePlayer') ) ); 
		}
		
		public function get currentHand():int 
		{
			return _currentHand;
		}
		
		public function set currentHand(value:int):void {
			_currentHand = value;
		}

		public function get manager():GameManager {
			return _manager;
		}

		public function get scoresTable():ScoresTable {
			return _scoresTable;
		}

		public function get gameType():int {
			return _gameType;
		}

		public function get gameTimer():GameTimer {
			return _gameTimer;
		}

		public function get infoBar():InfoBar {
			return _infoBar;
		}

		public function set gameType(value:int):void {
			_gameType = value;
		}

		public function get chat():Chat {
			return _chat;
		}
		
	}

}