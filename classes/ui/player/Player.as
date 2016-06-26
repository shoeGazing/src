package ui.player {

	import flash.display.*;
	import flash.events.*;
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	import fl.controls.*;
	import flash.text.*;
	import flash.net.*;

	import ui.player.PlayerBar;
	import data.Video;
	import events.EventConstants;
	import events.PlayerBarEvent;
	import ui.player.thumbnail;

	public class Player extends Sprite {

		public static const PLAYER_WIDTH = 960; 
		public static const PLAYER_HEIGHT = 540;

		private var _playerOverlay: Sprite;
		private var _player: Object;
		private var _playerBar: PlayerBar;
		private var _playerBarOverlay:Sprite;
		private var _video: Video;
		private var _lastPlayedTime: Number;
		// tag words Box
		private var boxLine: Sprite;
		private var tagTextFormat: TextFormat;
		private var tagWord: String;
		private var tagWordArray:Array;
		private var tagTileArray: Array;
		private var tagTileArrayFlag:Array;
		private var doneButton: Button;
		private var cancelButton: Button;
		private var backButton: Loader;
		private var backModeDuration: int =5;
		private var backModeFlag:int=0;
		private var playerThumbnail:Loader;
		private var newSeekBar: Sprite;
		private var thumbnailArray:Array;
		private var thumbnailOverlayArray:Array;
		//tag history
		private var tagContainer:Sprite;




		public function Player(video: Video): void {
			_video = video;
			createPlayer();
		}

		private function createPlayer(): void {
			_player = new FLVPlayback();
			_player.width = PLAYER_WIDTH;
			_player.height = PLAYER_HEIGHT;
			_player.x = (1600-PLAYER_WIDTH)/4;
			_player.y = (900-PLAYER_HEIGHT)/9;
			_player.addEventListener(fl.video.VideoEvent.PLAYHEAD_UPDATE, playerUpdate);
		
			addChild(FLVPlayback(_player));
			_player.source = _video.filename;


			_playerOverlay = new Sprite();
			_playerOverlay.graphics.beginFill(0xff0000, 0);
			_playerOverlay.graphics.drawRect(_player.x, _player.y, _player.width, _player.height);
			_playerOverlay.graphics.endFill();
			_playerOverlay.addEventListener(MouseEvent.CLICK, playerClick);
			_playerOverlay.addEventListener(MouseEvent.ROLL_OVER, showPlayerBar);
			_playerOverlay.addEventListener(MouseEvent.ROLL_OUT, hidePlayerBar);
			addChild(_playerOverlay);

			_playerBar = new PlayerBar(_video, (PLAYER_WIDTH-20), _video.duration);
			_playerBar.x = _player.x + 20/2;
			_playerBar.y = _player.y + _player.height - 45; //45 is seekbar height+icon y+icon size
			_playerBar.addEventListener(EventConstants.PlayerBarEventPlay, playVideo);
			_playerBar.addEventListener(PlayerBarEvent.SEEK, playerBarSeek);
			_playerBar.addEventListener(EventConstants.TagIconPressed, showTagWord)
			_playerBar.addEventListener(MouseEvent.ROLL_OVER, showPlayerBarOverlay);
			_playerBar.playVideo();

			_playerBarOverlay = new Sprite();
			_playerBarOverlay.graphics.beginFill(0xff0000, 0);
			_playerBarOverlay.graphics.drawRect(_playerBar.x, _playerBar.y, _playerBar.width-7, _playerBar.height);
			_playerBarOverlay.graphics.endFill();

			boxLine = new Sprite();
			boxLine.graphics.lineStyle(3, 0x000000,.75);
			boxLine.graphics.moveTo(_player.x+_player.width+30,_player.y+_player.height); 
            boxLine.graphics.lineTo(_player.x+_player.width+30+300,_player.y+_player.height);

            tagWord = new String();
            tagWord = "good&like&interesting&happy&bad&amazing&awesome&simple&funny&hate&helpful&nonsense&important&clear&hard&favorite&deep&cool&reasonable&proper&real&pretty&wrong&intelligent&original&factual&accurate&inaccurate&support&believe&+add";
            tagWordArray = new Array();
            tagWordArray = tagWord.split("&");
            tagTextFormat = new TextFormat();
            tagTextFormat.font = "Verdana";
			tagTextFormat.size = 15;
			tagTextFormat.align = TextFormatAlign.CENTER;
            tagTileArray = new Array();
            for (var i:int=0;i<tagWordArray.length;i++){
             tagTileArray[i] = new TextField();
             tagTileArray[i].text = tagWordArray[i];
             tagTileArray[i].textColor = 0x000000
             tagTileArray[i].setTextFormat(tagTextFormat); //for specific texts
			 tagTileArray[i].embedFonts = true;
			 tagTileArray[i].antiAliasType = AntiAliasType.ADVANCED;
			 tagTileArray[i].border =true;
			 tagTileArray[i].background = true;
			 tagTileArray[i].backgroundColor = 0x777777;
			 tagTileArray[i].selectable = false;
			 tagTileArray[i].autoSize = TextFieldAutoSize.CENTER;
			 tagTileArray[i].addEventListener(MouseEvent.CLICK, tagTileClicked);
			if(i%5==0){
			 	 tagTileArray[i].x = _player.x+_player.width+30;
			 	 }else{
			 	 	 tagTileArray[i].x = tagTileArray[i-1].x + tagTileArray[i-1].width+5;
			 	 }
			 if(Math.floor(i/5)==0){
			 	tagTileArray[i].y = _player.y+_player.height+10;
			 }else{
			 	tagTileArray[i].y = tagTileArray[Math.floor(i/5)*5-1].y + tagTileArray[Math.floor(i/5)*5-1].height+5;
			 }	 
            }
            tagTileArrayFlag = new  Array();
            for (var j:int=0;j<tagWordArray.length-1;j++){
             tagTileArrayFlag[j] = 0;
            }
            doneButton = new Button();
            doneButton.x = _player.x+_player.width+30;
            doneButton.y = _player.y+_player.height-25;
            doneButton.height = 20;
            doneButton.width = 80;
            doneButton.label = "Done";
            doneButton.addEventListener(MouseEvent.CLICK, doneClicked);
            cancelButton = new Button();
            cancelButton.x = doneButton.x +300-doneButton.width;
            cancelButton.y = doneButton.y;
            cancelButton.width = doneButton.width;
            cancelButton.height = doneButton.height;
            cancelButton.label = "Cancel";
            cancelButton.addEventListener(MouseEvent.CLICK, cancelClicked);
            backButton = new Loader();   //36 x 31
            backButton.x = doneButton.x + 300/2 -36/2;
            backButton.y = _player.y+_player.height-36;
            backButton.load(new URLRequest("uiimage/backward.PNG"));
            backButton.addEventListener(MouseEvent.CLICK, backClicked);
            playerThumbnail = new Loader();
            newSeekBar = new Sprite();
            thumbnailArray = new Array();
            thumbnailOverlayArray = new Array();
            for (var k:int=0;k<backModeDuration;k++){
				thumbnailOverlayArray[k] = new Sprite();
				addChild(thumbnailOverlayArray[k]);
		}

		tagContainer = new Sprite();
		tagContainer.graphics.beginFill(0x000000, 0.8);
		tagContainer.graphics.drawRect(_player.x, _player.y+_player.height+5, _player.width, (900-_player.height-5- _player.y*2));
		tagContainer.graphics.endFill();
		addChild(tagContainer);
		}

		private function playVideo(e: Event = null): void {
			if (_player.paused) {
				_playerBar.playVideo();
				_player.play();
			} else {
				_playerBar.pauseVideo();
				_player.pause();
			}
		}

		private function playerClick(e: Event = null): void {
			playVideo();
		}

		private function playerUpdate(e: Event = null): void {
			_playerBar.setPlayTime(_player.playheadTime);
		}

		private function playerBarSeek(e: PlayerBarEvent): void {
			_lastPlayedTime = e.time;
			_player.seek(e.time);
			if (e.pause) {
				_player.pause();
			}
		}

		private function  showPlayerBar(e: MouseEvent):void{
			addChild(_playerBar);
			_playerBar.addChild(_playerBarOverlay);
		}

		private function  hidePlayerBar(e: MouseEvent):void{
			removeChild(_playerBar);		
		}

		private function showPlayerBarOverlay(e: MouseEvent):void{
			_playerOverlay.addChild(_playerBarOverlay);
		}

		private function showTagWord(e:Event = null):void{
			addChild(boxLine);
			for (var i:int=0;i<tagWordArray.length;i++){
				    addChild( tagTileArray[i]);
			}
			_playerBar.pauseVideo();
			_player.pause();
			addChild(doneButton);
			addChild(cancelButton);
			addChild(backButton);
			removeChild(tagContainer);
		}

		private function tagTileClicked(e:MouseEvent):void{
			var index: int = tagTileArray.indexOf(e.target);
			if(index < (tagTileArray.length -1) && tagTileArrayFlag[index] ==0){
				tagTileArray[index].backgroundColor = 0x777799;
				tagTileArrayFlag[index] =1;
			}else if(index < (tagTileArray.length -1) && tagTileArrayFlag[index] ==1){
				tagTileArray[index].backgroundColor = 0x777777;
				tagTileArrayFlag[index] =0;
			}else{
				trace("add your tag");
			}
			
		}

		private function doneClicked(e:MouseEvent):void{
			for (var i:int=0;i<tagWordArray.length-1;i++){
				tagTileArray[i].backgroundColor = 0x777777;
				tagTileArrayFlag[i] =0;
			}
			for (var j:int=0;j<tagWordArray.length;j++){
				    removeChild( tagTileArray[j]);
			}
			removeChild(doneButton);
			removeChild(cancelButton);
			removeChild(boxLine);
			removeChild(backButton);
		
			if(backModeFlag>0){
				for (var k:int=_playerOverlay.numChildren-1;k>-1;k--){
				_playerOverlay.removeChildAt(k);
			}
				removeChild(newSeekBar);
					for (var l:int=0;l<backModeDuration;l++){
				for(var m:int=backModeFlag-1;m>-1;m--){
					thumbnailOverlayArray[l].removeChildAt(m);
				}
			}
			}
			_playerBar.playVideo();
			_player.play();
			_playerOverlay.addEventListener(MouseEvent.ROLL_OVER, showPlayerBar);
			_playerOverlay.addEventListener(MouseEvent.ROLL_OUT, hidePlayerBar);
			backModeFlag=0;
			addChild(tagContainer);
		}

		private function cancelClicked(e:MouseEvent):void{
			for (var i:int=0;i<tagWordArray.length-1;i++){
				tagTileArray[i].backgroundColor = 0x777777;
				tagTileArrayFlag[i] =0;
			}
			for (var j:int=0;j<tagWordArray.length;j++){
				    removeChild( tagTileArray[j]);
			}
			removeChild(cancelButton);
			removeChild(doneButton);
			removeChild(boxLine);
			removeChild(backButton);
		
			if(backModeFlag>0){
				for (var k:int=backModeFlag-1;k>-1;k--){
				_playerOverlay.removeChildAt(k);
			}
				removeChild(newSeekBar);
				for (var l:int=0;l<backModeDuration;l++){
				for(var m:int=backModeFlag-1;m>-1;m--){
					thumbnailOverlayArray[l].removeChildAt(m);
				}
			}
			}
			_playerBar.playVideo();
			_player.play();
			_playerOverlay.addEventListener(MouseEvent.ROLL_OVER, showPlayerBar);
			_playerOverlay.addEventListener(MouseEvent.ROLL_OUT, hidePlayerBar);
			backModeFlag=0;
			addChild(tagContainer);
		}

		private function backClicked(e:MouseEvent):void{
			_playerOverlay.removeEventListener(MouseEvent.ROLL_OVER, showPlayerBar);
			_playerOverlay.removeEventListener(MouseEvent.ROLL_OUT, hidePlayerBar);
			if ((_player.playheadTime-(backModeFlag+1)*5)>=0){
				backModeFlag++;
			playerThumbnail.load(new URLRequest("videoimage/"+(Math.floor(_player.playheadTime)-backModeDuration*backModeFlag+1)+".png"));
			playerThumbnail.contentLoaderInfo.addEventListener(Event.COMPLETE,
				function thumbnailFinishedLoading(e: Event): void {
					playerThumbnail.content.width = _player.width;
					playerThumbnail.content.height = _player.height;
					playerThumbnail.content.y = _player.y;
					playerThumbnail.content.x = _player.x;
					_playerOverlay.addChild(playerThumbnail.content);
				});		
			newSeekBar.graphics.clear();
			newSeekBar.graphics.beginFill(0x777777);
			newSeekBar.graphics.drawRect(_playerBar.x, _playerBar.y, PLAYER_WIDTH-20, 8);
			newSeekBar.graphics.endFill();
			newSeekBar.graphics.beginFill(0xff0000);
			newSeekBar.graphics.drawRect(_playerBar.x+(_player.playheadTime-backModeDuration*backModeFlag)/_video.duration*(PLAYER_WIDTH-20), _playerBar.y,backModeDuration*backModeFlag/_video.duration*(PLAYER_WIDTH-20),8);
			addChild(newSeekBar);
			for (var i:int=0;i<backModeDuration;i++){
				thumbnailArray[i] = new thumbnail(Math.floor(_player.playheadTime)-backModeDuration*backModeFlag,i,PLAYER_WIDTH,backModeDuration,_player);
				thumbnailOverlayArray[i].addChild(thumbnailArray[i]);
			}
			}

		}


	}
}

	