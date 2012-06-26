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
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.utils.BeanUtils;

	import starling.events.Event;

	public class BeanEvent extends Event
	{
		public static const ADD_BEAN:String = "addBean";
		public static const REMOVE_BEAN:String = "removeBean";

		public function get bean():Bean
		{
			return _bean;
		}

		private var _bean:Bean;

		public function BeanEvent(type:String, beanIn:Object):void
		{
			super(type, true);

			_bean = BeanUtils.normalizeBean(beanIn);
		}
	}
}