package com.creativebottle.starlingmvc
{
	import com.creativebottle.starlingmvc.beans.BeanFactory;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.config.StarlingMVCConfig;
	import com.creativebottle.starlingmvc.processors.Processors;

	import starling.display.DisplayObjectContainer;
	import starling.events.EventDispatcher;

	public class StarlingMVC
	{
		public const dispatcher:EventDispatcher = new EventDispatcher();
		public const beans:Beans = new Beans();

		private var _config:StarlingMVCConfig;
		private var _rootLayer:DisplayObjectContainer;
		private var _processors:Processors;
		private var beanFactory:BeanFactory;

		public function get config():StarlingMVCConfig
		{
			return _config;
		}

		public function get rootLayer():DisplayObjectContainer
		{
			return _rootLayer;
		}

		public function get processors():Processors
		{
			return _processors;
		}

		public function set beanProviders(value:Array):void
		{
			beans.addBeans(value);

			if (processors)
				processors.processAll();
		}

		public function set customProcessors(value:Array):void
		{
			if (!value) return;

			for (var i:int = 0; i < value.length; i++)
			{
				processors.addProcessor(value[i]);
			}

			processors.processAll();
		}

		public function StarlingMVC(rootLayer:DisplayObjectContainer, config:StarlingMVCConfig, beanProviders:Array = null, customProcessors:Array = null)
		{
			_rootLayer = rootLayer;
			_config = config;

			this.customProcessors = customProcessors;
			this.beanProviders = beanProviders;

			_processors = new Processors(this);
			beanFactory = new BeanFactory(this);
		}
	}
}