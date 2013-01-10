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
	import com.creativebottle.starlingmvc.constants.Args;
	import com.creativebottle.starlingmvc.constants.Tags;
	import com.creativebottle.starlingmvc.errors.EventClassNotFoundError;
	import com.creativebottle.starlingmvc.errors.EventTypeNotFoundOnClassError;
	import com.creativebottle.starlingmvc.errors.InvalidEventTypeError;
	import com.creativebottle.starlingmvc.reflection.ClassDescriptor;
	import com.creativebottle.starlingmvc.reflection.ClassMember;
	import com.creativebottle.starlingmvc.reflection.MetaTag;
	import com.creativebottle.starlingmvc.reflection.MetaTagArg;
	import com.creativebottle.starlingmvc.utils.BeanUtils;
	import com.creativebottle.starlingmvc.utils.ClassDescriptorCache;

	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	import starling.events.EventDispatcher;

	public class EventHandlerProcessor implements IProcessor
	{
		public var dispatchers:Array;
		public var eventPackages:Array;

		private var handlers:Dictionary = new Dictionary(true);

		public function config(starlingMVC:StarlingMVC):void
		{
			this.dispatchers = [starlingMVC.rootLayer, starlingMVC.dispatcher];
			this.eventPackages = starlingMVC.config.eventPackages;
		}

		public function setUp(object:Object, beans:Beans):void
		{
			var targetBean:Bean = BeanUtils.normalizeBean(object);
			var target:Object = targetBean.instance;
			if (!target) return;

			var classDescriptor:ClassDescriptor = ClassDescriptorCache.getClassDescriptorForInstance(target);

			var eventHandlers:Array = classDescriptor.membersByMetaTag(Tags.EVENT_HANDLER);

			for each(var method:ClassMember in eventHandlers)
			{
				var metaTag:MetaTag = method.tagByName(Tags.EVENT_HANDLER);
				var arg:MetaTagArg = metaTag.argByKey(Args.EVENT);

				var eventName:String = getEventName(arg);

				var eventHandler:EventHandler = addToDispatchers(eventName, target[method.name], metaTag);

				if (handlers[target] == null)
				{
					handlers[target] = [];
				}

				handlers[target].push(eventHandler);
			}
		}

		public function tearDown(bean:Bean):void
		{
			if (handlers[bean.instance] == null)
				return;

			for each(var handler:EventHandler in handlers[bean.instance])
			{
				for each(var dispatcher:EventDispatcher in dispatchers)
				{
					dispatcher.removeEventListener(handler.type, handler.handleEvent);
				}
			}

			handlers[bean] = [];
		}

		private function getEventName(arg:MetaTagArg):String
		{
			var dots:Array = arg.value.split(".");

			if (dots.length == 1)
			{
				return arg.value;
			}
			else if (dots.length >= 2)
			{
				var eventClassName:String = arg.value.split(".")[dots.length-2];
				var EventClass:Class = getEventClass(eventClassName);

				if (!EventClass) throw new EventClassNotFoundError(eventClassName);

				var eventName:String = arg.value.split(".")[dots.length-1];

				if (!eventName || EventClass[eventName] == null)
				{
					throw new EventTypeNotFoundOnClassError(eventName, eventClassName);
				}
				else
				{
					return EventClass[eventName];
				}
			}
			else
			{
				throw new InvalidEventTypeError(arg.value);
			}
		}

		public function getEventClass(eventClassName:String):Class
		{
			var EventClass:Class;

			for each(var pack:String in eventPackages)
			{
				try
				{
					EventClass = Class(getDefinitionByName(pack + "." + eventClassName));
					return EventClass;
				}
				catch (e:Error)
				{
					trace("EventClass not found in package. Checking next package.");
				}
			}

			return null;
		}

		public function addToDispatchers(event:String, handler:Function, tag:MetaTag):EventHandler
		{
			var eventHandler:EventHandler = new EventHandler(event, handler, tag);

			for each(var dispatcher:EventDispatcher in dispatchers)
			{
				dispatcher.addEventListener(event, eventHandler.handleEvent);
			}

			return eventHandler;
		}
	}
}

import com.creativebottle.starlingmvc.constants.Args;
import com.creativebottle.starlingmvc.errors.PropertyNotFoundError;
import com.creativebottle.starlingmvc.reflection.MetaTag;
import com.creativebottle.starlingmvc.reflection.MetaTagArg;
import com.creativebottle.starlingmvc.utils.StringUtils;

import starling.events.Event;

class EventHandler
{
	public var type:String;

	private var handler:Function;
	private var args:Array;

	public function EventHandler(type:String, handler:Function, tag:MetaTag)
	{
		this.type = type;
		this.handler = handler;

		var arg:MetaTagArg = tag.argByKey(Args.PROPERTIES);

		if (arg)
			args = String(arg.value).split(",");
	}

	public function handleEvent(event:Event):void
	{
		var handlerArgs:Array = [];

		for each(var arg:String in args)
		{
			arg = StringUtils.removeWhitespace(arg);

			if (event.hasOwnProperty(arg))
			{
				handlerArgs.push(event[arg]);
			}
			else
			{
				throw new PropertyNotFoundError(arg, typeof event);
			}
		}

		if (handlerArgs.length > 0)
		{
			handler.apply(null, handlerArgs);
		}
		else
		{
			handler(event);
		}
	}
}
