package com.nidlab.kinect 
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class KinectConsole extends EventDispatcher
	{
		private var process:NativeProcess;
		public static const PROCESS_EXIT:String = "processExit";
		public function KinectConsole() 
		{
			//Kinect Server Console
			if (NativeProcess.isSupported) {
				var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				var file:File = File.applicationDirectory.resolvePath("KinectServerConsole.exe");
				nativeProcessStartupInfo.executable = file;
				
				process = new NativeProcess();
				process.start(nativeProcessStartupInfo);
				process.addEventListener(NativeProcessExitEvent.EXIT, onProcessExit);
			} else {
				trace("NativeProcess is not supported.");
			}
			
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