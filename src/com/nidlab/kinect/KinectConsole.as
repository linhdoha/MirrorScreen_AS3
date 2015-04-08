package com.nidlab.kinect 
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class KinectConsole extends EventDispatcher
	{
		private var process:NativeProcess;
		public static const PROCESS_EXIT:String = "processExit";
		public function KinectConsole(port:int=7001, debug:Boolean=false) 
		{
			//Kinect Server Console
			if (NativeProcess.isSupported) {
				var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				var file:File = File.applicationDirectory.resolvePath("KinectServerConsole.exe");
				nativeProcessStartupInfo.executable = file;
				
				var processArgs:Vector.<String> = new Vector.<String>;
				processArgs[0] = port;
				if (debug) {
					processArgs[1] = "-debug";
				}
				nativeProcessStartupInfo.arguments = processArgs;
				
				process = new NativeProcess();
				process.start(nativeProcessStartupInfo);
				process.addEventListener(NativeProcessExitEvent.EXIT, onProcessExit);
				process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onStdOut);
				process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onStdErrorData);
				process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
				process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
			} else {
				trace("NativeProcess is not supported.");
			}
			
		}
		
		private function onIOError(event:IOErrorEvent):void
        {
            trace(event.toString());
        }
		
		private function onStdErrorData(e:ProgressEvent):void 
		{
			trace("KinectConsole: ERROR -" + process.standardError.readUTFBytes(process.standardError.bytesAvailable)); 
		}
		
		private function onStdOut(e:ProgressEvent):void 
		{
			//trace("KinectConsole: " + process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable));
			var tempStr:String = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
		}
		
		public function get running():Boolean {
			return process.running;
		}
		
		public function exit():void {
			process.exit(true);
		}
		
		private function onProcessExit(e:NativeProcessExitEvent):void 
		{
			dispatchEvent(new Event(PROCESS_EXIT));
		}
		
	}

}