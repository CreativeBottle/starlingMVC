package com.creativebottle.starlingmvc.meta
{
	public class MetaMethod extends MetaClassMember
	{
		public var parameters:Array = new Array();

		public function MetaMethod(xml:XML)
		{
			super(xml);
		}

		override protected function parse(xml:XML):void
		{
			name = xml.@name;

			for each(var metaDataXml:XML in xml.metadata)
			{
				tags.push(new MetaTag(metaDataXml.@name, metaDataXml..arg));
			}

			for each(var parameterXml:XML in xml.parameter)
			{
				parameters.push(new MetaParameter(parameterXml));
			}

		}
	}
}