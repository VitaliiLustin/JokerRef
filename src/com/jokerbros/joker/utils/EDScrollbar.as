package com.jokerbros.joker.utils 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import flash.display.Stage;
	import flash.events.Event;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class EDScrollbar extends MovieClip
	{
		/*
		Variables
		*/
		
		//Movieclips
		
		public var mcTrack:MovieClip;
		private var thisDrag:MovieClip;
		private var thisBG:MovieClip;	
		
		
		/*
		mcUpLeft & mcDownRight refer to the arrows.
		If its "verticle" then "mcUpLeft & mcDownRight" would really be "Up & Down"
		If its "horizontal" then "mcUpLeft & mcDownRight" would really be "Left & Right"
		*/
		public var mcUpLeft:MovieClip; 
		public var mcDownRight:MovieClip; 
		
		//Functions
		private var _funcUpdater:Function;
		
		//Timers
		private var _objTimer:Timer; //only used if you use arrows
		
		//Booleans
		private var _bolUseArrows:Boolean;
		private var _bolArrowDir:int;
		private var _bolVertical:Boolean;
		
		//Numbers
		private var _numDragSetMouseY:Number=0;
		private var _numDragSetMouseX:Number=0;
		private var _numPercent:Number=0;
		private var _numArrowIncDecAmt:Number;
		
		private var _stage:Stage;
		
		/*
		Constructor
		*/
		
		public function EDScrollbar(s:Stage)
		{
			super();
			_stage = s;
			this.mcUpLeft = new MovieClip();
			this.mcDownRight = new MovieClip();
		}
		

		
		
		public function initialize($updater:Function,$vertical:Boolean=true,$arrows:Boolean=true,$arrowSpeed:Number=1):void{
			this._funcUpdater = $updater;
			this._bolVertical = $vertical;
			this._bolUseArrows = $arrows;
			this._numArrowIncDecAmt = $arrowSpeed;
			
			this.setupPaths();
			this.setupDefaults();
			this.setupTrackActions();
			this.setupDragActions();
			
			if(this._bolUseArrows){
				this.setupArrows();
			}else{
				this.mcUpLeft.visible=false;
				this.mcDownRight.visible=false;
			}
		}
		/*
		Setup
		*/
		private function setupPaths():void{
			this.thisBG = this.mcTrack.mcBG;
			this.thisDrag = this.mcTrack.mcDrag;
		}
		private function setupDefaults():void{
			
		}
		private function setupTrackActions():void{
			this.thisBG.buttonMode=true;
			this.thisBG.addEventListener(MouseEvent.MOUSE_DOWN, this.onTrackDown);
			this.thisBG.addEventListener(MouseEvent.MOUSE_UP, this.onTrackUp);				
		}
		private function setupDragActions():void{
			this.thisDrag.buttonMode=true;
			this.thisDrag.addEventListener(MouseEvent.MOUSE_DOWN, this.onDragDown);
			this.thisDrag.addEventListener(MouseEvent.MOUSE_UP, this.onDragUp);			
		}
		
		private function setupArrows():void{	
			
			this.mcDownRight.buttonMode=true;
			this.mcDownRight.dir = 1;
			this.mcDownRight.addEventListener(MouseEvent.MOUSE_DOWN, this.onArrowDown);		
			this.mcDownRight.addEventListener(MouseEvent.MOUSE_UP, this.onArrowUp);		
			
			this.mcUpLeft.buttonMode=true;
			this.mcUpLeft.dir = -1;
			this.mcUpLeft.addEventListener(MouseEvent.MOUSE_DOWN, this.onArrowDown);		
			this.mcUpLeft.addEventListener(MouseEvent.MOUSE_UP, this.onArrowUp);	
			
			//Timer ONLY needed if using arrows
			this._objTimer = new Timer(10);
			this._objTimer.addEventListener(TimerEvent.TIMER, this.onTimerTrigger);
		}
			
		
		/*
		Reset
		*/
		public function reset($bolRunUpdateFunc:Boolean=true):void{			
			if (!_bolVertical) this.moveDragToX(0,0);
			else this.moveDragToY(0,0);	
			
			this._numPercent = 0;
			if($bolRunUpdateFunc){
				this._funcUpdater(0);
			}
		}
		
		/*
		Clearing
		*/
		public function clear():void{
			this.thisBG.removeEventListener(MouseEvent.MOUSE_DOWN, this.onTrackDown);
			this.thisBG.removeEventListener(MouseEvent.MOUSE_UP, this.onTrackUp);	
			
			this.thisDrag.removeEventListener(MouseEvent.MOUSE_DOWN, this.onDragDown);
			this.thisDrag.removeEventListener(MouseEvent.MOUSE_UP, this.onDragUp);		
			
			if(this._bolUseArrows){
				this._objTimer.stop();
				this._objTimer.removeEventListener(TimerEvent.TIMER, this.onTimerTrigger);
				this._objTimer = null;
				
				this.mcDownRight.removeEventListener(MouseEvent.MOUSE_DOWN, this.onArrowDown);		
				this.mcDownRight.removeEventListener(MouseEvent.MOUSE_UP, this.onArrowUp);		
				
				this.mcUpLeft.removeEventListener(MouseEvent.MOUSE_DOWN, this.onArrowDown);		
				this.mcUpLeft.removeEventListener(MouseEvent.MOUSE_UP, this.onArrowUp);		
			}			
		}
		
		
		/*
		ADDING / REMOVING of Listeners
		*/
		private function addStageUpTrack():void{
			this._stage.addEventListener(MouseEvent.MOUSE_UP, this.onStageUpTrack);
			this._stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onStageMoveTrack);
			this.calculateWithTrack();
		}
		private function removeStageUpTrack():void{
			this._stage.removeEventListener(MouseEvent.MOUSE_UP, this.onStageUpTrack);
			this._stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onStageMoveTrack);			
		}
		
		private function addStageUpDrag():void{
			this._stage.addEventListener(MouseEvent.MOUSE_UP, this.onStageUpDrag);
			this._stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onStageMoveDrag);
		}
		private function removeStageUpDrag():void{
			this._stage.removeEventListener(MouseEvent.MOUSE_UP, this.onStageUpDrag);
			this._stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onStageMoveDrag);			
		}
		
		private function addStageUpArrow():void{
			this._stage.addEventListener(MouseEvent.MOUSE_UP, this.onStageUpArrow);
		}
		private function removeStageUpArrow():void{
			this._stage.removeEventListener(MouseEvent.MOUSE_UP, this.onStageUpArrow);			
		}
		
		/*
		Proportion Calculations
		*/
		
		private function calculateWithTrack():void{				
			var numPercent:Number;
			
			if(this._bolVertical){
				var numHeightDifference:Number = this.thisBG.height-this.thisDrag.height;
				
				var numDragY:Number = this.thisBG.mouseY-Math.round(this.thisDrag.height/2);
				numDragY = (numDragY<0)?0:numDragY;
				numDragY = (numDragY>numHeightDifference)?numHeightDifference:numDragY;
				this.moveDragToY(numDragY);
				numPercent = Math.round((numDragY/numHeightDifference)*100)/100;
			}else{
				var numWidthDifference:Number = this.thisBG.width-this.thisDrag.width;
				
				var numDragX:Number = this.thisBG.mouseX-Math.round(this.thisDrag.width/2);
				numDragX = (numDragX<0)?0:numDragX;
				numDragX = (numDragX>numWidthDifference)?numWidthDifference:numDragX;
				this.moveDragToX(numDragX);
				numPercent = Math.round((numDragX/numWidthDifference)*100)/100;				
			}			
					
			this.update(numPercent);
		}
		
		private function calculateWithDrag():void{	
			var numPercent:Number;
			
			if(this._bolVertical){
				var numHeightDifference:Number = this.thisBG.height-this.thisDrag.height;
				
				var numDragY:Number = this.thisBG.mouseY-this._numDragSetMouseY;		
				numDragY = (numDragY<0)?0:numDragY;
				numDragY = (numDragY>numHeightDifference)?numHeightDifference:numDragY;
				this.moveDragToY(numDragY);
				
				numPercent = Math.round((numDragY/numHeightDifference)*100)/100;	
			}else{
				var numWidthDifference:Number = this.thisBG.width-this.thisDrag.width;
				
				var numDragX:Number = this.thisBG.mouseX-this._numDragSetMouseX;		
				numDragX = (numDragX<0)?0:numDragX;
				numDragX = (numDragX>numWidthDifference)?numWidthDifference:numDragX;
				this.moveDragToX(numDragX);
				
				numPercent = Math.round((numDragX/numWidthDifference)*100)/100;	
			}
					
			this.update(numPercent);
		}
		
		private function calculateWithArrows($inc:Number):void{			
			var numPercent:Number;
			
			if(this._bolVertical){
				var numHeightDifference:Number = this.thisBG.height-this.thisDrag.height;
				var numY:Number = this.thisDrag.y;
				numY = (this._bolArrowDir==1)?(numY+$inc):(numY-$inc);
				numY = (numY<0)?0:numY;
				numY = (numY>numHeightDifference)?numHeightDifference:numY;
				
				this.thisDrag.y = numY;
				numPercent = Math.round((numY/numHeightDifference)*100)/100;
			}else{
				var numWidthDifference:Number = this.thisBG.width-this.thisDrag.width;
				var numX:Number = this.thisDrag.x;
				numX = (this._bolArrowDir==1)?(numX+$inc):(numX-$inc);				
				numX = (numX<0)?0:numX;
				numX = (numX>numWidthDifference)?numWidthDifference:numX;
				
				this.thisDrag.x = numX;
				numPercent = Math.round((numX/numWidthDifference)*100)/100;
			}
			this.update(numPercent);
		}
		
		/*
		Visual Updates
		*/
		
		private function moveDragToY($value:Number,$speed:Number = 0.4):void{
			TweenMax.to(this.thisDrag, $speed, {y:$value, ease:Expo.easeOut});
		}
		private function moveDragToX($value:Number,$speed:Number = 0.4):void{
			TweenMax.to(this.thisDrag, $speed, {x:$value, ease:Expo.easeOut});
		}		
		
		/*
		Prevents unneccessary updating
		*/
		private function update($percent:Number):void{
			if(this._numPercent!=$percent){
				this._numPercent = $percent;
				this._funcUpdater($percent);
			}
		}
		
		/*
		DRAG Mouse Event Handlers
		*/
		
		private function onDragDown($event:MouseEvent):void{
			if(this._bolVertical){
				this._numDragSetMouseY = this.thisDrag.mouseY;				
			}else{
				this._numDragSetMouseX = this.thisDrag.mouseX;				
			}
			this.addStageUpDrag();
		}
		private function onDragUp($event:MouseEvent=null):void{
			this.removeStageUpDrag();
		}		
		private function onStageUpDrag($event:MouseEvent):void{
			this.onDragUp();
		}
		private function onStageMoveDrag($event:MouseEvent):void{
			this.calculateWithDrag();
		}
		
		/*
		TRACK Mouse Event Handlers
		*/
		
		private function onTrackDown($event:MouseEvent):void{
			this.addStageUpTrack();
		}
		private function onTrackUp($event:MouseEvent=null):void{
			this.removeStageUpTrack();
		}		
		private function onStageUpTrack($event:MouseEvent):void{
			this.onTrackUp();
		}		
		private function onStageMoveTrack($event:MouseEvent):void{
			this.calculateWithTrack();
		}
		
		/*
		ARROW Mouse Event Handlers
		*/
		
		private function onArrowDown($event:MouseEvent):void{
			var numDir:int = $event.target.dir;
			this._bolArrowDir = numDir;
			TweenMax.delayedCall(.2, this._objTimer.start);
			this.addStageUpArrow();
			this.calculateWithArrows(this._numArrowIncDecAmt*2);
		}
		private function onArrowUp($event:MouseEvent=null):void{
			TweenMax.killDelayedCallsTo(this._objTimer.start);
			this.removeStageUpArrow();
			this._objTimer.stop();			
		}
		private function onStageUpArrow($event:MouseEvent):void{
			this.onArrowUp();
		}		
		
		/*
		Timer Event Handlers
		*/
		private function onTimerTrigger($event:TimerEvent):void{
			this.calculateWithArrows(this._numArrowIncDecAmt);
		}
		
	}

}