package com.creativebottle.starlingmvc.meta
{
	import flash.utils.getDefinitionByName;

	public class MetaParameter
	{
		public var index:int;
		public var type:Class;
		public var optional:Boolean;

		public function MetaParameter(xml:XML)
		{
			index = int(xml.@index);
			type = getDefinitionByName(xml.@type) as Class;
			optional = xml.@optional == "true";
		}
	}
}
