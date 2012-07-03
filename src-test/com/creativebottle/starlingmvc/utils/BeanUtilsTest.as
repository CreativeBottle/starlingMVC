package com.creativebottle.starlingmvc.utils
{
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.mock.model.TestModel;

	import org.flexunit.asserts.assertTrue;

	public class BeanUtilsTest
	{
		public function BeanUtilsTest()
		{
		}

		[Before]
		public function setUp():void
		{

		}

		[After]
		public function tearDown():void
		{

		}

		[Test]
		public function testNormalizeBean_passedObject():void
		{
			var beanIn:TestModel = new TestModel();

			var createsBean:Boolean = BeanUtils.normalizeBean(beanIn) is Bean;

			assertTrue("normalizeBean should always create a Bean.", createsBean)
		}

		[Test]
		public function testNormalizeBean_passedBean():void
		{
			var beanIn:Bean = new Bean(new TestModel());

			var createsBean:Boolean = BeanUtils.normalizeBean(beanIn) is Bean;

			assertTrue("normalizeBean should always create a Bean.", createsBean)
		}
	}
}