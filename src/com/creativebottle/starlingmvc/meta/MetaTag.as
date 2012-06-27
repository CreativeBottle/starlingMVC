package com.creativebottle.starlingmvc.meta
{

	/**
	 * Class for tags on a meta class member
	 */
	public class MetaTag
	{
		/**
		 * All arguments on the tag
		 */
		public const args:Array = new Array();
		/**
		 * The tag name
		 */
		public var name:String;

		/**
		 * Constructor
		 *
		 * @param name The tag name
		 */
		public function MetaTag(name:String, xml:XMLList)
		{
			this.name = name;

			parseArgs(xml);
		}

		/**
		 * Retrieve an arg by name
		 *
		 * @param name The name to search for
		 */
		public function argByName(name:String):MetaTagArg
		{
			for each(var arg:MetaTagArg in args)
			{
				if (arg.name == name)
					return arg;
			}

			return null;
		}

		private function parseArgs(xml:XMLList):void
		{
			for each(var argXml:XML in xml)
			{
				args.push(new MetaTagArg(argXml.@key, argXml.@value));
			}
		}

		/**
		 * Returns a string representation of the meta tag
		 */
		public function toString():String
		{
			return "MetaTag{ name:" + name + ",args:" + args + " }";
		}
	}
}