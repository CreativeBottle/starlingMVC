package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.StarlingMVC;
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.beans.Prototype;
	import com.creativebottle.starlingmvc.events.BeanEvent;
	import com.creativebottle.starlingmvc.utils.MetaClassCache;
	import com.creativebottle.system.injection.InjectionTag;
	import com.creativebottle.system.meta.MetaClass;
	import com.creativebottle.system.meta.MetaClassMember;
	import com.creativebottle.system.meta.MetaTagArg;

	import flash.utils.getDefinitionByName;

	import starling.events.EventDispatcher;

	public class InjectProcessor implements IProcessor
	{
		private var dispatcher:EventDispatcher;

		public function InjectProcessor()
		{

		}

		public function config(starlingMVC:StarlingMVC):void
		{
			this.dispatcher = starlingMVC.dispatcher;
		}

		public function process(object:Object, beans:Beans):void
		{
			var bean:Bean = !(object is Bean) ? new Bean(object) : object as Bean;

			if (!bean.instance) return;

			var metaClass:MetaClass = MetaClassCache.getMetaClassForInstance(bean.instance);

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
						instance = new (mapping as Prototype).classType();

						dispatcher.dispatchEvent(new BeanEvent(BeanEvent.ADD_BEAN, instance));
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
	}
}