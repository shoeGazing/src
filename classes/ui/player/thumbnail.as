﻿package ui.player  {
	import flash.display.*;
	import flash.events.*;
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import fl.controls.Slider;
	import fl.events.*;
	import fl.controls.*;
	import flash.text.*;
	public class thumbnail extends Sprite {
        private var preview: Loader;
		private var _thumbnailNum: Number;
		private var _index:int;
		private var _width:Number;
		private  var _quickModeDuration:int;
		private var _player:Object;
		public function thumbnail(thumbnailNum: Number,index:int,width:Number,quickModeDuration:int,player:Object) {
			_thumbnailNum = thumbnailNum;
			_index = index;
			_width=width;
			_quickModeDuration=quickModeDuration;
			_player=player;
			preview = new Loader();
			if (_thumbnailNum > 0) {
					preview.load(new URLRequest("videoimage/" + (_thumbnailNum + _index*2) + ".png"));
				} else {
					preview.load(new URLRequest("videoimage/" + (_index + 1) + ".png"));
				}
			preview.contentLoaderInfo.addEventListener(Event.COMPLETE,
				function thumbnailFinishedLoading(e: Event): void {
					preview.content.width = width / _quickModeDuration;
					preview.content.height = width / _quickModeDuration / 16 * 9;
					preview.content.y = _player.y + _player.height + 5;
					preview.content.x = _player.x + width / _quickModeDuration*_index;
					addChild(preview.content);
				});		
		}

	}
	
}
