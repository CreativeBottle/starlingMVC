package com.creativebottle.starlingmvc.binding
{
	public class Binding
	{
		private var fromTarget:Object;
		private var toTarget:Object;
		private var fromPropertyName:String;
		private var toPropertyName:String;
		private var oldValue:Object;

		public function get changed():Boolean
		{
			return fromTarget[fromPropertyName] != oldValue;
		}

		public function Binding(fromTarget:Object, fromPropertyName:String, toTarget:Object, toPropertyName:String)
		{
			this.fromTarget = fromTarget;
			this.fromPropertyName = fromPropertyName;
			this.toTarget = toTarget;
			this.toPropertyName = toPropertyName;

			oldValue = fromTarget[fromPropertyName];
		}

		public function apply():void
		{
			var newValue:Object = fromTarget[fromPropertyName];

			toTarget[toPropertyName] = newValue;
			oldValue = newValue;
		}

		public function unbind():void
		{
			fromTarget = null;
			fromPropertyName = null;
			toTarget = null;
			toPropertyName = null;
		}

		public function usesTarget(target:Object):Boolean
		{
			return fromTarget == target || toTarget == target;
		}

	}
}