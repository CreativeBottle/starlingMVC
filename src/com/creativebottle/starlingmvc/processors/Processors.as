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

	public class Processors
	{
		private var processors:Array = [];
		private var beans:Beans;
		private var starlingMVC:StarlingMVC;

		public function Processors(starlingMVC:StarlingMVC)
		{
			this.starlingMVC = starlingMVC;
			beans = starlingMVC.beans;

			setUpDefaultProcessors();
		}

		public function addProcessor(processor:IProcessor):void
		{
			processor.config(starlingMVC);

			processors.push(processor);
		}

		public function processAll():void
		{
			for each(var bean:Bean in beans.beans)
			{
				processOn(bean, beans);
			}
		}

		public function processOn(object:Object, beans:Beans):void
		{
			for each(var processor:IProcessor in processors)
			{
				processor.process(object, beans);
			}
		}

		private function setUpDefaultProcessors():void
		{
			addProcessor(new DispatcherProcessor());
			addProcessor(new JugglerProcessor());
			addProcessor(new InjectProcessor());
			addProcessor(new PostConstructProcessor());
			addProcessor(new EventHandlerProcessor());
			processAll();
		}
	}
}
