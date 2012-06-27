package com.creativebottle.starlingmvc.meta
{
	/**
	 * Class for properties within a meta class
	 */
	public class MetaProperty extends MetaClassMember
	{
		/**
		 * Constructor
		 *
		 * @param xml The xml representation of the meta property
		 */
		public function MetaProperty(xml:XML)
		{
			super(xml);
		}

		/**
		 * Returns a string representation of the meta property
		 */
		public function toString():String
		{
			return "MetaProperty{ name:" + name + ",type:" + type + ",tags:" + tags + " }";
		}
	}
}