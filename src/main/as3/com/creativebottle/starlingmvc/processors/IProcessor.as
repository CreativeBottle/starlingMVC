package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.utils.MetaClassCache;

	public interface IProcessor
	{
		function set cache(value:MetaClassCache):void;

		function process(object:Object, beans:Beans):void;
	}
}