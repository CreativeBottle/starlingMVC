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
	import com.creativebottle.starlingmvc.errors.PropertyNotFoundError;
	import com.creativebottle.starlingmvc.reflection.ClassDescriptor;
	import com.creativebottle.starlingmvc.reflection.ClassMember;
	import com.creativebottle.starlingmvc.reflection.MetaTag;
	import com.creativebottle.starlingmvc.reflection.MetaTagArg;
	import com.creativebottle.starlingmvc.utils.BeanUtils;
	import com.creativebottle.starlingmvc.utils.ClassDescriptorCache;
	import com.creativebottle.starlingmvc.utils.StringUtils;

	import starling.events.Event;

	public class ExecuteProcessor implements IProcessor
	{
		public var eventPackages:Array;
		public var event:Event;

		public function config(starlingMVC:StarlingMVC):void
		{
			this.eventPackages = starlingMVC.config.eventPackages;
		}

		public function setUp(object:Object, beans:Beans):void
		{
			var targetBean:Bean = BeanUtils.normalizeBean(object);
			var target:Object = targetBean.instance;
			if (!target) return;

			var classDescriptor:ClassDescriptor = ClassDescriptorCache.getClassDescriptorForInstance(target);

			var executeHandlers:Array = classDescriptor.membersByMetaTag(Tags.EXECUTE);

			for each(var method:ClassMember in executeHandlers)
			{
				var tag:MetaTag = method.tagByName(Tags.EXECUTE);

				var arg:MetaTagArg = tag.argByKey(Args.PROPERTIES);
				var args:Array;

				if (arg)
					args = String(arg.value).split(",");

				var handlerArgs:Array = getHandlerArgs(args);

				if (handlerArgs.length > 0)
				{
					target[method.name].apply(null, handlerArgs);
				}
				else
				{
					target[method.name](event);
				}
			}
		}

		private function getHandlerArgs(args:Array):Array
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

			return handlerArgs;
		}

		public function tearDown(bean:Bean):void
		{
		}
	}
}