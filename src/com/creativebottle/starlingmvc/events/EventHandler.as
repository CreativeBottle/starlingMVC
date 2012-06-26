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
	import com.creativebottle.system.meta.MetaTag;
	import com.creativebottle.system.meta.MetaTagArg;

	import starling.events.Event;

	public class EventHandler
	{
		private var handler:Function;
		private var args:Array;

		public function EventHandler(handler:Function, tag:MetaTag)
		{
			this.handler = handler;

			var arg:MetaTagArg = tag.argByName("properties");

			if (arg)
				args = String(arg.value).split(",");
		}

		public function handleEvent(event:Event):void
		{
			var handlerArgs:Array = new Array();

			for each(var arg:String in args)
			{
				if (event[arg])
				{
					handlerArgs.push(event[arg]);
				}
				else
				{
					throw new Error("Property " + arg + " doesn't exit on event type " + typeof event);
				}
			}

			if (handlerArgs.length > 0)
			{
				handler.apply(null, handlerArgs);
			}
			else
			{
				handler(event);
			}
		}
	}
}