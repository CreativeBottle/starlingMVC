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
	import com.creativebottle.starlingmvc.binding.Binding;
	import com.creativebottle.starlingmvc.binding.Bindings;
	import com.creativebottle.starlingmvc.constants.Args;
	import com.creativebottle.starlingmvc.constants.Tags;
	import com.creativebottle.starlingmvc.errors.BeanNotFoundError;
	import com.creativebottle.starlingmvc.errors.PropertyNotFoundError;
	import com.creativebottle.starlingmvc.events.BeanEvent;
	import com.creativebottle.starlingmvc.reflection.ClassDescriptor;
	import com.creativebottle.starlingmvc.reflection.ClassMember;
	import com.creativebottle.starlingmvc.reflection.MetaTag;
	import com.creativebottle.starlingmvc.reflection.MetaTagArg;
	import com.creativebottle.starlingmvc.utils.BeanUtils;
	import com.creativebottle.starlingmvc.utils.ClassDescriptorCache;

	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import starling.events.EventDispatcher;

	public class InjectProcessor implements IProcessor
	{
		private var dispatcher:EventDispatcher;
		private var bindings:Bindings;

		public function config(starlingMVC:StarlingMVC):void
		{
			this.dispatcher = starlingMVC.dispatcher;
			this.bindings = starlingMVC.bindings;
		}

		public function setUp(object:Object, beans:Beans):void
		{
			var targetBean:Bean = BeanUtils.normalizeBean(object);
			var target:Object = targetBean.instance;
			if (!target)
				return;

			var classDescriptor:ClassDescriptor = ClassDescriptorCache.getClassDescriptorForInstance(target);

			var injections:Array = classDescriptor.membersByMetaTag(Tags.INJECT);

			for each (var property:ClassMember in injections)
			{
				var injectTag:MetaTag = property.tagByName(Tags.INJECT);
				var sourceArg:MetaTagArg = injectTag.argByKey(Args.SOURCE);

				var sourceBean:Bean;
				var source:Object;
				var binding:Binding = null;
				var autoBind:Boolean = true;

				if (sourceArg)
				{
					var splitArg:Array = sourceArg.value.split(".");
					var beanId:String = splitArg.shift();

					sourceBean = beans.getBeanById(beanId);

					if (sourceBean is ProtoBean)
					{
						var protoBean:ProtoBean = ProtoBean(sourceBean);
						source = new protoBean.classType();

						dispatcher.dispatchEvent(new BeanEvent(BeanEvent.ADD_BEAN, source));
					}
					else
					{
						var bindArg:MetaTagArg = injectTag.argByKey(Args.BIND);
						var autoArg:MetaTagArg = injectTag.argByKey(Args.AUTO);

						var isBound:Boolean;

						if (bindArg)
						{
							isBound = bindArg.value == "true";

							if (autoArg)
								autoBind = autoArg.value == "true";
						}

						source = sourceBean.instance;

						var propName:String;

						while (propName = splitArg.shift())
						{
							if (source.hasOwnProperty(propName))
							{
								if (isBound && splitArg.length == 0)
								{
									binding = new Binding(source, propName, target, property.name);
									bindings.addBinding(binding, autoBind);
								}

								source = source[propName];
							}
							else
							{
								throw new PropertyNotFoundError(propName, getQualifiedClassName(source));
							}
						}
					}
				}
				else
				{
					var TempClass:Class = Class(getDefinitionByName(property.classname));
					sourceBean = beans.getBeanByClass(TempClass);

					if (sourceBean)
					{
						source = sourceBean.instance;
					}
					else
					{
						throw new BeanNotFoundError(property.classname);
					}
				}

				if (!binding)
				{
					target[property.name] = source;
				}
			}
		}

		public function tearDown(bean:Bean):void
		{
		}
	}
}
