package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.StarlingMVC;
	import com.creativebottle.starlingmvc.beans.Bean;
	import com.creativebottle.starlingmvc.beans.Beans;
	import com.creativebottle.starlingmvc.constants.Tags;
	import com.creativebottle.starlingmvc.reflection.ClassDescriptor;
	import com.creativebottle.starlingmvc.reflection.ClassMember;
	import com.creativebottle.starlingmvc.utils.BeanUtils;
	import com.creativebottle.starlingmvc.utils.ClassDescriptorCache;

	import starling.core.Starling;

	public class JugglerProcessor implements IProcessor
	{

		public function config(starlingMVC:StarlingMVC):void
		{
		}

		public function process(object:Object, beans:Beans):void
		{
			var targetBean:Bean = BeanUtils.normalizeBean(object);
			var target:Object = targetBean.instance;
			if (!target) return;

			var classDescriptor:ClassDescriptor = ClassDescriptorCache.getClassDescriptorForInstance(target);

			var jugglers:Array = classDescriptor.membersByMetaTag(Tags.JUGGLER);

			for each(var taggedJuggler:ClassMember in jugglers)
			{
				target[ taggedJuggler.name ] = Starling.juggler;
			}
		}
	}
}