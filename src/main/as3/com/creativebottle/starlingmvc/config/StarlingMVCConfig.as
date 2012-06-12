package com.creativebottle.starlingmvc.config
{
	import com.creativebottle.starlingmvc.beans.Beans;

	public class StarlingMVCConfig
	{
		public var beans:Beans = new Beans();
		public var eventPackages:Array;
		public var viewPackages:Array;

		public function StarlingMVCConfig()
		{

		}

		public function set beanProviders(value:Array):void
		{
			beans.addBeans(value);
		}
	}
}