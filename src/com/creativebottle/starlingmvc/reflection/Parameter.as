package com.creativebottle.starlingmvc.reflection
{
	import flash.utils.getDefinitionByName;

	public class Parameter
	{
		public var index:int;
		public var type:Class;
		public var optional:Boolean;

		public function Parameter(xml:XML)
		{
			index = int(xml.@index);
			type = getDefinitionByName(xml.@type) as Class;
			optional = xml.@optional == "true";
		}
	}
}
