package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.utils.MetaClassCache;
	import com.creativebottle.system.injection.InjectionTag;

	public class ViewAddedProcessor extends BaseMediatorProcessor implements IProcessor
	{
		public var view:Object;

		public function process(beans:Beans, cache:MetaClassCache):void
		{
			this.cache = cache;

			announceToMediators(view, beans, InjectionTag.VIEW_ADDED);
		}

	}
}