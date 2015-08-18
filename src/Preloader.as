package 
{
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.utils.getDefinitionByName;

/**
 * ...
 * @author 13
 */
public class Preloader extends MovieClip
{
	private static var _stageBG:mcStageBackground;
	private static var _preloader:MovieClip;

	public function Preloader()
	{
		_preloader = new mcPreloader();
		_stageBG = new mcStageBackground();

		if (stage) {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, this.preloaderResize);
		}
		addEventListener(Event.ENTER_FRAME, checkFrame);
		loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
		loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);

		// TODO show loader

		addChild(_stageBG);
		addChild(_preloader);

		preloaderResize(null);
	}

	private function preloaderResize(e:Event = null):void
	{
		if (_preloader != null)
		{
			_preloader.x = stage.stageWidth / 2;
			_preloader.y = stage.stageHeight / 2;
		}
	}

	public static function hide():void
	{
		if(_preloader && _stageBG)
		{
			_preloader.visible = false;
		}
	}

	private function ioError(e:IOErrorEvent):void
	{
		trace(e.text);
	}

	private function progress(e:ProgressEvent):void
	{
		// TODO update loader
		var percent:int = (e.currentTarget.bytesLoaded/e.currentTarget.bytesTotal)*100;
		_preloader.status.text = percent.toString() + ' %';
	}

	private function checkFrame(e:Event):void
	{
		if (currentFrame == totalFrames)
		{
			stop();
			loadingFinished();
		}
	}

	private function loadingFinished():void
	{
		removeEventListener(Event.ENTER_FRAME, checkFrame);
		loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
		loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);

		// TODO hide loader
		_preloader.status.text = 'Please Wait...';
		startup();
	}

	private function startup():void
	{
		var mainClass:Class = getDefinitionByName("Joker") as Class;
		addChild(new mainClass() as DisplayObject);
	}
}
}