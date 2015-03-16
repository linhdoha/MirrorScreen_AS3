package mirrorScreen.displayComponents 
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
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
		private var bitmap:FlickrBitmap;
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
			countDown.x = stage.stageWidth / 2;
			countDown.y = stage.stageHeight / 2;
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
			bitmapData = new BitmapData(_target.width, _target.height, false);
			bitmapData.draw(_target);
			
			bitmap = new FlickrBitmap(bitmapData);
			addChild(bitmap);
			
			timeline = new TimelineLite({onComplete:onFlickrComplete});
			timeline.append(new TweenLite(bitmap, 0.2, { white:255 } ));
			timeline.append(new TweenLite(bitmap, 1, { white:0 } ));
			
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
		
		private function onFlickrComplete():void {
			this.removeChild(bitmap);
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