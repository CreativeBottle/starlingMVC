package com.creativebottle.starlingmvc.meta
{
	public class MetaMethod extends MetaClassMember
	{
		public var parameters:Array = [];

		public function MetaMethod(xml:XML)
		{
			super(xml);
		}

		override protected function parse(xml:XML):void
		{
			name = xml.@name;

			super.parse(xml);

			for each(var parameterXml:XML in xml.parameter)
			{
				parameters.push(new MetaParameter(parameterXml));
			}

		}
	}
}
