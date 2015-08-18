package com.jokerbros.joker.game.GameActionWindow 
{
	import com.jokerbros.joker.Facade.Facade;
	import com.jokerbros.joker.events.GameEvent;
	import com.jokerbros.joker.events.PanelEvent;
	import com.jokerbros.joker.game.ActionPanel;
	import com.jokerbros.joker.game.Game;
	import com.jokerbros.joker.user.ReportException;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author ValeriiT.Fedorov
	 */
	public class JokerAction extends MovieClip
	{
		private var _actionPanel:ActionPanel;
		private var _game:Game;

		public function JokerAction(isFirstMove:Boolean)
		{
			_game = Facade.game;
			_actionPanel = new ActionPanel(_game.mcBoard.actionPanel);
			try 
			{
				if (isFirstMove)
				{
					_actionPanel.show(ActionPanel.FIRST_MOVE, true);
					Facade.dispatcher.addEventListener(GameEvent.MOVE_FIRST_JOKER, onFirstMoveJoker);
				}
				else
				{
					_actionPanel.show(ActionPanel.SECOND_MOVE, true);
					Facade.dispatcher.addEventListener(GameEvent.MOVE_SECOND_JOKER, onSecondMoveJoker);
				}
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 57, 'JokerAction' );
			}
		}

		private function onFirstMoveJoker(e:GameEvent):void
		{
			try 
			{
				Facade.dispatcher.removeEventListener(GameEvent.MOVE_FIRST_JOKER, onFirstMoveJoker);
				_actionPanel.show(ActionPanel.FIRST_MOVE, false);
				
				if (e.data != null)
				{
					response(int(e.data.action), e.data.order as String);
				}
				else
				{
					response(0);
				}
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 67, 'JokerAction' );
			}
		}
		
		private function onSecondMoveJoker(e:GameEvent):void
		{
			try 
			{
				Facade.dispatcher.removeEventListener(GameEvent.MOVE_SECOND_JOKER, onSecondMoveJoker);
				_actionPanel.show(ActionPanel.SECOND_MOVE, false);
				response(int(e.data));
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 85, 'JokerAction' );
			}
		}

		private function response(action:int=0, order:String=''):void
		{
			try 
			{
				var data:Object = {};
				
				if (action > 0)
				{
					data["action"] =  action;
					
					if (order != '')
					{
						data["order"] = order;
					}
				}
				else
				{
					data = null;
				}
				dispatchEvent(new PanelEvent(PanelEvent.MOVE_JOKER_ACTION, data));
			}
			catch (err:Error)
			{
				ReportException.send(err.message, 114, 'JokerAction' );
			}
		}
		
	}

}