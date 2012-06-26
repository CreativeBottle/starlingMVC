package com.creativebottle.starlingmvc.beans
{
	import com.creativebottle.starlingmvc.StarlingMVC;
	import com.creativebottle.starlingmvc.events.BeanEvent;
	import com.creativebottle.starlingmvc.events.EventMap;
	import com.creativebottle.starlingmvc.processors.PreDestroyProcessor;
	import com.creativebottle.starlingmvc.processors.Processors;
	import com.creativebottle.starlingmvc.processors.ViewAddedProcessor;
	import com.creativebottle.starlingmvc.processors.ViewRemovedProcessor;

	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class BeanFactory
	{
		private const eventMap:EventMap = new EventMap();
		private var beans:Beans;
		private var rootLayer:DisplayObjectContainer;
		private var dispatcher:EventDispatcher;
		private var processors:Processors;

		public function BeanFactory(starlingMVC:StarlingMVC)
		{
			beans = starlingMVC.beans;
			rootLayer = starlingMVC.rootLayer;
			dispatcher = starlingMVC.dispatcher;
			processors = starlingMVC.processors;

			setUpEventHandlers();
		}

		private function displayObjectAdded(event:Event):void
		{
			processors.processOn(event.target, beans);

			var viewAddedProcessor:ViewAddedProcessor = new ViewAddedProcessor();
			viewAddedProcessor.process(event.target, beans);
		}

		private function displayObjectRemoved(event:Event):void
		{
			var viewRemovedProcessor:ViewRemovedProcessor = new ViewRemovedProcessor();
			viewRemovedProcessor.process(event.target, beans);

			var preDestroyProcessor:PreDestroyProcessor = new PreDestroyProcessor();
			preDestroyProcessor.process(event.target, beans);
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

		private function beanAdded(event:BeanEvent):void
		{
			var bean:Bean = event.bean;
			beans.addBean(bean);
			processors.processOn(bean, beans);
		}

		private function beanRemoved(event:BeanEvent):void
		{
			var preDestroyProcessor:PreDestroyProcessor = new PreDestroyProcessor();
			preDestroyProcessor.process(event.bean, beans);

			beans.removeBean(event.bean);
		}
	}
}