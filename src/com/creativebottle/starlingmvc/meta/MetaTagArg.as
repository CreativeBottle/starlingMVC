package com.creativebottle.starlingmvc.meta
{
	/**
	 * Class for argume
	 */
	public class MetaTagArg
	{
		/**
		 * The meta tag argument name
		 */
		public var name:String;
		/**
		 * The meta tag argument value
		 */
		public var value:String;

		/**
		 * Constructor
		 *
		 * @param name The meta tag argument name
		 * @param value The meta tag argument value
		 */
		public function MetaTagArg(name:String, value:String)
		{
			this.name = name;
			this.value = value;
		}

		/**
		 * Returns a string representation of the meta tag arg
		 */
		public function toString():String
		{
			return "MetaTagArg{name=" + String(name) + ",value=" + String(value) + "}";
		}
	}
}