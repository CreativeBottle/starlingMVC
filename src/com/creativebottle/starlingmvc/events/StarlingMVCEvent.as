package com.creativebottle.starlingmvc.events
{
	import starling.events.Event;

	public class StarlingMVCEvent extends Event
	{
		public static const INITIALIZED:String = "initialized";

		public function StarlingMVCEvent(type:String)
		{
			super(type, true);
		}
	}
}