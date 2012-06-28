package com.creativebottle.starlingmvc.errors
{
	public class BeanNotFoundError extends Error
	{
		public function BeanNotFoundError(id:String = null)
		{
			super("Bean not found: " + id);
		}
	}
}