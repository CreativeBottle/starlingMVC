package com.creativebottle.starlingmvc.errors
{
	public class EventTypeNotFoundOnClassError extends Error
	{
		public function EventTypeNotFoundOnClassError(eventName:String, eventClassName:String)
		{
			super("Event " + eventName + " not found on event class: " + eventClassName);
		}
	}
}