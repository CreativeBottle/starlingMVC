package com.creativebottle.starlingmvc.utils
{
	import com.creativebottle.starlingmvc.beans.Bean;

	public class BeanUtils
	{
		public static function normalizeBean(bean:Object):Bean
		{
			return bean is Bean ? Bean(bean) : new Bean(bean);
		}
	}
}
