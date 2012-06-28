package com.creativebottle.starlingmvc.errors
{
	public class PropertyNotFoundError extends Error
	{
		public function PropertyNotFoundError(propertyName:String, eventType:String)
		{
			super("Property " + propertyName + " doesn't exist on type " + eventType);
		}
	}
}