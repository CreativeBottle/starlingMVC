package com.creativebottle.starlingmvc.reflection
{
	/**
	 * Class for accessors within a meta class
	 */
	public class Accessor extends ClassMember
	{
		/**
		 * Constructor
		 *
		 * @param xml the xml representation of the accessor
		 */
		public function Accessor(xml:XML)
		{
			super(xml);
		}

		/**
		 * Returns a string representation of the accessor
		 */
		public function toString():String
		{
			return "Accessor{ name:" + name + ",classname:" + classname + ",tags:" + tags + " }";
		}
	}
}
