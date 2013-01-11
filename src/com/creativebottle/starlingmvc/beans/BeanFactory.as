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
    import com.creativebottle.starlingmvc.commands.Command;
    import com.creativebottle.starlingmvc.commands.Commands;
    import com.creativebottle.starlingmvc.config.StarlingMVCConfig;
	import com.creativebottle.starlingmvc.events.BeanEvent;
	import com.creativebottle.starlingmvc.events.EventMap;
	import com.creativebottle.starlingmvc.events.StarlingMVCEvent;
	import com.creativebottle.starlingmvc.processors.PreDestroyProcessor;
	import com.creativebottle.starlingmvc.processors.ViewAddedProcessor;
	import com.creativebottle.starlingmvc.processors.ViewRemovedProcessor;
	import com.creativebottle.starlingmvc.utils.BeanUtils;

	import flash.utils.getQualifiedClassName;

	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class BeanFactory
	{
		private const eventMap:EventMap = new EventMap();
		private var initialized:Boolean;
		private var beans:Beans;
		private var config:StarlingMVCConfig;
		private var rootLayer:DisplayObjectContainer;
		private var dispatcher:EventDispatcher;
		private var delayed:Array = new Array();
		private var starlingMVC:StarlingMVC;

		public function BeanFactory(starlingMVC:StarlingMVC)
		{
			this.starlingMVC = starlingMVC;
			initialized = starlingMVC.initialized;
			beans = starlingMVC.beans;
			config = starlingMVC.config;
			rootLayer = starlingMVC.rootLayer;
			dispatcher = starlingMVC.dispatcher;

			eventMap.addMap(dispatcher, StarlingMVCEvent.INITIALIZED, onStarlingMVCInitialized);

			if (rootLayer)
				setUpEventHandlers();
		}

		private function displayObjectAdded(event:Event):void
		{
			var target:Object = event.target;

			if (initialized)
			{
				processDisplayObjectAdded(target);
			}
			else
			{
				delayed.push(target);
			}
		}

		private function processDisplayObjectAdded(target:Object):void
		{
			starlingMVC.processors.processOn(target, beans);

			if (filterByPackage(target, config.viewPackages))
			{
				var viewAddedProcessor:ViewAddedProcessor = new ViewAddedProcessor();
				viewAddedProcessor.process(target, beans);
			}
		}

		private function processDelayed():void
		{
			var target:Object;

			while (target = delayed.pop())
			{
				processDisplayObjectAdded(target);
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

			starlingMVC.processors.tearDown(BeanUtils.normalizeBean(target));
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

            if(bean.instance is Command)
            {
                starlingMVC.commands.addCommand(bean.instance as Command);
            }

            beans.addBean(bean);
            starlingMVC.processors.processOn(bean, beans);
		}

		private function beanRemoved(event:BeanEvent):void
		{
			var bean:Bean = event.bean;

			beans.removeBean(bean);

			starlingMVC.processors.tearDown(bean);
		}

		private function filterByPackage(object:Object, whitelistedPackages:Array):Boolean
		{
			var className:String = getQualifiedClassName(object).replace(/::/g, ".");
			var packageName:String = className.slice(0, className.lastIndexOf("."));
			return whitelistedPackages.indexOf(packageName) != -1;
		}

		private function onStarlingMVCInitialized(event:StarlingMVCEvent):void
		{
			eventMap.removeMap(event.target, StarlingMVCEvent.INITIALIZED, onStarlingMVCInitialized);

			initialized = true;

			processDelayed();
		}
	}
}
