package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.beans.Prototype;
	import com.creativebottle.starlingmvc.utils.MetaClassCache;
	import com.creativebottle.system.injection.InjectionTag;
	import com.creativebottle.system.meta.MetaClass;
	import com.creativebottle.system.meta.MetaClassMember;
	import com.creativebottle.system.meta.MetaTagArg;

	import flash.utils.getDefinitionByName;

	public class InjectProcessor implements IProcessor
	{
		public var prototypeInstances:Array = new Array();

		public function processOn(object:Object, beans:Beans, cache:MetaClassCache):void
		{
			var bean:Bean = !(object is Bean) ? new Bean(object) : object as Bean;

			if (!bean.instance) return;

			var metaClass:MetaClass = cache.getMetaClassForInstance(bean.instance);

			var injections:Array = metaClass.membersByMetaTag(InjectionTag.INJECT);

			for each(var member:MetaClassMember in injections)
			{
				var TempClass:Class = getDefinitionByName(member.type) as Class;

				var arg:MetaTagArg = member.tagByName(InjectionTag.INJECT).argByName("source");

				var mapping:Bean;
				var instance:Object;

				if (arg)
				{
					mapping = beans.getBeanById(arg.value);

					if (!mapping)
					{
						throw new Error("No bean found with id: " + arg.value);
					}

					if (mapping is Prototype)
					{
						instance = new (mapping as Prototype).ClassType();

						prototypeInstances.push(instance);
					}
					else
					{
						instance = mapping.instance;
					}
				}
				else
				{
					mapping = beans.getBeanByClass(TempClass);

					instance = mapping.instance;
				}

				bean.instance[member.name] = instance;
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