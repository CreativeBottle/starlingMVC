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
package com.creativebottle.starlingmvc.beans
{
	public class Bean
	{
		public function get instance():Object
		{
			return _instance;
		}

		private var _instance:Object;

		public function get id():String
		{
			return _id;
		}

		private var _id:String;

		/**
		 * Register a <code>Bean</code> by its <code>Class</code> or id.
		 *
		 * For lazy instantiation, see <code>ProtoBean</code>.
		 */
		public function Bean(instance:Object, id:String = null)
		{
			_instance = instance;
			_id = id;
		}
	}
}
