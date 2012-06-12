package com.creativebottle.starlingmvc.beans
{
	public class Prototype extends Bean
	{
		public var ClassType:Class;

		public function Prototype(ClassType:Class, id:String)
		{
			super(null, id);

			this.ClassType = ClassType;
		}
	}
}