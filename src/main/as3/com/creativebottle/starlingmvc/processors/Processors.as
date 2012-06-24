package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.utils.MetaClassCache;

	public class Processors
	{
		private var processors:Array = new Array();

		private var cache:MetaClassCache;
		private var beans:Beans;

		public function Processors(classCache:MetaClassCache, beans:Beans)
		{
			this.cache = classCache;
			this.beans = beans;
		}

		public function addProcessor(processor:IProcessor):void
		{
			processor.cache = cache;
			processors.push(processor);
		}

		public function processAll():void
		{
			for each(var bean:Bean in beans.beans)
			{
				processOn(bean, beans);
			}

			// Run a second time for any prototypes created during injection
			// TODO Refactor to make this cleaner
			/*if (beans == config.beans || beans.beans.length < injectProcessor.prototypeInstances)
			 {
			 var prototypes:Beans = new Beans();
			 prototypes.addBeans(injectProcessor.prototypeInstances);

			 refreshInjections(prototypes);
			 }*/
		}

		public function processOn(object:Object, beans:Beans):void
		{
			for each(var processor:IProcessor in processors)
			{
				processor.process(object, beans);
			}
		}
	}
}