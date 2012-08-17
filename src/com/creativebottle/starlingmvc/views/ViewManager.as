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
package com.creativebottle.starlingmvc.views
{
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class ViewManager
	{
		private var srcClip:Sprite;
		private var view:DisplayObject;
		private var stack:Array = [];

		public function ViewManager(srcClip:Sprite)
		{
			this.srcClip = srcClip;
		}

		public function addView(view:DisplayObject):DisplayObject
		{
			if (stack.indexOf(view) == -1)
			{
				stack.push(view);

				srcClip.addChild(view);
			}

			return view;
		}

		public function removeView(view:DisplayObject, dispose:Boolean = false):void
		{
			var idx:int = stack.indexOf(view);

			if (idx != -1)
			{
				srcClip.removeChild(view, dispose);

				stack.splice(idx, 1);
			}
		}

		public function popView(dispose:Boolean = false):void
		{
			removeView(stack[stack.length - 1], dispose);
		}

		public function removeAll(dispose:Boolean = false):void
		{
			for each(var s:DisplayObject in stack)
			{
				removeView(s, dispose);
			}
		}

		public function setView(ViewClass:Class, params:Object = null, disposeOfLast:Boolean = false):DisplayObject
		{
			removeExistingView(disposeOfLast);

			view = DisplayObject(new ViewClass());

			removeAll();

			srcClip.addChild(view);

			return view;
		}

		private function removeExistingView(dispose:Boolean):void
		{
			if (view)
			{
				srcClip.removeChild(view, dispose);
			}
		}
	}

}
