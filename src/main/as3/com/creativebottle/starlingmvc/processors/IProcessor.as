package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.utils.MetaClassCache;

	public interface IProcessor
	{
		function process(beans:Beans, cache:MetaClassCache):void;
	}
}