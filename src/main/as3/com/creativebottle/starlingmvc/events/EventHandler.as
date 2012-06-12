package com.creativebottle.starlingmvc.events
{
	import com.creativebottle.system.meta.MetaTag;
	import com.creativebottle.system.meta.MetaTagArg;

	import starling.events.Event;

	public class EventHandler
	{
		private var handler:Function;
		private var args:Array;

		public function EventHandler(handler:Function, tag:MetaTag)
		{
			this.handler = handler;

			var arg:MetaTagArg = tag.argByName("properties");

			if (arg)
				args = String(arg.value).split(",");
		}

		public function handleEvent(event:Event):void
		{
			var handlerArgs:Array = new Array();

			for each(var arg:String in args)
			{
				if (event[arg])
				{
					handlerArgs.push(event[arg]);
				}
				else
				{
					throw new Error("Property " + arg + " doesn't exit on event type " + typeof event);
				}
			}

			if (handlerArgs.length > 0)
			{
				handler.apply(null, handlerArgs);
			}
			else
			{
				handler(event);
			}
		}
	}
}