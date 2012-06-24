package com.creativebottle.starlingmvc.events
{
	import com.creativebottle.starlingmvc.beans.Bean;

	import starling.events.Event;

	public class BeanEvent extends Event
	{
		public static const ADD_BEAN:String = "addBean";
		public static const REMOVE_BEAN:String = "removeBean";

		public function get bean():Bean
		{
			return _bean;
		}

		private var _bean:Bean;

		public function BeanEvent(type:String, beanIn:Object):void
		{
			super(type, true);

			_bean = !(beanIn is Bean) ? new Bean(beanIn) : beanIn as Bean;
		}
	}
}