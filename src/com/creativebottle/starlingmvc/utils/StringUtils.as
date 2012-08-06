package com.creativebottle.starlingmvc.utils
{
	public class StringUtils
	{
		private static const WHITESPACE:RegExp = /[\s\r\n]*/gim;

		public static function removeWhitespace(valueIn:String):String
		{
			return valueIn.replace(WHITESPACE, '');
		}
	}
}