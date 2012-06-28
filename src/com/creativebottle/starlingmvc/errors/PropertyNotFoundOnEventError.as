package com.creativebottle.starlingmvc.errors
{
	public class PropertyNotFoundOnEventError extends Error
	{
		public function PropertyNotFoundOnEventError(propertyName:String, eventType:String)
		{
			super("Property " + propertyName + " doesn't exit on event type " + eventType);
		}
	}
}