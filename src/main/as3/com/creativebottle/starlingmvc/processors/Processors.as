package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.StarlingMVC;
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.beans.Beans;

	public class Processors
	{
		private var processors:Array = new Array();
		private var beans:Beans;
		private var starlingMVC:StarlingMVC;

		public function Processors(starlingMVC:StarlingMVC)
		{
			this.starlingMVC = starlingMVC;
			beans = starlingMVC.beans;

			setUpDefaultProcessors();
		}

		public function addProcessor(processor:IProcessor):void
		{
			processor.config(starlingMVC);

			processors.push(processor);
		}

		public function processAll():void
		{
			for each(var bean:Bean in beans.beans)
			{
				processOn(bean, beans);
			}
		}

		public function processOn(object:Object, beans:Beans):void
		{
			for each(var processor:IProcessor in processors)
			{
				processor.process(object, beans);
			}
		}

		private function setUpDefaultProcessors():void
		{
			addProcessor(new DispatcherProcessor());
			addProcessor(new InjectProcessor());
			addProcessor(new PostConstructProcessor());
			addProcessor(new EventHandlerProcessor());
			processAll();
		}
	}
}