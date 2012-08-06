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
package com.creativebottle.starlingmvc.binding
{
	public class Binding
	{
		internal var fromTarget:Object;
		internal var toTarget:Object;
		internal var fromPropertyName:String;
		internal var toPropertyName:String;
		private var oldValue:Object;

		public function get changed():Boolean
		{
			return fromTarget[fromPropertyName] != oldValue;
		}

		public function Binding(fromTarget:Object, fromPropertyName:String, toTarget:Object, toPropertyName:String)
		{
			this.fromTarget = fromTarget;
			this.fromPropertyName = fromPropertyName;
			this.toTarget = toTarget;
			this.toPropertyName = toPropertyName;

			oldValue = fromTarget[fromPropertyName];
		}

		public function apply():void
		{
			var newValue:Object = fromTarget[fromPropertyName];

			toTarget[toPropertyName] = newValue;
			oldValue = newValue;
		}

		public function unbind():void
		{
			fromTarget = null;
			fromPropertyName = null;
			toTarget = null;
			toPropertyName = null;
		}

		public function usesTarget(target:Object):Boolean
		{
			return fromTarget == target || toTarget == target;
		}

	}
}