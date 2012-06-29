StarlingMVC Framework
===========

StarlingMVC is an MVC framework for use in games built using the great Starling framework. Closely modelled after established MVC frameworks like Swiz and RobotLegs, StarlingMVC features:
* Dependency Injection/Inversion of Control
* View Mediation
* Event Handling
* Stays out of the way of your Starling game code
* Simple configuration
* Easily extended
* More utilities to help with your game code

StarlingMVC Framework is provided under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0)

Requirements
------------
* flex framework ~> 4.6
* starling ~> 1.1
* flexunit ~> 4.1 (For running the unit tests)

Setup
------------
Getting your Starling project configured to work with StarlingMVC requires only a few lines of code. From your base Starling display class (starling.display.*), you need to create an instance of StarlingMVC and provide it the root Starling display object, an instance of StarlingMVCConfig, and some Beans.

```as3
package com.mygame.views
{
  	import com.creativebottle.starlingmvc.StarlingMVC;
	import com.creativebottle.starlingmvc.config.StarlingMVCConfig;
	import com.creativebottle.starlingmvc.views.ViewManager;
 	import com.mygame.models.GameModel;

	import starling.core.Starling;
	import starling.display.Sprite;

	public class GameMain extends Sprite
	{
		private var starlingMVC:StarlingMVC;

		public function GameMain()
		{
			var config:StarlingMVCConfig = new StarlingMVCConfig();
			config.eventPackages = ["com.mygame.events"];

			var beans:Array = [new GameModel(), new ViewManager(this), Starling.juggler];

			starlingMVC = new StarlingMVC(this, config, beans);
		}
	}
}
```

The StarlingMVCConfig instance above tells StarlingMVC which events it should mediate.
The beans Array is merely a collection of objects. The array can accept an object of any type. The framework will handle it accordingly.

Beans
------------
A Bean is an instance of an object that is provided to StarlingMVC to manage. Beans can be injected, receive injections, and handle events. There are several ways that beans can be provided to StarlingMVC during setup:
###Object instance
```as3
var beans:Array = [new GameModel(), new ViewManager(this), Starling.juggler];
```


###Bean instances
```as3
var beans:Array = [new Bean(new GameModel()), new Bean(new ViewManager(this)), new Bean(Starling.juggler)];
```
Providing a Bean instance as shown above does not give much benefit. However, there is an option second parameter to thw Bean constructor that allows for an id. If you provide an id then you can use the id during dependency injection. Additionally, beans are stored within the framework by class type unless you provide an id. So if you have two beans of the same type you will need to specify an id or subsequent beans will overwrite the previous beans. For example:
```as3
var beans:Array = [new Bean(new GameModel(),"gameModelEasy"),new Bean(new GameModel(),"gameModelHard"), new ViewManager(this), Starling.juggler];
```

###BeanProvider instances
A BeanProvider is a collection of Beans. The beans within the provider, like with a simple array, can be of any type, including BeanProvider.
```as3
package com.mygame.config
{
	import com.creativebottle.starlingmvc.beans.BeanProvider;
	import com.mygame.assets.AssetModel;
	import com.mygame.models.AudioModel;
	import com.mygame.models.GameModel;

	public class Models extends BeanProvider
	{
		public function Models()
		{
			beans = [new GameModel(), new Bean(new AudioModel(),"audioModel"), new AssetModel()];
		}
	}
}
```
Once you have your BeanProvider set up, you can pass that as a part of your original beans array.
```as3
var beans:Array = [new Models(), new ViewManager(this), Starling.juggler];
```

###Prototypes
A Prototype bean is a bean that is created at the time of injection. Where normal beans require a class instance, a Protoype requires a class and an id.
```as3
var beans:Array = [new Prototype(Character,"character"), new ViewManager(this)];
```
Using a Prototype here will allow StarlingMVC to create the instances of this class for you. Each time it is injected, it will be a new instance of the, in this case, "Character" class instead of using a singleton like a normal Bean. The advantage to allowing the framework to create the class over just using "new Character()" is that when StarlingMVC creates the instance it will run injection and all processing on the created instance.

Dependency Injection
------------
Dependency injection occurs on all beans and all Starling display objects. A dependency is denoted with an `Inject` metadata tag over a public property or getter/setter. Injection can be done by type:
```as3
package com.mygame.models
{
	public class GameController
	{
		[Inject]
		public var gameModel:GameModel;

		public function GameModel():void
		{

		}
	}
}
```
or by id, if an id was specified when the bean was created:
```as3
package com.mygame.models
{
	public class GameController
	{
		[Inject(source="gameModel")]
		public var gameModel:GameModel;

		public function GameModel():void
		{

		}
	}
}
```
In the above example, if the GameModel is a normal bean, the framework will set the value to the singleton instance that was created during setup. If it was a prototype, a new instance will be created and injected into the property.

Starling also supports injecting properties of beans. In order to use this functionality, the source Bean must contain an id (i.e. `new Bean(new GameModel(),"gameModel");`). To inject a property of a bean, simply append the property name to the end of the id parameter in your Inject tag:
```as3
package com.mygame.models
{
	public class GameController
	{
		[Inject(source="gameModel")]
		public var gameModel:GameModel;

		[Inject(source="userModel.currentUser")]
		public var currentUser:User;

		public function GameModel():void
		{

		}
	}
}
```
In the example above, the value of the `currentUser` property on the `userModel` bean would be injected into the currentUser property of our controller. This functionality is also recursive. If you wanted to inject the first name of the currentUser you could potentially use `[Inject(source="userModel.currentUser.firstName")]`.

Events
------------
###Dispatching Events
Events in StarlingMVC are dispatched in one of two ways:
1) StarlingMVC contains a global instance of `starling.events.EventDispatcher`. The quickest way to dispatch an event into the StarlingMVC framework is to use this dispatcher. This dispatcher can be injected into your bean by using the `[Dispatcher]` metadata tag.
2) DisplayObjects can dispatchEvents using their own `dispatchEvent()` method. This is only available to DisplayObjects and the events must set `bubbles=true'.

###Handling Events
Event handlers are denoted by using the `[EventHandler(event="")]` metadata tag on a public method of a bean. The event argument in the tag can contain one of two options: the event type string
```as3
package com.mygame.models
{
	public class GameController
	{

	}

	[EventHandler(event="scoreChanged"]
	public function scoreChanged(event:ScoreEvent):void
	{

	}
}
```
or the typed event
```as3
package com.mygame.models
{
	public class GameController
	{

	}

	[EventHandler(event="com.mygame.events.ScoreEvent.SCORE_CHANGED"]
	public function scoreChanged(event:ScoreEvent):void
	{

	}
}
```
By using the second approach, you will gain the benefit that StarlingMVC will type check any of the events during initialization and throw and error if the event or event type doesn't exist. This protects against typos.

In both examples above, the handler must accept the type of the dispatched event to handle. However, a second optional parameter exists in the EventHandler tag that will allow you to specify specific properties of the event to use as parameters to the event handler. For example:
```as3
package com.mygame.models
{
	public class GameController
	{

	}

	[EventHandler(event="com.mygame.events.ScoreEvent.SCORE_CHANGED", properties="user, newScore"]
	public function scoreChanged(user:User, newScore:int):void
	{

	}
}
```
In the above example, instead of passing the entire event into the handler, StarlingMVC will pass only the "user" and "newScore" properties. Note that the types must match or an error will be thrown.

