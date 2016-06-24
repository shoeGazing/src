package ui.player {

	import events.EventConstants;
	import events.PlayerBarEvent;
	import data.Video;
	import flash.display.*;
	import flash.geom.Point;
	import flash.events.*;
	import fl.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	//import flash.text.TextField;
	//import flash.text.AntiAliasType;
	import flash.text.*;
	//import fl.controls.Button;
	//import fl.controls.TextInput;
	import fl.controls.Slider;

	public class PlayerBar extends Sprite {

		private static const SEEKBAR_HEIGHT = 8;
		//private static const TOOLBAR_HEIGHT = 36;    //replace the toolbar with youtube style
		//	public static const PLAYERBAR_HEIGHT = SEEKBAR_HEIGHT + TOOLBAR_HEIGHT;

		private var _width: Number;

		private var playButton: Loader;
		private var fullScreenButton: Loader;
		//private var seekPoint: Loader;
		private var seekPoint: Sprite; //draw my own seekpoint instead of loading an existing one
		//private var pointer:Loader;
		private var timeLabel: TextField;
		private var tf: TextFormat;

		//private var toolbar: Sprite;
		private var seekbar: Sprite;
		private var _video: Video;
		private var currentPlayTime: Number;
		private var totalPlayTime: Number;
		//private var _tagButton:Button;
		//private var _textInput:TextInput;

		//private var _barCollection: Array;    //tacon bar collection
		//private var _iconCollection: Array;   //tacon icon collection

		//private var _slider: Slider;         //slider for automatic detection
		//private var _overviewIcon: Loader;   //tacon overview icon
		//private var slider: Slider;
		private var tagIcon: Loader; //icon for tagging


		public function PlayerBar(video: Video, width: Number, totalTime: Number): void {

			_video = video;
			totalPlayTime = totalTime;
			currentPlayTime = 0;
			_width = width;

			/*toolbar = new Sprite();
			toolbar.graphics.beginFill(0x1b1b1b1b);
			toolbar.graphics.drawRect(0, 4, width, TOOLBAR_HEIGHT);
			toolbar.graphics.endFill();
			addChild(toolbar);*/

			seekbar = new Sprite();
			seekbar.graphics.beginFill(0x777777);
			seekbar.graphics.drawRect(0, 0, width, SEEKBAR_HEIGHT * width / 960);
			seekbar.graphics.endFill();
			seekbar.addEventListener(MouseEvent.CLICK, seekbar_click);
			// to show the seekpoint when house over seekbar but this is confilcting with seeking along the seekbar, so solution needed.
			/*seekbar.addEventListener(MouseEvent.ROLL_OVER, show_seekpointer);
			seekbar.addEventListener(MouseEvent.ROLL_OUT, hide_seekpointer);*/
			addChild(seekbar);
			/*_barCollection = new Array();
			for (var i:int =1; i<6; i++){
				_barCollection[i] =  new Sprite();
				_barCollection[i].graphics.beginFill(0x777777);
				_barCollection[i].graphics.drawRect(0,27*(i-1),width, SEEKBAR_HEIGHT);
				_barCollection[i].graphics.endFill();
				//addChild(barCollection[i]);
			}*/
			//_barCollection = new Array();
			//for (var i: int = 1; i < 6; i++) {
			//	_barCollection[i] = new Slider;
			//	_barCollection[i].width = width;
			//	Sprite(_barCollection[i].getChildAt(0)).height = 8;
			//	_barCollection[i].snapInterval = 0;
			//	_barCollection[i].tickInterval = 100;
			//	_barCollection[i].maximum = 100;
			//	_barCollection[i].minimum = 0;
			//	_barCollection[i].value = 0;
			//	_barCollection[i].move(0, 27 * (i - 1) + 50);
			//	_barCollection[i].addEventListener(SliderEvent.CHANGE, thumb_Drag);
			//	_barCollection[i].addEventListener(SliderEvent.THUMB_PRESS, thumb_Press);
			//	_barCollection[i].addEventListener(SliderEvent.THUMB_RELEASE, thumb_Release);
			//	_barCollection[i].liveDragging = true;
			//	//_barCollection[i].removeChildAt(1);			
			//}

			/* bar collection arrray */
			/*_barCollection = new Array();
			for (var i: int = 1; i < 6; i++) {
				_barCollection[i] = new Sprite();
				_barCollection[i].graphics.beginFill(0x777777);
				_barCollection[i].graphics.drawRect(0, 27 * (i - 1) + 100, width, SEEKBAR_HEIGHT);
				_barCollection[i].graphics.endFill();
			}*/

			/*icon collection array*/
			/*_iconCollection = new Array();
			for (var j: int = 1; j < 6; j++) {
				_iconCollection[j] = new Loader();
				_iconCollection[j].load(new URLRequest("uiimage/icon" + j + ".png"));
				_iconCollection[j].x = -48;
				_iconCollection[j].y = -15 + 30 * (j - 1) + 100;

				//addChild(iconCollection[j]);
			}*/

			/* pointer to edit the interval selected*/
			/*pointer = new Loader();
			pointer.load(new URLRequest("uiimage/icon6.jpeg"));
			pointer.x = -7;*/


			playButton = new Loader();
			playButton.load(new URLRequest("uiimage/play.png"));
			playButton.y = SEEKBAR_HEIGHT * width / 960 + 4; //the graphic is 24 pixels
			playButton.addEventListener(MouseEvent.CLICK, playButtonPressed);
			addChild(playButton);

			fullScreenButton = new Loader();
			fullScreenButton.load(new URLRequest("uiimage/open.png"));
			fullScreenButton.y = SEEKBAR_HEIGHT * width / 960 + 4;
			fullScreenButton.x = width - 30;
			fullScreenButton.addEventListener(MouseEvent.CLICK, fullScreenButtonPressed);
			addChild(fullScreenButton);
			/*overview icon to be added to the toolbar*/
			/*_overviewIcon = new Loader();
			_overviewIcon.load(new URLRequest("uiimage/icon7.PNG"));
			_overviewIcon.y = SEEKBAR_HEIGHT;
			_overviewIcon.x = 800;
			_overviewIcon.addEventListener(MouseEvent.CLICK, overviewIconPressed);
			addChild(_overviewIcon);*/

			tagIcon = new Loader();
			tagIcon.load(new URLRequest("uiimage/tag.PNG"));
			tagIcon.y = SEEKBAR_HEIGHT * width / 960 + 3;
			tagIcon.x = width - 70;
			tagIcon.addEventListener(MouseEvent.CLICK, tagIconPressed);
			addChild(tagIcon);

			/*seekPoint = new Loader();
			seekPoint.load(new URLRequest("uiimage/seekPoint.png"));
			seekPoint.y = -8;
			seekPoint.mouseEnabled = false;
			seekPoint.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);*/
			seekPoint = new Sprite();
			seekPoint.graphics.beginFill(0xff0000);
			seekPoint.graphics.drawCircle(0, SEEKBAR_HEIGHT * width / 960 / 2, width / 960 * 7);
			seekPoint.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			seekbar.addChild(seekPoint);
			/*seeker = new Loader();
			seeker.load(new URLRequest("uiimage/icon6.jpeg"));
			seeker.y = 120;
			seeker.addEventListener(MouseEvent.MOUSE_DOWN, beginDrag);
			seeker.contentLoaderInfo.addEventListener(Event.COMPLETE,
				function seekerFinishedLoading(e: Event): void {
					graphics.beginFill(0xff00ff, 0);
					graphics.drawRect(0, 0, width, height);
					graphics.endFill();
				});
			addChild(seeker);*/ //1. the seeker is within playerbar, so the player bar is consisted of seeker and tool/seekbar;
			//2. the seeker needs time to load and then changes the size of the whole playerbar;

			//graphics.beginFill()
			timeLabel = new TextField();
			timeLabel.text = "00:00 / " + timeInSecondsToTimeString(totalTime);
			timeLabel.textColor = 0xffffff;
			timeLabel.width = 200;
			timeLabel.x = 50; // uiimage/play.png is 44 pixels wide
			timeLabel.y = SEEKBAR_HEIGHT * width / 960 + 8;
			timeLabel.mouseEnabled = false;
			tf = new TextFormat();
			tf.font = "Verdana";
			tf.size = 15;
			tf.align = TextFormatAlign.CENTER;
			timeLabel.defaultTextFormat = tf;
			timeLabel.embedFonts = true;
			timeLabel.antiAliasType = AntiAliasType.ADVANCED;
			addChild(timeLabel);
			/*slider for automatic interval detection according to watching behaviors*/
			/*slider = new Slider();
			slider.width = width / 4;
			slider.tickInterval = 30;
			slider.maximum = 36;
			slider.minimum = 6;
			slider.value = 2;
			slider.move(580, SEEKBAR_HEIGHT + 15);
			slider.addEventListener(SliderEvent.CHANGE, test);//when modify the position of slider, determine the length of the interval
			slider.addEventListener(SliderEvent.THUMB_PRESS, thumb_Press); //when press the thumb of slider, the interval before removed
			addChild(slider);*/

			/*_tagButton = new Button();
			_tagButton.label = "+Tag";
			_tagButton.width = 50;
			_tagButton.x = 665; // uiimage/play.png is 44 pixels wide
			_tagButton.y = SEEKBAR_HEIGHT+8;
			_tagButton.enabled = false;
			_tagButton.addEventListener(MouseEvent.CLICK, tagButton_click);
			addChild(_tagButton);*/

			/*_textInput = new TextInput();
			_textInput.width = 144;
			_textInput.x = _tagButton.x - _textInput.width-5;
			_textInput.y = SEEKBAR_HEIGHT+8;
			_textInput.addEventListener(Event.CHANGE, textEntered);
			addChild(_textInput);*/
			setPlayTime(0);


		}

		public function resize(width: Number, time: Number): void {
			_width = width;
			seekbar.graphics.clear();
			seekbar.graphics.beginFill(0x777777);
			seekbar.graphics.drawRect(0, 0, width, SEEKBAR_HEIGHT * width / 960);
			seekbar.graphics.endFill();
			seekbar.graphics.beginFill(0xff0000);
			seekbar.graphics.drawRect(0, 0, time / _video.duration * _width, SEEKBAR_HEIGHT * width / 960);
			playButton.y = SEEKBAR_HEIGHT * width / 960 + 4;
			tagIcon.y = SEEKBAR_HEIGHT * width / 960 + 3;
			tagIcon.x = width - 70;
			seekPoint.graphics.clear();
			seekPoint.graphics.beginFill(0xff0000);
			seekPoint.graphics.drawCircle(0, SEEKBAR_HEIGHT * width / 960 / 2, width / 960 * 7);
			seekPoint.x = time / totalPlayTime * _width;
			timeLabel.y = SEEKBAR_HEIGHT * width / 960 + 8;
			fullScreenButton.y = SEEKBAR_HEIGHT * width / 960 + 4;
			fullScreenButton.x = width - 30;

		}

		public function playVideo(): void {
			playButton.load(new URLRequest("uiimage/pause.png"));
		}

		public function pauseVideo(): void {
			playButton.load(new URLRequest("uiimage/play.png"));
		}
		public function fullScreen(): void {
			fullScreenButton.load(new URLRequest("uiimage/close.png"));
		}
		public function defaultScreen(): void {
			fullScreenButton.load(new URLRequest("uiimage/open.png"));
		}

		public function setPlayTime(timeX: Number): void {
			currentPlayTime = timeX;
			timeLabel.text = timeInSecondsToTimeString(timeX) + " / " + timeInSecondsToTimeString(_video.duration);
			seekPoint.x = currentPlayTime / totalPlayTime * _width;
			/*seekbar process indication*/
			seekbar.graphics.clear();
			seekbar.graphics.beginFill(0x777777);
			seekbar.graphics.drawRect(0, 0, _width, SEEKBAR_HEIGHT * width / 960);
			seekbar.graphics.endFill();
			seekbar.graphics.beginFill(0xff0000);
			seekbar.graphics.drawRect(0, 0, currentPlayTime / _video.duration * _width, SEEKBAR_HEIGHT * width / 960);
		}

		/*public function get iconCollection(): Array {
			return _iconCollection;       //make private array public to be used in Player file
		}*/

		/*public function get barCollection(): Array {
			return _barCollection;      //make private array public to be used in Player file
		}*/

		static public function timeInSecondsToTimeString(timeX: Number): String {
			var newMinutes: String = Math.floor(timeX / 60).toString();
			newMinutes = newMinutes.length == 1 ? "0" + newMinutes : newMinutes;
			var newSeconds: String = Math.floor(timeX % 60).toString();
			newSeconds = newSeconds.length == 1 ? "0" + newSeconds : newSeconds;
			return newMinutes + ":" + newSeconds;
		}

		/*public function get textInput():TextInput{
			return _textInput;
		}*/

		public function get _seekbar(): Sprite {
			return seekbar;
		}

		public function get _seekPoint(): Sprite {
			return seekPoint;
		}

		public function get _playButton(): Loader {
			return playButton;
		}

		/*public function get overviewIcon(): Loader {
			return _overviewIcon;       //make private overviewIcon public to be used in Player file
		}*/

		public function get _timeLabel(): TextField {
			return timeLabel;
		}

		/*public function get _toolbar(): Sprite {
			return toolbar;            //make public to be used in Player file
		}*/

		/*public function get _slider(): Slider {
			return slider;            //make public to be used in Player file
		}*/

		public function get _tagIcon(): Loader {
			return tagIcon;
		}
		
		public function get _tf(): TextFormat{
			return tf;
		}

		/*public function get _pointer():Loader{
			return pointer;
		}*/

		/*private function show_seekpointer(e: MouseEvent): void {
			seekbar.addChild(seekPoint);
		}
		private function hide_seekpointer(e: MouseEvent): void {
			seekbar.removeChild(seekPoint);
		}*/
		private function mouseDown(e: MouseEvent): void {
			//seekbar.removeEventListener(MouseEvent.ROLL_OUT, hide_seekpointer);
			dispatchEvent(new PlayerBarEvent(PlayerBarEvent.SEEKMOVE, mouseX));
		}

		private function playButtonPressed(e: Event): void {
			dispatchEvent(new Event(EventConstants.PlayerBarEventPlay));
		}
		
		private function fullScreenButtonPressed(e: Event): void {
			dispatchEvent(new Event(EventConstants.FullScreenModeEvent));
		}

		private function tagIconPressed(e: Event): void {
			dispatchEvent(new Event(EventConstants.TagIconPressed));
		}

		/*private function overviewIconPressed(e: Event): void {
			dispatchEvent(new Event(EventConstants.OverviewIconPressed));   //overviewIcon event function
		}*/

		private function seekbar_click(e: MouseEvent): void {
			dispatchEvent(new PlayerBarEvent(PlayerBarEvent.SEEK, e.localX / _width * totalPlayTime));
		}

		/*private function test(e: SliderEvent): void {
			dispatchEvent(new PlayerBarEvent(PlayerBarEvent.CHANGE, e.value));   //value of the slider position
		}*/

		/*private function thumb_Press(e: SliderEvent): void {
			dispatchEvent(new PlayerBarEvent(PlayerBarEvent.THUMB_PRESS, e.value)); //I suppose the value is not used 
		}*/


		/*private function thumb_Drag(e: SliderEvent): void {
			dispatchEvent(new PlayerBarEvent(PlayerBarEvent.THUMB, e.value / 100 * totalPlayTime));
		}

		private function thumb_Press(e: SliderEvent): void {
			dispatchEvent(new PlayerBarEvent(PlayerBarEvent.THUMBPRESS, e.value / 100 * _width));
		}

		private function thumb_Release(e: SliderEvent): void {
			dispatchEvent(new PlayerBarEvent(PlayerBarEvent.THUMBRELEASE, e.value / 100 * _width));
		}*/

		/*private function tagButton_click(e:MouseEvent):void{
			dispatchEvent(new PlayerBarEvent(PlayerBarEvent.TAG,currentPlayTime));
		}*/

		/*private function textEntered(e:Event):void{
			if (_textInput.text != ""){
				_tagButton.enabled = true;
			}
			else{
			   _tagButton.enabled = false;	
			}
	}*/

	}
}