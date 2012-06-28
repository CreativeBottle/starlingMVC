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
	import com.creativebottle.starlingmvc.beans.ProtoBean;
	import com.creativebottle.starlingmvc.constants.Tags;
	import com.creativebottle.starlingmvc.events.BeanEvent;
	import com.creativebottle.starlingmvc.reflection.ClassDescriptor;
	import com.creativebottle.starlingmvc.reflection.ClassMember;
	import com.creativebottle.starlingmvc.reflection.MetaTagArg;
	import com.creativebottle.starlingmvc.utils.BeanUtils;
	import com.creativebottle.starlingmvc.utils.ClassDescriptorCache;

	import flash.utils.getDefinitionByName;

	import starling.events.EventDispatcher;

	public class InjectProcessor implements IProcessor
	{
		private var dispatcher:EventDispatcher;

		public function config(starlingMVC:StarlingMVC):void
		{
			this.dispatcher = starlingMVC.dispatcher;
		}

		public function process(object:Object, beans:Beans):void
		{
			var targetBean:Bean = BeanUtils.normalizeBean(object);
			var target:Object = targetBean.instance;
			if (!target) return;

			var classDescriptor:ClassDescriptor = ClassDescriptorCache.getClassDescriptorForInstance(target);

			var injections:Array = classDescriptor.membersByMetaTag(Tags.INJECT);

			for each(var property:ClassMember in injections)
			{
				var arg:MetaTagArg = property.tagByName(Tags.INJECT).argByKey("source");

				var sourceBean:Bean;
				var source:Object;

				if (arg)
				{
					sourceBean = beans.getBeanById(arg.value);

					if (sourceBean is ProtoBean)
					{
						var protoBean:ProtoBean = ProtoBean(sourceBean);
						source = new protoBean.classType();

						dispatcher.dispatchEvent(new BeanEvent(BeanEvent.ADD_BEAN, source));
					}
					else
					{
						source = sourceBean.instance;
					}
				}
				else
				{
					var TempClass:Class = Class(getDefinitionByName(property.classname));
					sourceBean = beans.getBeanByClass(TempClass);

					source = sourceBean.instance;
				}

				target[property.name] = source;
			}
		}
	}
}
