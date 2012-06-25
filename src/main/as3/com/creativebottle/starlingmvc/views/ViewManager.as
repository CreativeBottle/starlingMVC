package com.creativebottle.starlingmvc.views
{
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class ViewManager
	{
		private var srcClip:Sprite;
		private var view:DisplayObject;
		private var stack:Array;

		public function ViewManager(srcClip:Sprite)
		{
			this.srcClip = srcClip;

			stack = new Array();
		}

		public function addView(view:DisplayObject):DisplayObject
		{
			if (stack.indexOf(view) == -1)
			{
				stack.push(view);

				srcClip.addChild(view as DisplayObject);
			}

			return view;
		}

		public function removeView(view:DisplayObject):void
		{
			var idx:int = stack.indexOf(view);

			if (idx != -1)
			{
				srcClip.removeChild(view as DisplayObject);

				stack.splice(idx, 1);
			}
		}

		public function popView():void
		{
			removeView(stack[stack.length - 1]);
		}

		public function removeAll():void
		{
			for each(var s:DisplayObject in stack)
			{
				removeView(s);
			}
		}

		public function setView(ViewClass:Class, params:Object = null):DisplayObject
		{
			removeExistingView();

			view = new ViewClass() as DisplayObject;

			if (!view)
				throw new Error("Provided view is not of type DisplayObject.");

			removeAll();

			if (view)
			{
				srcClip.addChild(view as DisplayObject);
			}

			return view;
		}

		private function removeExistingView():void
		{
			if (view)
			{
				srcClip.removeChild(view as DisplayObject);
			}
		}
	}

}