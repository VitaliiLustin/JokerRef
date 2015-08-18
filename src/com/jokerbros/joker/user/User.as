package  com.jokerbros.joker.user
{
	
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	/**
	 * ...
	 * @author 13
	 */
	public class User
	{
		public static var soundEnabled:Boolean = false;
		
		public static var username:String = '';
		public static var rating:String = '';
		public static var pin:String = '';
		public static var balance:Number = 0;
		public static var tableID:String = '';
		
		
		public static var gameType:int = 0;
		public static var bet:int
		
		
		public static var iscreator:Boolean = false;
		
		public static var isMute:Boolean = false;
		
		public static var myIndex:int;		
		public static var ReleaseVersion:String = '218'; // + black list / update info bar/ start cash game
		
		public function User() 
		{
			
		}
		
		public static function soundOn(param:Boolean=true):void
		{
			if (param == true) SoundMixer.soundTransform = new SoundTransform(0.25);
			else	SoundMixer.soundTransform = new SoundTransform(0.0); 
		}
	}

}