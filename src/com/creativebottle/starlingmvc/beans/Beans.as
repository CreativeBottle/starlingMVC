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
	import com.creativebottle.starlingmvc.commands.Command;
	import com.creativebottle.starlingmvc.constants.Tags;
	import com.creativebottle.starlingmvc.errors.BeanNotFoundError;
	import com.creativebottle.starlingmvc.reflection.ClassDescriptor;
	import com.creativebottle.starlingmvc.reflection.ClassMember;
	import com.creativebottle.starlingmvc.utils.BeanUtils;
	import com.creativebottle.starlingmvc.utils.ClassDescriptorCache;

	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class Beans
	{
		public const beans:Dictionary = new Dictionary(true);
		public const commands:Dictionary = new Dictionary(true);

		public function addBean(beanIn:*):void
		{
			var bean:Bean = BeanUtils.normalizeBean(beanIn);

			if (bean is ProtoBean)
			{
				createMap(ProtoBean(bean).classType, bean);
			}
			else if (bean.instance is Command)
			{
				mapCommand(bean);
			}
			else
			{
				var className:String = getQualifiedClassName(bean.instance);
				var myClass:Class = Class(getDefinitionByName(className));

				createMap(myClass, bean);
			}
		}

		public function removeBean(beanIn:Bean):void
		{
			var bean:Bean;

			for each(bean in beans)
			{
				if (!bean.instance) continue;

				var classDescriptor:ClassDescriptor = ClassDescriptorCache.getClassDescriptorForInstance(bean.instance);

				var injections:Array = classDescriptor.membersByMetaTag(Tags.INJECT);

				for each(var member:ClassMember in injections)
				{
					if (bean.instance[member.name] == beanIn.instance)
						bean.instance[member.name] = null;
				}

			}

			for (var key:Object in beans)
			{
				bean = beans[key];

				if (bean.instance == beanIn.instance)
				{
					beans[key] = null;
					delete beans[key];
				}
			}
		}

		public function addBeans(beanProviders:Array):void
		{
			for each(var provider:Object in beanProviders)
			{
				if (provider is BeanProvider)
				{
					addBeanProvider(BeanProvider(provider));
				}
				else
				{
					addBean(provider);
				}
			}

		}

		public function addBeanProvider(beanProviders:BeanProvider):void
		{
			for each(var bean:Object in beanProviders.beans)
			{
				if (bean is BeanProvider)
					addBeanProvider(BeanProvider(bean));
				else
					addBean(bean);
			}
		}

		public function getCommandForEvent(eventType:String):Command
		{
			return commands[eventType];
		}

		private function createMap(MapClass:Class, bean:Bean):void
		{
			if (bean.id)
			{
				beans[bean.id] = bean;
			}
			else
			{
				beans[MapClass] = bean;
			}
		}

		private function mapCommand(bean:Bean):void
		{
			var command:Command = Command(bean.instance);

			if (commands[command.event])
			{
				throw new Error("A command for that event(" + command.event + ") already exists.");
			}
			else
			{
				commands[command.event] = command;
			}
		}

		public function getBeanByClass(BeanClass:Class):Bean
		{
			return beans[BeanClass];
		}

		public function getBeanById(id:String):Bean
		{
			var output:Bean = beans[id];
			if (!output)
			{
				throw new BeanNotFoundError(id);
			}
			return output;
		}
	}
}
