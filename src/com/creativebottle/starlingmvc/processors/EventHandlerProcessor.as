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
package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.StarlingMVC;
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.events.EventHandler;
	import com.creativebottle.starlingmvc.utils.MetaClassCache;
	import com.creativebottle.system.injection.InjectionTag;
	import com.creativebottle.system.meta.MetaClass;
	import com.creativebottle.system.meta.MetaClassMember;
	import com.creativebottle.system.meta.MetaTag;
	import com.creativebottle.system.meta.MetaTagArg;

	import flash.utils.getDefinitionByName;

	import starling.events.EventDispatcher;

	public class EventHandlerProcessor implements IProcessor
	{
		public var dispatchers:Array;
		public var eventPackages:Array;

		public function EventHandlerProcessor():void
		{

		}

		public function config(starlingMVC:StarlingMVC):void
		{
			this.dispatchers = [starlingMVC.rootLayer, starlingMVC.dispatcher];
			this.eventPackages = starlingMVC.config.eventPackages;
		}

		public function process(object:Object, beans:Beans):void
		{
			var bean:Bean = !(object is Bean) ? new Bean(object) : object as Bean;

			if (!bean.instance) return;

			var metaClass:MetaClass = MetaClassCache.getMetaClassForInstance(bean.instance);

			var eventHandlers:Array = metaClass.membersByMetaTag(InjectionTag.EVENT_HANDLER);

			for each(var member:MetaClassMember in eventHandlers)
			{
				var metaTag:MetaTag = member.tagByName(InjectionTag.EVENT_HANDLER);
				var arg:MetaTagArg = metaTag.argByName("event");

				var eventName:String = getEventName(arg);

				addToDispatchers(eventName, bean.instance[member.name], metaTag);
			}
		}

		private function getEventName(arg:MetaTagArg):String
		{
			var dots:Array = arg.value.split(".");

			if (dots.length == 1)
			{
				return arg.value;
			}
			else if (dots.length == 2)
			{
				var eventClassName:String = arg.value.split(".")[0];
				var EventClass:Class = getEventClass(eventClassName);

				if (!EventClass) throw new Error("Event type not found: " + eventClassName);

				var eventName:String = arg.value.split(".")[1];

				if (!eventName || EventClass[eventName] == null)
				{
					throw new Error("Event " + eventName + " not found on event class: " + eventClassName);
				}
				else
				{
					return EventClass[eventName];
				}
			}
			else
			{
				throw new Error("Invalid event type: " + arg.value);
			}
		}

		public function getEventClass(eventClassName:String):Class
		{
			var EventClass:Class;

			for each(var pack:String in eventPackages)
			{
				try
				{
					EventClass = getDefinitionByName(pack + "." + eventClassName) as Class;
					return EventClass;
				}
				catch (e:Error)
				{
					trace("EventClass not found in package. Checking next package.");
				}
			}

			return null;
		}

		public function addToDispatchers(event:String, handler:Function, tag:MetaTag):void
		{
			var eventHandler:EventHandler = new EventHandler(handler, tag);

			for each(var dispatcher:EventDispatcher in dispatchers)
			{
				dispatcher.addEventListener(event, eventHandler.handleEvent);
			}
		}
	}
}