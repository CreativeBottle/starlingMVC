package com.creativebottle.starlingmvc.processors
{
	import com.creativebottle.starlingmvc.StarlingMVC;
	import com.creativebottle.starlingmvc.beans.Beans;

	public interface IProcessor
	{
		function config(starlingMVC:StarlingMVC):void;

		function process(object:Object, beans:Beans):void;
	}
}