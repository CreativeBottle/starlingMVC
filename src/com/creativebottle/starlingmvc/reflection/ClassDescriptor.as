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
		 * All accessors within the meta class
		 */
		public const accessors:Array = [];
		/**
		 * All properties within the meta class
		 */
		public const properties:Array = [];
		/**
		 * All meta tags on the class
		 */
		public var tags:Array = [];

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
			parse(xml..variable, MemberKind.PROPERTY);
			parse(xml..method, MemberKind.METHOD);
		}

		/**
		 * Retrieve a member by a meta tag name
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
					case MemberKind.PROPERTY:
						properties.push(new Property(itemXml));
						break;
					default:
						throw new UndefinedMemberKindError(kind);
						break;
				}
			}
		}
	}
}
