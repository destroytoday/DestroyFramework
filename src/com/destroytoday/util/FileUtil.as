package com.destroytoday.util
{
	import com.destroytoday.pool.ObjectPool;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	public class FileUtil
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected static var filePool:ObjectPool = new ObjectPool(File);
		
		protected static var file:File = new File();

		protected static var destinationFile:File = new File();
		
		protected static var streamPool:ObjectPool = new ObjectPool(FileStream);
		
		protected static var stream:FileStream = new FileStream();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function FileUtil()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public static function exists(path:String):Boolean
		{
			file.nativePath = path;
			
			return file.exists;
		}
		
		public static function trash(path:String):void
		{
			file.nativePath = path;
			
			if (file.exists) file.deleteFile();
		}
		
		public static function getURL(path:String):String
		{
			file.nativePath = path;
			
			return file.url;
		}
		
		public static function openWithDefaultApplication(path:String):void
		{
			file.nativePath = path;
			
			file.openWithDefaultApplication()
		}
		
		public static function getDirectoryListing(path:String):Array
		{
			file.nativePath = path;
			
			return file.getDirectoryListing();
		}
		
		public static function read(path:String):String
		{
			file.nativePath = path;
			stream.open(file, FileMode.READ);
			
			stream.position = 0.0;
			var content:String = stream.readUTFBytes(stream.bytesAvailable);
			
			stream.close();
			
			return content;
		}
		
		public static function save(path:String, content:*):void
		{
			file.nativePath = path;
			stream.open(file, FileMode.WRITE);
			stream.position = 0.0;
			
			if (content is ByteArray)
			{
				stream.writeBytes(content);
			}
			else if (content is String)
			{
				stream.writeUTFBytes(content);
			}
			
			stream.close();
		}
		
		public static function copy(path:String, to:String, overwrite:Boolean = false):void
		{
			destinationFile.nativePath = to;
			
			file.nativePath = path;
			file.copyTo(destinationFile, overwrite);
		}
		
		/*public static function saveAsync(path:String, content:*):void
		{
			var file:File = filePool.getObject() as File;
			
			file.nativePath = path;
			
			var stream:FileStream = streamPool.getObject() as FileStream;
			
			stream.addEventListener(Event.ACTIVATE, asyncStreamActivateHandler);
			stream.addEventListener(Event.COMPLETE, asyncStreamCompleteHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR, asyncStreamErrorHandler);
			stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, asyncStreamOutputProgressHandler);
			
			stream.openAsync(file, FileMode.WRITE);
			stream.position = 0.0;
			
			if (content is ByteArray)
			{
				stream.writeBytes(content);
			}
			else if (content is String)
			{
				stream.writeUTFBytes(content);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected static function asyncStreamActivateHandler(event:Event):void
		{
			trace("activate");
			
			stream.close();
		}
		
		protected static function asyncStreamCompleteHandler(event:Event):void
		{
			trace("complete");
		}
		
		protected static function asyncStreamErrorHandler(event:IOErrorEvent):void
		{
			trace("error", event.text);
			
			stream.close();
		}
		
		protected static function asyncStreamOutputProgressHandler(event:OutputProgressEvent):void
		{
			trace(event.bytesPending, event.bytesTotal);
			
			if (event.bytesPending == 0)
			{
				stream.close();
				
				trace("written!");
			}
		}*/
	}
}