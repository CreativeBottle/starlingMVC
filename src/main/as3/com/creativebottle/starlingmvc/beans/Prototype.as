package com.creativebottle.starlingmvc.beans
{
	public class Prototype extends Bean
	{
		public function get classType():Class
		{
			return _classType;
		}

		private var _classType:Class;

		public function Prototype(classType:Class, id:String)
		{
			super(null, id);

			_classType = classType;
		}
	}
}