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
package com.creativebottle.starlingmvc.reflection
{
	import flash.utils.getDefinitionByName;

	public class Parameter
	{
		public var index:int;
		public var type:Class;
		public var optional:Boolean;

		public function Parameter(xml:XML)
		{
			index = int(xml.@index);
			type = getDefinitionByName(xml.@type) as Class;
			optional = xml.@optional == "true";
		}
	}
}
