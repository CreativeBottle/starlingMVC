package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.StarlingMVC;
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.config.StarlingMVCConfig;
	import com.creativebottle.starlingmvc.mock.model.TestModel;
	import com.creativebottle.starlingmvc.mock.model.TestModel2;
	import com.creativebottle.starlingmvc.mock.model.TestModel3;

	import org.flexunit.asserts.assertEquals;

	public class InjectProcessorTest
	{
		private var starlingMVC:StarlingMVC;
		private var testModel:TestModel;
		private var testModel2:TestModel2;
		private var testModel3:TestModel3;
		private var beans:Array;

		[Before]
		public function setUp():void
		{
			testModel = new TestModel();
			testModel2 = new TestModel2();
			testModel3 = new TestModel3();

			var config:StarlingMVCConfig = new StarlingMVCConfig();

			beans = [testModel, new Bean(testModel2, "testModel2"), testModel3];

			starlingMVC = new StarlingMVC(null, config, beans);
		}

		[After]
		public function tearDown():void
		{
			starlingMVC = null;
			testModel = null;
			testModel2 = null;
			testModel3 = null;
			beans = null;
		}

		[Test]
		public function testProcess_injectById():void
		{
			var injectProcessor:InjectProcessor = new InjectProcessor();
			injectProcessor.config(starlingMVC);
			injectProcessor.setUp(testModel, starlingMVC.beans);

			assertEquals("TestModel testModel2 property should be equal to testModel2 instance.", testModel2, testModel.testModel2);
		}

		[Test]
		public function testProcess_injectByType():void
		{
			var injectProcessor:InjectProcessor = new InjectProcessor();
			injectProcessor.config(starlingMVC);
			injectProcessor.setUp(testModel, starlingMVC.beans);

			assertEquals("TestModel testModel3 property should be equal to testModel3 instance.", testModel3, testModel.testModel3);
		}
	}
}