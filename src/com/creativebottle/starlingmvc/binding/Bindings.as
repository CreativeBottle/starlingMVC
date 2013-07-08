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
	import starling.animation.IAnimatable;
	import starling.core.Starling;

	public class Bindings implements IAnimatable
	{
		private const autoBindings:Array = [];
		private const bindings:Array = [];
		private var running:Boolean;
		private var invalidated:Array = [];

		public function invalidate(instance:Object, propertyName:String):void
		{
			var bindings:Vector.<Binding> = getBindings(instance, propertyName);
			
			for each (var binding:Binding in bindings)
			{
				var alreadyInvalidated:Boolean = invalidated.indexOf(binding) != -1;
	
				if (binding && !alreadyInvalidated)
				{
					invalidated.push(binding);
				}
			}
		}

		public function addBinding(binding:Binding, auto:Boolean = true):void
		{
			if (!bindingExists(binding))
			{
				if (auto)
					autoBindings.push(binding);
				else
					bindings.push(binding);
			}

			determineIfShouldRun();
			binding.apply();
		}

		public function removeBinding(binding:Binding):void
		{
			var idx:int = autoBindings.indexOf(binding);

			if (idx != -1)
				autoBindings.splice(idx, 1);

			idx = bindings.indexOf(binding);

			if (idx != -1)
				bindings.splice(idx, 1);

			determineIfShouldRun();
		}

		public function removeBindingsForTarget(target:Object):void
		{
			removeFromArrayIfUsesTarget(target, autoBindings);
			removeFromArrayIfUsesTarget(target, bindings);
			removeFromArrayIfUsesTarget(target, invalidated);

			determineIfShouldRun();
		}

		private function removeFromArrayIfUsesTarget(target:Object, collection:Array):void
		{
			for (var i:int = collection.length - 1; i >= 0; i--)
			{
				var binding:Binding = collection[i];

				if (binding.usesTarget(target))
				{
					collection.splice(i, 1);
				}
			}
		}

		private function determineIfShouldRun():void
		{
			if (autoBindings.length > 0 || bindings.length > 0)
			{
				if (!running)
				{
					Starling.juggler.add(this);
					running = true;
				}
			}
			else
			{
				if (running)
				{
					Starling.juggler.remove(this);
					running = false;
				}
			}
		}

		public function advanceTime(time:Number):void
		{
			var i:int;
			var binding:Binding;

			for (i = 0; i < autoBindings.length; i++)
			{
				binding = autoBindings[i];

				if (binding.changed)
				{
					binding.apply();
				}
			}

			for (i = invalidated.length - 1; i >= 0; i--)
			{
				binding = invalidated[i];
				binding.apply();

				invalidated.splice(i, 1);
			}
		}
		
		// In case more than one object is binded to the same property
		private function getBindings(instance:Object, propertyName:String):Vector.<Binding>
		{
			var result:Vector.<Binding> = new Vector.<Binding>();
			
			for each (var binding:Binding in bindings)
			{
				if (binding.fromTarget == instance && binding.fromPropertyName == propertyName)
				{
					result.push(binding);
				}
			}
			
			return result;
		}

		private function getBinding(instance:Object, propertyName:String):Binding
		{
			for each (var binding:Binding in bindings)
			{
				if (binding.fromTarget == instance && binding.fromPropertyName == propertyName)
				{
					return binding;
				}
			}

			return null;
		}

		private function bindingExists(bindingIn:Binding):Boolean
		{
			var binding:Binding;

			for each (binding in autoBindings)
			{
				if (areEqual(binding, bindingIn))
					return true;
			}

			for each (binding in bindings)
			{
				if (areEqual(binding, bindingIn))
					return true;
			}

			return false;
		}

		private function areEqual(bindingOne:Binding, bindingTwo:Binding):Boolean
		{
			return bindingOne.fromTarget == bindingTwo.fromTarget && bindingOne.toTarget == bindingTwo.toTarget && bindingOne.fromPropertyName == bindingTwo.fromPropertyName && bindingOne.toPropertyName == bindingTwo.toPropertyName;
		}
	}
}
