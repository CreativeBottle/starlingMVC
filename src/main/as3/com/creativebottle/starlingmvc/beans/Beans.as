package com.creativebottle.starlingmvc.beans
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class Beans
	{
		public const beans:Dictionary = new Dictionary(true);

		public function Beans()
		{

		}

		public function addBean(beanIn:*):void
		{
			var bean:Bean = normalizeBean(beanIn);

			if (bean is Prototype)
			{
				createMap(Prototype(bean).ClassType, bean);
			}
			else
			{
				var className:String = getQualifiedClassName(bean.instance);
				var myClass:Class = getDefinitionByName(className) as Class;

				createMap(myClass, bean);
			}
		}

		public function removeBean(beanIn:Bean):void
		{
			for (var key:Object in beans)
			{
				var bean:Bean = beans[key];

				if (bean == beanIn)
				{
					beans[key] = null;
					key = null;
				}
			}
		}

		public function addBeans(beanProviders:Array):void
		{
			for each(var provider:Object in beanProviders)
			{
				if (provider is BeanProvider)
				{
					addBeanProvider(provider as BeanProvider);
				}
				else
				{
					addBean(provider);
				}
			}

		}

		public function addBeanProvider(beanProviders:BeanProvider):void
		{
			for each(var bean:Object in beanProviders.beans)
			{
				addBean(bean);
			}
		}

		public function createMap(MapClass:Class, bean:Bean):void
		{
			if (bean.id)
			{
				beans[bean.id] = bean;
			}
			else
			{
				beans[MapClass] = bean;
			}
		}

		public function getBeanByClass(BeanClass:Class):Bean
		{
			return beans[BeanClass];
		}

		public function getBeanById(id:String):Bean
		{
			return beans[id];
		}

		private function normalizeBean(bean:Object):Bean
		{
			if (bean is Bean)
			{
				return bean as Bean;
			}
			else
			{
				return new Bean(bean);
			}
		}
	}
}