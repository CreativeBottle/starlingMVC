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
	public class Command
	{
		public function get event():String
		{
			return _event;
		}

		private var _event:String;

		public function get command():Class
		{
			return _command;
		}

		private var _command:Class;

		public function get oneTime():Boolean
		{
			return _oneTime;
		}

		private var _oneTime:Boolean;

		public function Command(event:String, command:Class, oneTime:Boolean = false)
		{
			_event = event;
			_command = command;
			_oneTime = oneTime;
		}
	}
}