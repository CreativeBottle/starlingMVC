package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.StarlingMVC;
	import com.creativebottle.starlingmvc.config.StarlingMVCConfig;
	import com.creativebottle.starlingmvc.mock.model.TestModel2;

	import org.flexunit.asserts.assertEquals;

	import starling.core.Starling;

	public class JugglerProcessorTest
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


		[Test]
		public function testSetUp():void
		{
			var jugglerProcessor:JugglerProcessor = new JugglerProcessor();
			jugglerProcessor.config(starlingMVC);
			jugglerProcessor.setUp(testModel2, starlingMVC.beans);

			assertEquals("juggler property in tesModel2 should be the Starling juggler instance.", Starling.juggler, testModel2.juggler);
		}
	}
}