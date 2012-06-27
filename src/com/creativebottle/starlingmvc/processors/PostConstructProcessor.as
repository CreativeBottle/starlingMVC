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
	import com.creativebottle.starlingmvc.constants.Tags;
	import com.creativebottle.starlingmvc.meta.MetaClass;
	import com.creativebottle.starlingmvc.meta.MetaClassMember;
	import com.creativebottle.starlingmvc.meta.MetaMethod;
	import com.creativebottle.starlingmvc.utils.BeanUtils;
	import com.creativebottle.starlingmvc.utils.MetaClassCache;

	public class PostConstructProcessor implements IProcessor
	{
		public function config(starlingMVC:StarlingMVC):void
		{

		}

		public function process(object:Object, beans:Beans):void
		{
			var bean:Bean = BeanUtils.normalizeBean(object);

			if (!bean.instance) return;

			var metaClass:MetaClass = MetaClassCache.getMetaClassForInstance(bean.instance);

			// Handle post constructs
			var postConstructs:Array = metaClass.membersByMetaTag(Tags.POST_CONSTRUCT);

			for each(var method:MetaClassMember in postConstructs)
			{
				if (method is MetaMethod)
				{
					bean.instance[ method.name ]();
				}
			}
		}
	}
}
