package com.creativebottle.starlingmvc.utils
{
	import starling.events.EventDispatcher;

	public class EventMap
	{
		private var map:Array = new Array();

		public function EventMap()
		{

		}

		public function addMap(target:EventDispatcher, event:String, handler:Function):void
		{
			if (getMapIndex(target, event, handler) == -1)
			{
				target.addEventListener(event, handler);

				map.push({ target:target, event:event, handler:handler });
			}

		}

		public function removeMap(target:EventDispatcher, event:String, handler:Function):void
		{
			var index:int = getMapIndex(target, event, handler);

			if (index > -1)
			{
				target.removeEventListener(event, handler);

				map.splice(index, 1);
			}
		}

		public function removeAllMappedEvents():void
		{
			while (map.length > 0)
			{
				var obj:Object = map.pop();

				obj.target.removeEventListener(obj.event, obj.handler);
			}
		}

		private function getMapIndex(target:EventDispatcher, event:String, handler:Function):int
		{
			for (var i:int = 0; i < map.length; i++)
			{
				var obj:Object = map[i];

				if (obj.target == target && obj.event == event && obj.handler == handler)
				{
					return i;
				}
			}

			return -1;
		}
	}
}