package com.creativebottle.starlingmvc.meta
{
	/**
	 * Class for accessors within a meta class
	 */
	public class MetaAccessor extends MetaClassMember
	{
		/**
		 * Constructor
		 *
		 * @param xml the xml representation of the accessor
		 */
		public function MetaAccessor(xml:XML)
		{
			super(xml);
		}

		/**
		 * Returns a string representation of the accessor
		 */
		public function toString():String
		{
			return "MetaAccessor{ name:" + name + ",classname:" + classname + ",tags:" + tags + " }";
		}
	}
}
