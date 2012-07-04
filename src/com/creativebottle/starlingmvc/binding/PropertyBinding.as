package com.creativebottle.starlingmvc.binding
{
	public class PropertyBinding
	{
		private var fromTarget:Object;
		private var toTarget:Object;
		private var fromPropertyName:String;
		private var toPropertyName:String;
		private var oldValue:Object;

		public function PropertyBinding(fromTarget:Object, fromPropertyName:String, toTarget:Object, toPropertyName:String)
		{
			this.fromTarget = fromTarget;
			this.fromPropertyName = fromPropertyName;
			this.toTarget = toTarget;
			this.toPropertyName = toPropertyName;

			oldValue = fromTarget[fromPropertyName];
		}

		public function check():void
		{
			var newValue:Object = fromTarget[fromPropertyName];

			if (newValue != oldValue)
			{
				toTarget[toPropertyName] = newValue;
				oldValue = newValue;
			}
		}
	}
}