package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.system.injection.InjectionTag;
	import com.creativebottle.system.meta.MetaClass;
	import com.creativebottle.system.meta.MetaClassMember;
	import com.creativebottle.system.meta.MetaMethod;

	public class PostConstructProcessor extends BaseProcessor
	{
		override public function process(object:Object, beans:Beans):void
		{
			var bean:Bean = !(object is Bean) ? new Bean(object) : object as Bean;

			if (!bean.instance) return;

			var metaClass:MetaClass = cache.getMetaClassForInstance(bean.instance);

			// Handle post constructs
			var postConstructs:Array = metaClass.membersByMetaTag(InjectionTag.POST_CONSTRUCT);

			for each(var method:MetaClassMember in postConstructs)
			{
				if (method is MetaMethod)
				{
					bean.instance[ method.name ]();
				}
			}
		}
	}
}