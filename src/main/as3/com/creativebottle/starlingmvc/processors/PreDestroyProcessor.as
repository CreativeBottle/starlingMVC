package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.StarlingMVC;
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.utils.MetaClassCache;
	import com.creativebottle.system.injection.InjectionTag;
	import com.creativebottle.system.meta.MetaClass;
	import com.creativebottle.system.meta.MetaClassMember;
	import com.creativebottle.system.meta.MetaMethod;

	public class PreDestroyProcessor implements IProcessor
	{
		public function config(starlingMVC:StarlingMVC):void
		{

		}

		public function process(object:Object, beans:Beans):void
		{
			var bean:Bean = !(object is Bean) ? new Bean(object) : object as Bean;

			if (!bean.instance) return;

			var metaClass:MetaClass = MetaClassCache.getMetaClassForInstance(bean.instance);

			// Handle pre destroys
			var preDestroys:Array = metaClass.membersByMetaTag(InjectionTag.PRE_DESTROY);

			for each(var method:MetaClassMember in preDestroys)
			{
				if (method is MetaMethod)
				{
					bean.instance[ method.name ]();
				}
			}
		}
	}
}