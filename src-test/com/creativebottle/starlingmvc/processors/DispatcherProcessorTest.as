package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.StarlingMVC;
	import com.creativebottle.starlingmvc.config.StarlingMVCConfig;
	import com.creativebottle.starlingmvc.mock.model.TestModel2;

	import org.flexunit.asserts.assertEquals;

	public class DispatcherProcessorTest
	{
		private var starlingMVC:StarlingMVC;
		private var testModel2:TestModel2;
		private var beans:Array;

		[Before]
		public function setUp():void
		{
			testModel2 = new TestModel2();

			var config:StarlingMVCConfig = new StarlingMVCConfig();

			beans = [testModel2];

			starlingMVC = new StarlingMVC(null, config, beans);
		}

		[After]
		public function tearDown():void
		{
			starlingMVC = null;
			testModel2 = null;
			beans = null;
		}

		[Test]
		public function testSetUp_injectDispatcher():void
		{
			var dispatcherProcessor:DispatcherProcessor = new DispatcherProcessor();
			dispatcherProcessor.config(starlingMVC);
			dispatcherProcessor.setUp(testModel2, starlingMVC.beans);

			assertEquals("TestModel2 dispatcher property should be equal to testModel3 instance.", starlingMVC.dispatcher, testModel2.dispatcher);
		}
	}
}