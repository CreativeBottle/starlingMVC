package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.system.injection.InjectionTag;

	public class ViewRemovedProcessor extends BaseMediatorProcessor
	{
		public function process(object:Object, beans:Beans):void
		{
			announceToMediators(object, beans, InjectionTag.VIEW_REMOVED);
		}

	}
}