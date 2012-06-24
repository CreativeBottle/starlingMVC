package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.system.meta.MetaClass;
	import com.creativebottle.system.meta.MetaMethod;

	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class BaseMediatorProcessor extends BaseProcessor
	{
		protected function announceToMediators(view:Object, beans:Beans, tag:String):void
		{
			var className:String = getQualifiedClassName(view);
			var ViewClass:Class = getDefinitionByName(className) as Class;

			for each(var bean:Bean in beans.beans)
			{
				if (!bean.instance) return;

				var metaClass:MetaClass = cache.getMetaClassForInstance(bean.instance);

				var viewAddedMethods:Array = metaClass.membersByMetaTag(tag);

				for each(var metaMethod:MetaMethod in viewAddedMethods)
				{
					if (metaMethod.parameters.length == 1 && metaMethod.parameters[0].type == ViewClass)
					{
						bean.instance[metaMethod.name](view);
					}
				}
			}
		}
	}
}