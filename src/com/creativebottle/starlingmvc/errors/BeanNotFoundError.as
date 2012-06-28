package com.creativebottle.starlingmvc.errors
{
	public class BeanNotFoundError extends Error
	{
		public function BeanNotFoundError(id:String)
		{
			super("No bean found with id: " + id);
		}
	}
}