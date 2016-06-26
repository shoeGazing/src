package ui {

	import flash.display.*;
	import flash.events.*;
	import flash.system.Capabilities;

	import data.Video;
	import ui.player.Player;
    [SWF(width="1600", height="900", backgroundColor="0x777777", frameRate="30")]
	public class VideoTag extends Sprite {
		private var _player: Player;
		private var videos: Array;

		public function VideoTag() {
			videos = new Array();
			videos.push(new Video(0, "videos/Philosophy.mp4", "Philosophy", "Philosophy", 582));//323 is the length of the video
			//_player.player.load("videos/Google I-O.mp4");
			_player = new Player(videos[0]);
			//  _player.player.load(videos[0].filename);
			//_player.player.source = "videos/Google I-O.mp4"; will play automatically
			addChild(_player);
			//stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode=StageScaleMode.EXACT_FIT;
			//stage.scaleMode=StageScaleMode.NO_BORDER;
			//stage.scaleMode=StageScaleMode.NO_SCALE;   //for 1280X720 and _player.x = (1600-PLAYER_WIDTH)/2;_player.y = (900-PLAYER_HEIGHT)/2;
			stage.scaleMode=StageScaleMode.SHOW_ALL;    //for 960X540
			//trace(flash.system.Capabilities.screenResolutionX);

		}
	}

}