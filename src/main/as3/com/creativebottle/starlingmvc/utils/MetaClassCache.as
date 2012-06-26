package com.creativebottle.starlingmvc.utils
{
	import com.creativebottle.system.meta.MetaClass;

	import flash.utils.Dictionary;

	public class MetaClassCache
	{
		private static const metaClassCache:Dictionary = new Dictionary();

		public function MetaClassCache()
		{

		}

		public static function getMetaClassForInstance(object:Object):MetaClass
		{
			var metaClass:MetaClass;

			if (metaClassCache[object.constructor])
			{
				metaClass = metaClassCache[object.constructor];
			}
			else
			{
				metaClass = new MetaClass(object);

				metaClassCache[object.constructor] = metaClass;
			}
			return metaClass;
		}
	}
}