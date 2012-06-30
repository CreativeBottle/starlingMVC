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
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.reflection.ClassDescriptor;
	import com.creativebottle.starlingmvc.reflection.Method;
	import com.creativebottle.starlingmvc.utils.ClassDescriptorCache;

	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class BaseMediatorProcessor
	{
		protected function announceToMediators(view:Object, beans:Beans, tag:String):void
		{
			var className:String = getQualifiedClassName(view);
			var ViewClass:Class = Class(getDefinitionByName(className));

			for each(var targetBean:Bean in beans.beans)
			{
				var target:Object = targetBean.instance;
				if (!target) continue;

				var classDescriptor:ClassDescriptor = ClassDescriptorCache.getClassDescriptorForInstance(target);

				var taggedMethods:Array = classDescriptor.membersByMetaTag(tag);

				for each(var method:Method in taggedMethods)
				{
					if (method.parameters.length == 1 && method.parameters[0].type == ViewClass)
					{
						target[method.name](view);
					}
				}
			}
		}
	}
}
