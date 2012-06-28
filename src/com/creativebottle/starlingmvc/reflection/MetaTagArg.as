package com.creativebottle.starlingmvc.reflection
{
	/**
	 * Key-value pair belonging to a metadata tag.
	 */
	public class MetaTagArg
	{
		/**
		 * The meta tag argument key
		 */
		public var key:String;
		/**
		 * The meta tag argument value
		 */
		public var value:String;

		/**
		 * Constructor
		 *
		 * @param key The meta tag argument key
		 * @param value The meta tag argument value
		 */
		public function MetaTagArg(key:String, value:String)
		{
			this.key = key;
			this.value = value;
		}

		/**
		 * Returns a string representation of the meta tag arg
		 */
		public function toString():String
		{
			return "MetaTagArg{key=" + key + ",value=" + value + "}";
		}
	}
}
