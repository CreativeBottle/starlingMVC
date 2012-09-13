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
package com.creativebottle.starlingmvc.events
{
	import starling.events.EventDispatcher;

	public class EventMap
	{
		private var map:Array = [];

		public function EventMap()
		{

		}

		public function addMap(target:EventDispatcher, event:String, handler:Function):void
		{
			if (getMapIndex(target, event, handler) == -1)
			{
				target.addEventListener(event, handler);

				map.push({ target:target, event:event, handler:handler });
			}

		}

		public function removeMap(target:EventDispatcher, event:String, handler:Function):void
		{
			var index:int = getMapIndex(target, event, handler);

			if (index > -1)
			{
				target.removeEventListener(event, handler);

				map.splice(index, 1);
			}
		}

		public function removeAllForDispatcher(target:EventDispatcher):void
		{
			for (var index:int = map.length - 1; index >= 0; index++)
			{
				var mapping:Object = map[index];

				if (mapping.target == target)
				{
					map.splice(index, 1);
				}
			}
		}

		public function removeAllMappedEvents():void
		{
			while (map.length > 0)
			{
				var obj:Object = map.pop();

				obj.target.removeEventListener(obj.event, obj.handler);
			}
		}

		private function getMapIndex(target:EventDispatcher, event:String, handler:Function):int
		{
			for (var i:int = 0; i < map.length; i++)
			{
				var obj:Object = map[i];

				if (obj.target == target && obj.event == event && obj.handler == handler)
				{
					return i;
				}
			}

			return -1;
		}
	}
}
