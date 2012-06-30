/*
 * Copyright 2012 StarlingMVC Framework Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package com.creativebottle.starlingmvc.beans
{
	import com.creativebottle.starlingmvc.StarlingMVC;
	import com.creativebottle.starlingmvc.config.StarlingMVCConfig;
	import com.creativebottle.starlingmvc.events.BeanEvent;
	import com.creativebottle.starlingmvc.events.EventMap;
	import com.creativebottle.starlingmvc.processors.PreDestroyProcessor;
	import com.creativebottle.starlingmvc.processors.Processors;
	import com.creativebottle.starlingmvc.processors.ViewAddedProcessor;
	import com.creativebottle.starlingmvc.processors.ViewRemovedProcessor;

	import flash.utils.getQualifiedClassName;

	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class BeanFactory
	{
		private const eventMap:EventMap = new EventMap();
		private var beans:Beans;
		private var config:StarlingMVCConfig;
		private var rootLayer:DisplayObjectContainer;
		private var dispatcher:EventDispatcher;
		private var processors:Processors;

		public function BeanFactory(starlingMVC:StarlingMVC)
		{
			beans = starlingMVC.beans;
			config = starlingMVC.config;
			rootLayer = starlingMVC.rootLayer;
			dispatcher = starlingMVC.dispatcher;
			processors = starlingMVC.processors;

			setUpEventHandlers();
		}

		private function displayObjectAdded(event:Event):void
		{
			var target:Object = event.target;

			processors.processOn(target, beans);

			if (filterByPackage(target, config.viewPackages))
			{
				var viewAddedProcessor:ViewAddedProcessor = new ViewAddedProcessor();
				viewAddedProcessor.process(target, beans);
			}
		}

		private function displayObjectRemoved(event:Event):void
		{
			var target:Object = event.target;

			if (filterByPackage(target, config.viewPackages))
			{
				var viewRemovedProcessor:ViewRemovedProcessor = new ViewRemovedProcessor();
				viewRemovedProcessor.process(target, beans);
			}

			var preDestroyProcessor:PreDestroyProcessor = new PreDestroyProcessor();
			preDestroyProcessor.process(target, beans);
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

		private function filterByPackage(object:Object, whitelistedPackages:Array):Boolean
		{
			var className:String = getQualifiedClassName(object).replace(/::/g, ".");
			var packageName:String = className.slice(0, className.lastIndexOf("."));
			return whitelistedPackages.indexOf(packageName) != -1;
		}
	}
}
