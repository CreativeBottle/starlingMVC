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
package com.creativebottle.starlingmvc.utils
{
	import com.creativebottle.starlingmvc.reflection.ClassDescriptor;

	import flash.utils.Dictionary;

	public class ClassDescriptorCache
	{
		private static const classDescriptorCache:Dictionary = new Dictionary();

		public static function getClassDescriptorForInstance(object:Object):ClassDescriptor
		{
			var classDescriptor:ClassDescriptor;

			if (classDescriptorCache[object.constructor])
			{
				classDescriptor = classDescriptorCache[object.constructor];
			}
			else
			{
				classDescriptor = new ClassDescriptor(object);

				classDescriptorCache[object.constructor] = classDescriptor;
			}
			return classDescriptor;
		}
	}
}
