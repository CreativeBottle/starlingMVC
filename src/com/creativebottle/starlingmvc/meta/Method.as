package com.creativebottle.starlingmvc.meta
{
	public class Method extends ClassMember
	{
		public var parameters:Array = [];

		public function Method(xml:XML)
		{
			super(xml);
		}

		override protected function parse(xml:XML):void
		{
			name = xml.@name;

			super.parse(xml);

			for each(var parameterXml:XML in xml.parameter)
			{
				parameters.push(new Parameter(parameterXml));
			}

		}
	}
}
