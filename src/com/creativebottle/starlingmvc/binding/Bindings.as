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
			var binding:Binding = getBinding(instance, propertyName);
			var alreadyInvalidated:Boolean = invalidated.indexOf(binding) != -1;

			if (binding && !alreadyInvalidated)
			{
				invalidated.push(binding);
			}
		}

		public function addBinding(binding:Binding, auto:Boolean = true):void
		{
			if (auto)
			{
				autoBindings.push(binding);
			}
			else
			{
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
	}
}
