package com.jokerbros.joker.utils 
{
	/**
	 * ...
	 * @author Nika
	 */
	public class TyniHelper 
	{
		
		private static var months:Array = ["იანვარი", "თებერვალი", "მარტი", "აპრილი", "მაისი", "ივნისი", "აგვისტო", "სექტემბერი", "ოქტომბერი", "ნოემბერი", "დეკემბერი"];
		private static var days:Array = ["დღეს", "ხვალ", "ზეგ"];
		
		public function TyniHelper() 
		{
			
		}
		
		public function convertToMMSS($seconds:Number):String
		{
			var s:Number = $seconds % 60;
			var m:Number = Math.floor(($seconds % 3600 ) / 60);
			 
			var minuteStr:String = doubleDigitFormat(m) + ":";
			var secondsStr:String = doubleDigitFormat(s);
			 
			return  minuteStr + secondsStr;
		}
		
		public function convertToHHMMSS($seconds:Number):String
		{
			var s:Number = $seconds % 60;
			var m:Number = Math.floor(($seconds % 3600 ) / 60);
			var h:Number = Math.floor($seconds / (60 * 60));
			 
			var hourStr:String = (h == 0) ? "00:" : doubleDigitFormat(h) + ":";
			var minuteStr:String = doubleDigitFormat(m) + ":";
			var secondsStr:String = doubleDigitFormat(s);
			 
			return hourStr + minuteStr + secondsStr;
		}
 
		public function convertToHHMM($seconds:Number):String
		{
			var date:Date = new Date($seconds);
			return doubleDigitFormat(date.getHours()) + ":" + doubleDigitFormat(date.getMinutes());
		}
		
		public function convertToDM($seconds:Number):String
		{			
			var date:Date = new Date($seconds);
			return date.getDate() + "-" + TyniHelper.months[date.getMonth()-1];
		}
		
				
		public function convertToDateTourReg($seconds:Number, $currentSeconds:Number):String
		{
			var startDate:Date = new Date($seconds);			
			var currentDate:Date = new Date($currentSeconds);
			
			var dayDiff:int = startDate.getDate() - currentDate.getDate();
			
			var dateString:String = "";
			if (dayDiff >= TyniHelper.days.length)
				dateString = this.convertToDM($seconds); //startDate.getDay() + " " + months[startDate.getMonth()];
			else
				dateString = TyniHelper.days[dayDiff];
			
			return dateString;
		}
		
		
		
		private function doubleDigitFormat($num:uint):String
		{
			if ($num < 10) 
			{
				return ("0" + $num);
			}
			return String($num);
		}
		
		
		public static function sec2Time(second:int):String
		{
			return new TyniHelper().convertToHHMMSS(second);
		}
		
		public static function sec2MMSS(second:int):String
		{
			return new TyniHelper().convertToMMSS(second);
		}
		
		
		
		
		/**
		 * 
		 * @param	second
		 * @return Hourse Minutse: example 19:00
		 */
		public static function sec2HHMM(second:Number):String
		{
			return new TyniHelper().convertToHHMM(second);
		}
		
		
		/**
		 * 
		 * @param	second
		 * @return Day Month example 01-november
		 */
		public static function sec2DM(second:Number):String
		{
			return new TyniHelper().convertToDM(second);
		}
		
		
		/**
		 * 
		 * @param	second
		 * @return Day Month example xval zeg 01-november 
		 */
		public static function sec2DateTourReg(second:Number, currentSeconds:Number):String
		{
			return new TyniHelper().convertToDateTourReg(second, currentSeconds);
		}
		
		
		
		public static function secTest(startSeconds:Number, currentSeconds:Number):String
		{
			
			
			
			
			var startDate:Date = new Date(startSeconds);			
			var currentDate:Date = new Date(currentSeconds);
			
			var dayDiff:int = startDate.getDate() - currentDate.getDate();
			
			var dateString:String = "";
			if (dayDiff > days.length)
				dateString = startDate.getDay() + " " + months[startDate.getMonth()];
			else
				dateString = days[dayDiff];
			
			dateString += " " + startDate.getHours() + ":" + startDate.getMinutes();
				
			
			return dateString;
		}
		
		public static function randomIntBetween(min:int, max:int):int{
				return Math.round(Math.random() * (max - min) + min);
		}
		
		
	}

}