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
package com.creativebottle.starlingmvc
{
	import com.creativebottle.starlingmvc.beans.BeanFactory;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.binding.Bindings;
	import com.creativebottle.starlingmvc.commands.Commands;
	import com.creativebottle.starlingmvc.config.StarlingMVCConfig;
	import com.creativebottle.starlingmvc.events.StarlingMVCEvent;
	import com.creativebottle.starlingmvc.processors.Processors;

	import starling.display.DisplayObjectContainer;
	import starling.events.EventDispatcher;

	public class StarlingMVC
	{
		public const dispatcher:EventDispatcher = new EventDispatcher();
		public const beans:Beans = new Beans();

		public var initialized:Boolean = false;

		private var _config:StarlingMVCConfig;
		private var _rootLayer:DisplayObjectContainer;
		private var _processors:Processors;
		private var beanFactory:BeanFactory;
		private var _bindings:Bindings = new Bindings();
		private var _commands:Commands;

		public function get config():StarlingMVCConfig
		{
			return _config;
		}

		public function get rootLayer():DisplayObjectContainer
		{
			return _rootLayer;
		}

		public function get processors():Processors
		{
			return _processors;
		}

		public function get bindings():Bindings
		{
			return _bindings;
		}

        public function get commands():Commands
        {
            return _commands;
        }

		public function set beanProviders(value:Array):void
		{
			beans.addBeans(value);

			if (processors)
				processors.processAll();
		}

		public function set customProcessors(value:Array):void
		{
			if (!value) return;

			for (var i:int = 0; i < value.length; i++)
			{
				processors.addProcessor(value[i]);
			}

			processors.processAll();
		}

		public function StarlingMVC(rootLayer:DisplayObjectContainer = null, config:StarlingMVCConfig = null, beanProviders:Array = null, customProcessors:Array = null)
		{
			_rootLayer = rootLayer;
			_config = config;

			this.customProcessors = customProcessors;
			this.beanProviders = beanProviders;

			beanFactory = new BeanFactory(this);
			_processors = new Processors(this);
			_commands = new Commands(this);

			initialized = true;
			dispatcher.dispatchEvent(new StarlingMVCEvent(StarlingMVCEvent.INITIALIZED))
		}
	}
}