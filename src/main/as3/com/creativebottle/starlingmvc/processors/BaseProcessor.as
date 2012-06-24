package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.utils.MetaClassCache;

	public class BaseProcessor implements IProcessor
	{
		public function set cache(value:MetaClassCache):void
		{
			_cache = value;
		}

		public function get cache():MetaClassCache
		{
			return _cache;
		}

		private var _cache:MetaClassCache;

		public function process(object:Object, beans:Beans):void
		{
			throw new Error("Subclasses must override the process method.");
		}
	}
}