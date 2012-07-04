package com.creativebottle.starlingmvc.binding
{
	import starling.animation.IAnimatable;
	import starling.core.Starling;

	public class Bindings implements IAnimatable
	{
		private const bindings:Array = [];
		private var running:Boolean;

		public function Bindings()
		{

		}

		public function addBinding(binding:Binding):void
		{
			bindings.push(binding);
			determineIfShouldRun();
			binding.apply();
		}

		public function removeBinding(binding:Binding):void
		{
			var idx:int = bindings.indexOf(binding);
			bindings.splice(idx, 1);
			determineIfShouldRun();
		}

		public function removeBindingsForTarget(target:Object):void
		{
			for (var i:int = bindings.length - 1; i >= 0; i--)
			{
				var binding:Binding = bindings[i];

				if (binding.usesTarget(target))
				{
					bindings.splice(i, 1);
				}
			}
			determineIfShouldRun();
		}

		private function determineIfShouldRun():void
		{
			if (bindings.length > 0)
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
			for (var i:int = 0; i < bindings.length; i++)
			{
				var binding:Binding = bindings[i];

				if (binding.changed)
				{
					binding.apply();
				}
			}
		}
	}
}