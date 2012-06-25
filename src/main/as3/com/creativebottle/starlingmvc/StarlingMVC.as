package com.creativebottle.starlingmvc
{
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.config.StarlingMVCConfig;
	import com.creativebottle.starlingmvc.events.BeanEvent;
	import com.creativebottle.starlingmvc.processors.DispatcherProcessor;
	import com.creativebottle.starlingmvc.processors.EventHandlerProcessor;
	import com.creativebottle.starlingmvc.processors.IProcessor;
	import com.creativebottle.starlingmvc.processors.InjectProcessor;
	import com.creativebottle.starlingmvc.processors.PostConstructProcessor;
	import com.creativebottle.starlingmvc.processors.PreDestroyProcessor;
	import com.creativebottle.starlingmvc.processors.Processors;
	import com.creativebottle.starlingmvc.processors.ViewAddedProcessor;
	import com.creativebottle.starlingmvc.processors.ViewRemovedProcessor;
	import com.creativebottle.starlingmvc.utils.EventMap;
	import com.creativebottle.starlingmvc.utils.MetaClassCache;

	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class StarlingMVC
	{
		private const eventMap:EventMap = new EventMap();
		private const classCache:MetaClassCache = new MetaClassCache();
		private const dispatcher:EventDispatcher = new EventDispatcher();
		private const beans:Beans = new Beans(classCache);

		private var config:StarlingMVCConfig;
		private var rootLayer:DisplayObjectContainer;
		private var processors:Processors;

		public function set beanProviders(value:Array):void
		{
			beans.addBeans(value);
			setUpProcessors();
		}

		public function set customProcessors(value:Array):void
		{
			if (!value) return;

			for (var i:int = 0; i < value.length; i++)
			{
				var processor:IProcessor = value[i] as IProcessor;

				if (processor)
				{
					processors.addProcessor(processor);
				}
				else
				{
					throw new Error("Invalid Processor: Custom processors must implement IProcessor.");
				}
			}
			setUpProcessors();
		}

		public function StarlingMVC(rootLayer:DisplayObjectContainer, config:StarlingMVCConfig, beanProviders:Array = null, customProcessors:Array = null)
		{
			this.rootLayer = rootLayer;
			this.config = config;

			setUpEventHandlers();

			this.customProcessors = customProcessors;
			this.beanProviders = beanProviders;
		}

		private function displayObjectAdded(event:Event):void
		{
			processors.processOn(event.target, beans);

			var viewAddedProcessor:ViewAddedProcessor = new ViewAddedProcessor();
			viewAddedProcessor.cache = classCache;
			viewAddedProcessor.process(event.target, beans);
		}

		private function displayObjectRemoved(event:Event):void
		{
			var viewRemovedProcessor:ViewRemovedProcessor = new ViewRemovedProcessor();
			viewRemovedProcessor.cache = classCache;
			viewRemovedProcessor.process(event.target, beans);

			var preDestroyProcessor:PreDestroyProcessor = new PreDestroyProcessor();
			preDestroyProcessor.cache = classCache;
			preDestroyProcessor.process(event.target, beans);
		}

		private function setUpProcessors():void
		{
			processors = new Processors(classCache, beans);
			processors.addProcessor(new DispatcherProcessor(dispatcher));
			processors.addProcessor(new InjectProcessor(dispatcher));
			processors.addProcessor(new PostConstructProcessor());
			processors.addProcessor(new EventHandlerProcessor([dispatcher, rootLayer], config.eventPackages));
			processors.processAll();
		}

		private function beanAdded(event:BeanEvent):void
		{
			var bean:Bean = event.bean;

			beans.addBean(bean);

			processors.processOn(bean, beans);
		}

		private function beanRemoved(event:BeanEvent):void
		{
			var preDestroyProcessor:PreDestroyProcessor = new PreDestroyProcessor();
			preDestroyProcessor.cache = classCache;
			preDestroyProcessor.process(event.bean, beans);
			// TODO Need to write pre destroy processor

			beans.removeBean(event.bean);
		}

		private function setUpEventHandlers():void
		{
			eventMap.addMap(rootLayer, Event.ADDED, displayObjectAdded);
			eventMap.addMap(rootLayer, Event.REMOVED, displayObjectRemoved);

			// Bean events
			eventMap.addMap(rootLayer, BeanEvent.ADD_BEAN, beanAdded);
			eventMap.addMap(dispatcher, BeanEvent.ADD_BEAN, beanAdded);
			eventMap.addMap(rootLayer, BeanEvent.REMOVE_BEAN, beanRemoved);
			eventMap.addMap(dispatcher, BeanEvent.REMOVE_BEAN, beanRemoved);
		}
	}
}