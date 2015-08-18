package com.jokerbros.joker.connector
{
import com.jokerbros.joker.user.User;
import com.jokerbros.joker.windows.WindowRetryConnection;

/**
	 * ...
	 * @author JokerBros
	 */
	internal final class StateBar
	{
		public static var windowRetry:WindowRetryConnection;
		
		public function StateBar()
		{
			windowRetry = new WindowRetryConnection();
		}
		
		public function hideAll():void
		{
			trace('hideAll');

			//connection/reconnection
			if (Joker.STAGE.contains(windowRetry))
			{
				Joker.STAGE.removeChild(windowRetry);
			}
			if(!User.soundEnabled)
			{
				User.soundOn(true);
			}
		}

		public function showLoginErrorWind():void
		{
			trace('showLoginErrorWind');
		}

		public function showKickWind():void
		{
			trace('showKickWind');

			windowRetry.updateText("reconect");
			if (!Joker.STAGE.contains(windowRetry))
			{
				Joker.STAGE.addChild(windowRetry);
			}
			if (User.soundEnabled) {
				User.soundOn(false);
			}
		}

		public function showReductionWind():void
		{
			trace('showReductionWind');
		}

		public function updateNetworkStatus(lagValue:int):void 
		{
			trace('updateNetworkStatus: ' + lagValue);
		}

		public function showBadNetworkWind(show:Boolean = true):void
		{
			trace('showBadNetworkWind: ' + show);
			if(show)
			{
				//when true we show info for lost connection
//				windowRetry.updateText("Ping Problem");
//				if (!Domino.STAGE.contains(windowRetry))
//				{
//					Domino.STAGE.addChild(windowRetry);
//				}
//				if(User.soundEnabled)
//				{
//					User.soundOn(false);
//				}
			}
			else
			{
				//connection restore
				if (Joker.STAGE.contains(windowRetry))
				{
					Joker.STAGE.removeChild(windowRetry);
				}
				if(!User.soundEnabled)
				{
					User.soundOn(true);
				}
			}
		}

		public function showLostWind():void
		{
			trace('showLostWind');
		}
		
	}

}