package ui.player {

	import flash.display.*;
	import flash.events.*;
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;

	import ui.player.PlayerBar;
	import data.Video;
	import events.EventConstants;
	import events.PlayerBarEvent;

	public class Player extends Sprite {

		public static const PLAYER_WIDTH = 1080;
		public static const PLAYER_HEIGHT = 405;
		public static const PLAYER_X = 100;
		public static const PLAYER_Y = 100;

		private var _playerOverlay: Sprite;
		private var _player: Object;
		private var _playerBar: PlayerBar;
		private var _video: Video;
		private var _lastPlayedTime: Number;

		public function Player(video: Video): void {
			_video = video;
			createPlayer();
		}

		private function createPlayer(): void {
			_player = new FLVPlayback();
			_player.width = PLAYER_WIDTH;
			_player.height = PLAYER_HEIGHT;
			_player.x = PLAYER_X;
			_player.y = PLAYER_Y;
			_player.addEventListener(fl.video.VideoEvent.PLAYHEAD_UPDATE, playerUpdate);
			addChild(FLVPlayback(_player));
			_player.source = _video.filename;

			_playerOverlay = new Sprite();
			_playerOverlay.graphics.beginFill(0xff0000, 0);
			_playerOverlay.graphics.drawRect(_player.x, _player.y, _player.width, _player.height);
			_playerOverlay.graphics.endFill();
			_playerOverlay.addEventListener(MouseEvent.CLICK, playerClick);
			addChild(_playerOverlay);

			_playerBar = new PlayerBar(_video, PLAYER_WIDTH, _video.duration);
			_playerBar.x = _player.x;
			_playerBar.y = _player.y + _player.height + 10;
			_playerBar.addEventListener(EventConstants.PlayerBarEventPlay, playVideo);
			_playerBar.addEventListener(PlayerBarEvent.SEEK, playerBarSeek);
			_playerBar.playVideo();
			addChild(_playerBar);
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
	}
}

	