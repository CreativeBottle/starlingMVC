package com.creativebottle.starlingmvc.errors
{
	public class InvalidEventTypeError extends Error
	{
		public function InvalidEventTypeError(type:String)
		{
			super("Invalid event type: " + type);
		}
	}
}