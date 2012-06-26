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
	import com.creativebottle.starlingmvc.utils.BeanUtils;
	import com.creativebottle.starlingmvc.utils.MetaClassCache;
	import com.creativebottle.system.injection.InjectionTag;
	import com.creativebottle.system.meta.MetaClass;
	import com.creativebottle.system.meta.MetaClassMember;

	import starling.events.EventDispatcher;

	public class DispatcherProcessor implements IProcessor
	{
		private var dispatcher:EventDispatcher;

		public function config(starlingMVC:StarlingMVC):void
		{
			this.dispatcher = starlingMVC.dispatcher;
		}

		public function process(object:Object, beans:Beans):void
		{
			var bean:Bean = BeanUtils.normalizeBean(object);

			if (!bean.instance) return;

			var metaClass:MetaClass = MetaClassCache.getMetaClassForInstance(bean.instance);

			var injections:Array = metaClass.membersByMetaTag(InjectionTag.DISPATCHER);

			for each(var member:MetaClassMember in injections)
			{
				bean.instance[ member.name ] = dispatcher;
			}
		}
	}
}