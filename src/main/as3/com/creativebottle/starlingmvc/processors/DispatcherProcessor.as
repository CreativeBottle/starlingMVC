package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.utils.MetaClassCache;
	import com.creativebottle.system.injection.InjectionTag;
	import com.creativebottle.system.meta.MetaClass;
	import com.creativebottle.system.meta.MetaClassMember;

	import starling.events.EventDispatcher;

	public class DispatcherProcessor implements IProcessor
	{
		public var dispatcher:EventDispatcher;

		public function processOn(object:Object, beans:Beans, cache:MetaClassCache):void
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

		public function process(beans:Beans, cache:MetaClassCache):void
		{
			for each(var bean:Bean in beans.beans)
			{
				processOn(bean, beans, cache);
			}
		}
	}
}