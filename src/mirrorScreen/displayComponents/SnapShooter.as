package mirrorScreen.displayComponents 
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import mirrorScreen.displayComponents.FlickrBitmap;
	import mirrorScreen.Workers;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class SnapShooter extends Sprite 
	{
		private var data:ByteArray;
		private var imageBytes:ByteArray;
		private var saveImageWorker:Worker;
		private var wtm:MessageChannel;
		private var mtw:MessageChannel;
		private var countDown:CountDown;
		private var flickrBitmap:FlickrBitmap;
		private var timeline:TimelineLite;
		private var _target:DisplayObject;
		private var _imageFileType:String = "PNG";
		private var fileExtension:String;
		private var _imageFileQuality:int = 80;
		private var _prenameOfImage:String = "IMG_";
		private var _storageDir:String;
		private var bitmapData:BitmapData;
		
		public function SnapShooter() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		public function startCount():void {
			countDown.start();
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			countDown = new CountDown();
			countDown.addEventListener(CountDown.COUNT_COMPLETED, onCountCompleted);
			redraw();
			addChild(countDown);
			
			//Save Image Worker
			data = new ByteArray();
			data.shareable = true;
			
			imageBytes = new ByteArray();
			imageBytes.shareable = true;
			
			saveImageWorker = WorkerDomain.current.createWorker(Workers.SaveImageWorker,true);
			wtm = saveImageWorker.createMessageChannel(Worker.current);
			mtw = Worker.current.createMessageChannel(saveImageWorker);
			
			wtm.addEventListener(Event.CHANNEL_MESSAGE, onMessageFromWorker);
			
			saveImageWorker.setSharedProperty("wtm",wtm);
			saveImageWorker.setSharedProperty("mtw", mtw);
			saveImageWorker.setSharedProperty("sourceImage", imageBytes);
			saveImageWorker.setSharedProperty("data", data);
			saveImageWorker.start();
		}
		
		private function onMessageFromWorker(e:Event):void 
		{
			var messageReceived:* = wtm.receive();
			if (messageReceived == "ENCODE_COMPLETED") {
				trace("ENCODE_COMPLETED");
			}
		}
		
		private function onCountCompleted(e:Event):void 
		{
			var targetCopy:BitmapData = new BitmapData(_target.width, _target.height, false);
			targetCopy.draw(_target);
			
			bitmapData = new BitmapData(_target.scrollRect.width, _target.scrollRect.height, false);
			bitmapData.copyPixels(targetCopy, new Rectangle(0,0,_target.scrollRect.width,_target.scrollRect.height), new Point());
			
			flickrBitmap = new FlickrBitmap(bitmapData);
			flickrBitmap.addEventListener(FlickrBitmap.FLICKR_COMPLETED, onFlickrComplete);
			redraw();
			addChild(flickrBitmap);
			flickrBitmap.flickr();
			
			imageBytes.length = 0;
			bitmapData.copyPixelsToByteArray(bitmapData.rect, imageBytes);
			
			if (_imageFileType == "PNG") {
				fileExtension = ".png";
			} else {
				fileExtension = ".jpg";
			}
			
			var commandObj:Object = {
				command:"SAVE_IMAGE",
				width:bitmapData.rect.width,
				height:bitmapData.rect.height,
				encode:_imageFileType,
				quality:_imageFileQuality,
				filename:_prenameOfImage+String(new Date().time + fileExtension),
				dir:_storageDir
			}
			
			mtw.send(commandObj);
		}
		
		private function onFlickrComplete(e:Event):void {
			this.removeChild(FlickrBitmap(e.currentTarget));
		}
		
		public function redraw():void {
			countDown.x = stage.stageWidth / 2;
			countDown.y = stage.stageHeight / 2;
			
			if (flickrBitmap != null) {
				flickrBitmap.height = stage.stageHeight;
				flickrBitmap.scaleX = flickrBitmap.scaleY;
				flickrBitmap.x = stage.stageWidth / 2 - flickrBitmap.width / 2;
				flickrBitmap.y = stage.stageHeight / 2 - flickrBitmap.height / 2;
			}
			
		}
		
		public function get target():DisplayObject 
		{
			return _target;
		}
		
		public function set target(value:DisplayObject):void 
		{
			_target = value;
		}
		
		public function get imageFileType():String 
		{
			return _imageFileType;
		}
		
		public function set imageFileType(value:String):void 
		{
			_imageFileType = value;
		}
		
		public function get imageFileQuality():int 
		{
			return _imageFileQuality;
		}
		
		public function set imageFileQuality(value:int):void 
		{
			_imageFileQuality = value;
		}
		
		public function get prenameOfImage():String 
		{
			return _prenameOfImage;
		}
		
		public function set prenameOfImage(value:String):void 
		{
			_prenameOfImage = value;
		}
		
		public function get storageDir():String 
		{
			return _storageDir;
		}
		
		public function set storageDir(value:String):void 
		{
			_storageDir = value;
		}
	}

}