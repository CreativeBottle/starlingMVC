package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.system.injection.InjectionTag;

	public class ViewAddedProcessor extends BaseMediatorProcessor
	{
		override public function process(object:Object, beans:Beans):void
		{
			this.cache = cache;

			announceToMediators(object, beans, InjectionTag.VIEW_ADDED);
		}
	}
}