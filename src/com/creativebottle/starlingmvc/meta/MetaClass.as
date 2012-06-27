package com.creativebottle.starlingmvc.meta
{
	import flash.utils.describeType;

	/**
	 * Meta class parsing of a real object
	 */
	public class MetaClass
	{
		/**
		 * All accessors within the meta class
		 */
		public const accessors:Array = new Array();
		/**
		 * All properties within the meta class
		 */
		public const properties:Array = new Array();
		/**
		 * All meta tags on the class
		 */
		public var tags:Array = new Array();

		public const methods:Array = new Array();

		/**
		 * Constructor
		 *
		 * @param object The object to parse
		 */
		public function MetaClass(object:Object)
		{
			var xml:XML = describeType(object);

			for each(var tag:XML in xml.metadata)
			{
				tags.push(new MetaTag(tag.@name, tag..arg));
			}

			parse(xml..accessor, MetaItemType.ACCESSOR);
			parse(xml..variable, MetaItemType.PROPERTY);
			parse(xml..method, MetaItemType.METHOD);
		}

		/**
		 * Retrieve a member by a meta tag name
		 *
		 * @param tagName The tag name to search for
		 */
		public function membersByMetaTag(tagName:String):Array
		{
			var members:Array = new Array();

			var member:MetaClassMember;

			for each(member in accessors)
			{
				if (member.hasTag(tagName))
					members.push(member);
			}

			for each(member in properties)
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

		private function parse(xmlList:XMLList, type:MetaItemType):void
		{
			for each(var itemXml:XML in xmlList)
			{
				if (type == MetaItemType.ACCESSOR)
				{
					accessors.push(new MetaAccessor(itemXml));
				}
				else if (type == MetaItemType.METHOD)
				{
					methods.push(new MetaMethod(itemXml));
				}
				else
				{
					properties.push(new MetaProperty(itemXml));
				}
			}
		}
	}
}