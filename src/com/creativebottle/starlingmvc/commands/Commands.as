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
package com.creativebottle.starlingmvc.commands
{
	import com.creativebottle.starlingmvc.StarlingMVC;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.processors.DispatcherProcessor;
	import com.creativebottle.starlingmvc.processors.ExecuteProcessor;
	import com.creativebottle.starlingmvc.processors.InjectProcessor;

	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class Commands
	{
		private var starlingMVC:StarlingMVC;
		private var beans:Beans;
		private var dispatcher:EventDispatcher;
		private var rootLayer:DisplayObjectContainer;

		public function Commands(starlingMVC:StarlingMVC)
		{
			this.starlingMVC = starlingMVC;
			beans = starlingMVC.beans;
			dispatcher = starlingMVC.dispatcher;
			rootLayer = starlingMVC.rootLayer;

			for each(var command:Command in beans.commands)
			{
				addCommand(command);
			}
		}

        public function addCommand(command:Command):void
        {
            dispatcher.addEventListener(command.event, handleCommandEvent);
            rootLayer.addEventListener(command.event, handleCommandEvent);
        }

        public function removeCommand(command:Command):void
        {
            dispatcher.removeEventListener(command.event, handleCommandEvent);
            rootLayer.removeEventListener(command.event, handleCommandEvent);
        }

		private function handleCommandEvent(event:Event):void
		{
			var command:Command = beans.getCommandForEvent(event.type);
			var CommandClass:Class = command.command;

			var commandInstance:Object = new CommandClass();

			var injectProcessor:InjectProcessor = new InjectProcessor();
			injectProcessor.config(starlingMVC);
			injectProcessor.setUp(commandInstance, beans);

			var dispatcherProcessor:DispatcherProcessor = new DispatcherProcessor();
			dispatcherProcessor.config(starlingMVC);
			dispatcherProcessor.setUp(commandInstance, beans);

			var executeProcessor:ExecuteProcessor = new ExecuteProcessor();
			executeProcessor.config(starlingMVC);
			executeProcessor.event = event;
			executeProcessor.setUp(commandInstance, beans);

			commandInstance = null;

			if (command.oneTime)
			{
				removeCommand(command);
			}
		}
	}
}