package com.creativebottle.starlingmvc.utils
{
	import com.creativebottle.starlingmvc.beans.Bean;

	public class BeanUtils
	{
		public static function normalizeBean(bean:Object):Bean
		{
			if (bean is Bean)
			{
				return Bean(bean);
			}
			else
			{
				return new Bean(bean);
			}
		}
	}
}