package com.creativebottle.starlingmvc.errors
{
	public class EventClassNotFoundError extends Error
	{
		public function EventClassNotFoundError(eventClassName:String)
		{
			super("Event class not found: " + eventClassName);
		}
	}
}