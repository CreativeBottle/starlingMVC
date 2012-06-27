package com.creativebottle.starlingmvc.meta
{
	/**
	 * Base class for meta class members
	 */
	public class MetaClassMember
	{
		/**
		 * All tags on the member
		 */
		public const tags:Array = [];

		/**
		 * The member name.
		 */
		public var name:String;
		/**
		 * The member type.
		 */
		public var type:String;

		/**
		 * Constructor
		 *
		 * @param xml The xml representation of the member
		 */
		public function MetaClassMember(xml:XML)
		{
			parse(xml);
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

		protected function parse(xml:XML):void
		{
			name = xml.@name;
			type = xml.@type;

			for each(var metaDataXml:XML in xml.metadata)
			{
				tags.push(new MetaTag(metaDataXml.@name, metaDataXml..arg));
			}
		}
	}
}
