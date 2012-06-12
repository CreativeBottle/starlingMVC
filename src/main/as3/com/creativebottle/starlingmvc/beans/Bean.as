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

		public function Bean(instance:Object, id:String = null)
		{
			_instance = instance;
			_id = id;
		}
	}
}