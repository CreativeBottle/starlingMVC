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
	import com.creativebottle.starlingmvc.errors.UndefinedMemberKindError;

	import flash.utils.describeType;

	/**
	 * Meta class parsing of a real object
	 */
	public class ClassDescriptor
	{
		/**
		 * All accessors within the class
		 */
		public const accessors:Array = [];
		/**
		 * All variables within the class
		 */
		public const variables:Array = [];
		/**
		 * All tags on the class
		 */
		public var tags:Array = [];

		/**
		 * All methods of the class
		 */
		public const methods:Array = [];

		/**
		 * Constructor
		 *
		 * @param object The object to parse
		 */
		public function ClassDescriptor(object:Object)
		{
			var xml:XML = describeType(object);

			for each(var tag:XML in xml.metadata)
			{
				tags.push(new MetaTag(tag.@name, tag..arg));
			}

			parse(xml..accessor, MemberKind.ACCESSOR);
			parse(xml..variable, MemberKind.VARIABLE);
			parse(xml..method, MemberKind.METHOD);
		}

		/**
		 * Retrieve a member by a tag name
		 *
		 * @param tagName The tag name to search for
		 */
		public function membersByMetaTag(tagName:String):Array
		{
			var members:Array = [];

			var member:ClassMember;

			for each(member in accessors)
			{
				if (member.hasTag(tagName))
					members.push(member);
			}

			for each(member in variables)
			{
				if (member.hasTag(tagName))
					members.push(member);
			}

			for each(member in methods)
			{
				if (member.hasTag(tagName))
					members.push(member);
			}

			return members;
		}

		/**
		 * Returns true if a tag with the specified name exists, false is not.
		 *
		 * @param tagName The tag name to search for
		 */
		public function hasTag(tagName:String):Boolean
		{
			for each(var tag:MetaTag in tags)
			{
				if (tag.name == tagName)
					return true;
			}

			return false;
		}

		/**
		 * Returns the tag with the specified name
		 *
		 * @param tagName The tag name to search for
		 */
		public function tagByName(tagName:String):MetaTag
		{
			for each(var tag:MetaTag in tags)
			{
				if (tag.name == tagName)
					return tag;
			}

			return null;
		}

		private function parse(xmlList:XMLList, kind:MemberKind):void
		{
			for each(var itemXml:XML in xmlList)
			{
				switch (kind)
				{
					case MemberKind.ACCESSOR:
						accessors.push(new Accessor(itemXml));
						break;
					case MemberKind.METHOD:
						methods.push(new Method(itemXml));
						break;
					case MemberKind.VARIABLE:
						variables.push(new Variable(itemXml));
						break;
					default:
						throw new UndefinedMemberKindError(kind);
						break;
				}
			}
		}
	}
}
