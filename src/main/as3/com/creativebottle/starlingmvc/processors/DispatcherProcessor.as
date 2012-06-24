package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.system.injection.InjectionTag;
	import com.creativebottle.system.meta.MetaClass;
	import com.creativebottle.system.meta.MetaClassMember;

	import starling.events.EventDispatcher;

	public class DispatcherProcessor extends BaseProcessor
	{
		private var dispatcher:EventDispatcher;

		public function DispatcherProcessor(dispatcher:EventDispatcher):void
		{
			this.dispatcher = dispatcher;
		}

		override public function process(object:Object, beans:Beans):void
		{
			var bean:Bean = !(object is Bean) ? new Bean(object) : object as Bean;

			if (!bean.instance) return;

			var metaClass:MetaClass = cache.getMetaClassForInstance(bean.instance);

			var injections:Array = metaClass.membersByMetaTag(InjectionTag.DISPATCHER);

			for each(var member:MetaClassMember in injections)
			{
				bean.instance[ member.name ] = dispatcher;
			}
		}
	}
}