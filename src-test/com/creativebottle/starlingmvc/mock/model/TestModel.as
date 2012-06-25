package com.creativebottle.starlingmvc.mock.model
{
	public class TestModel
	{
		[Inject(source="testModel2")]
		public var testModel2:TestModel2;

		public function TestModel()
		{

		}

		[PreDestroy]
		public function preDestroy():void
		{

		}
	}
}