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
	import com.creativebottle.starlingmvc.reflection.ClassDescriptor;
	import com.creativebottle.starlingmvc.reflection.ClassMember;
	import com.creativebottle.starlingmvc.reflection.Method;
	import com.creativebottle.starlingmvc.utils.ClassDescriptorCache;

	public class PreDestroyProcessor implements IProcessor
	{
		public function config(starlingMVC:StarlingMVC):void
		{

		}

		public function setUp(object:Object, beans:Beans):void
		{

		}

		public function tearDown(bean:Bean):void
		{
			var target:Object = bean.instance;
			if (!target) return;

			var classDescriptor:ClassDescriptor = ClassDescriptorCache.getClassDescriptorForInstance(target);

			// Handle pre destroys
			var preDestroys:Array = classDescriptor.membersByMetaTag(Tags.PRE_DESTROY);

			for each(var method:ClassMember in preDestroys)
			{
				if (method is Method)
				{
					target[ method.name ]();
				}
			}
		}
	}
}
