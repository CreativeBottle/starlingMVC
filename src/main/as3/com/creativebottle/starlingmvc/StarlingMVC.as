package com.creativebottle.starlingmvc
{
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.config.StarlingMVCConfig;
	import com.creativebottle.starlingmvc.processors.DispatcherProcessor;
	import com.creativebottle.starlingmvc.processors.EventHandlerProcessor;
	import com.creativebottle.starlingmvc.processors.InjectProcessor;
	import com.creativebottle.starlingmvc.processors.PostConstructProcessor;
	import com.creativebottle.starlingmvc.processors.ViewAddedProcessor;
	import com.creativebottle.starlingmvc.processors.ViewRemovedProcessor;
	import com.creativebottle.starlingmvc.utils.MetaClassCache;
	import com.creativebottle.utils.EventMap;

	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class StarlingMVC
	{
		private var _config:StarlingMVCConfig;
		private var rootLayer:DisplayObjectContainer;
		private var eventMap:EventMap = new EventMap();
		private var classCache:MetaClassCache = new MetaClassCache();
		private var dispatcher:EventDispatcher = new EventDispatcher();
		private var injectProcessor:InjectProcessor;
		private var dispatcherProcessor:DispatcherProcessor;
		private var eventHandlerProcessor:EventHandlerProcessor;
		private var postConstructProcessor:PostConstructProcessor;

		public function set config(value:StarlingMVCConfig):void
		{
			_config = value;

			createDefaultProcessors();
			refreshInjections(config.beans);
		}

		public function get config():StarlingMVCConfig
		{
			return _config;
		}

		public function StarlingMVC(rootLayer:DisplayObjectContainer)
		{
			this.rootLayer = rootLayer;

			eventMap.addMap(rootLayer, Event.ADDED, displayObjectAdded);
			eventMap.addMap(rootLayer, Event.REMOVED, displayObjectRemoved);
		}

		private function refreshInjections(beans:Beans):void
		{
			injectProcessor.process(beans, classCache);
			dispatcherProcessor.process(beans, classCache);
			eventHandlerProcessor.process(beans, classCache);
			postConstructProcessor.process(beans, classCache);

			// Run a second time for any prototypes created during injection
			// TODO Refactor to make this cleaner
			if (beans == config.beans || beans.beans.length < injectProcessor.prototypeInstances)
			{
				var prototypes:Beans = new Beans();
				prototypes.addBeans(injectProcessor.prototypeInstances);

				refreshInjections(prototypes);
			}
		}

		private function displayObjectAdded(event:Event):void
		{
			injectProcessor.processOn(event.target, config.beans, classCache);
			postConstructProcessor.processOn(event.target, config.beans, classCache);

			var viewAddedProcessor:ViewAddedProcessor = new ViewAddedProcessor();
			viewAddedProcessor.view = event.target;
			viewAddedProcessor.process(config.beans, classCache);
		}

		private function displayObjectRemoved(event:Event):void
		{
			var viewRemovedProcessor:ViewRemovedProcessor = new ViewRemovedProcessor();
			viewRemovedProcessor.view = event.target;
			viewRemovedProcessor.process(config.beans, classCache);
		}

		private function createDefaultProcessors():void
		{
			injectProcessor = new InjectProcessor();
			postConstructProcessor = new PostConstructProcessor();

			dispatcherProcessor = new DispatcherProcessor();
			dispatcherProcessor.dispatcher = dispatcher;

			eventHandlerProcessor = new EventHandlerProcessor();
			eventHandlerProcessor.dispatchers = [dispatcher, rootLayer];
			eventHandlerProcessor.eventPackages = config.eventPackages;
		}
	}
}