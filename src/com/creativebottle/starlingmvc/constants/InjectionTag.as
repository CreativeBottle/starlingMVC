package com.creativebottle.starlingmvc.constants
{
	/**
	 * Enum for injection tags
	 */
	public class InjectionTag
	{
		static public const INJECT:String = "Inject";
		static public const DISPATCHER:String = "Dispatcher";
		static public const EVENT_HANDLER:String = "EventHandler";
		static public const POST_CONSTRUCT:String = "PostConstruct";
		static public const PRE_DESTROY:String = "PreDestroy";
		static public const VIEW_ADDED:String = "ViewAdded";
		static public const VIEW_REMOVED:String = "ViewRemoved";
	}
}