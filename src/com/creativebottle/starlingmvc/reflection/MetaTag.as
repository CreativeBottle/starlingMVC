/*
 * Copyright 2012 StarlingMVC Framework Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package com.creativebottle.starlingmvc.reflection
{

	/**
	 * Class for metadata tags on a class member
	 */
	public class MetaTag
	{
		/**
		 * All arguments on the tag
		 */
		public const args:Array = [];
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

			for each(var argXml:XML in xml)
			{
				args.push(new MetaTagArg(argXml.@key, argXml.@value));
			}
		}

		/**
		 * Retrieve an arg by name
		 *
		 * @param name The name to search for
		 */
		public function argByKey(key:String):MetaTagArg
		{
			for each(var arg:MetaTagArg in args)
			{
				if (arg.key == key)
					return arg;
			}

			return null;
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
