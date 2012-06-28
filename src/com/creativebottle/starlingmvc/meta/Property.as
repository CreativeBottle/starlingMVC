package com.creativebottle.starlingmvc.meta
{
	/**
	 * Class for properties within a meta class
	 */
	public class Property extends ClassMember
	{
		/**
		 * Constructor
		 *
		 * @param xml The xml representation of the meta property
		 */
		public function Property(xml:XML)
		{
			super(xml);
		}

		/**
		 * Returns a string representation of the meta property
		 */
		public function toString():String
		{
			return "Property{ name:" + name + ",classname:" + classname + ",tags:" + tags + " }";
		}
	}
}
