StarlingMVC Framework
===========

StarlingMVC is an IOC framework for use in games built using the great [Starling framework](http://gamua.com/starling/). Closely modelled after established IOC frameworks like [Swiz](http://swizframework.org/) and [RobotLegs](http://www.robotlegs.org/), StarlingMVC features:
* Dependency Injection(DI)/Inversion of Control(IOC)
* View Mediation
* Event Handling
* Stays out of the way of your Starling game code
* Simple configuration
* Easily extended
* More utilities to help with your game code

StarlingMVC Framework is provided under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).

Requirements
------------
* [Flex SDK 4.6](http://www.adobe.com/devnet/flex/flex-sdk-download.html)
* [Starling 1.1](http://gamua.com/starling/)
* [FlexUnit 4.1 (For running the unit tests)](http://www.flexunit.org/)

Contributors
------------
* [Creative Bottle, Inc](http://www.creativebottle.com)
* [Scott Jeppesen](mailto:scott.jeppesen@creativebottle.com)
* [Tom McAvoy](mailto:tom.mcavoy@creativebottle.com)

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
			config.viewPackages = ["com.mygame.views"];

			var beans:Array = [new GameModel(), new ViewManager(this)];

			starlingMVC = new StarlingMVC(this, config, beans);
		}
	}
}
```

The StarlingMVCConfig instance above tells StarlingMVC which event packages and view packages it should mediate.
The beans Array is merely a collection of objects. The array can accept an object of any type. The framework will handle it accordingly.

Beans
------------
A Bean is an instance of an object that is provided to StarlingMVC to manage. Beans can be injected, receive injections, and handle events. There are several ways that beans can be provided to StarlingMVC during setup:
###Object instance
```as3
var beans:Array = [new GameModel(), new ViewManager(this)];
```


###Bean instances
```as3
var beans:Array = [new Bean(new GameModel()), new Bean(new ViewManager(this))];
```
Providing a Bean instance as shown above does not give much benefit. However, there is an option second parameter to thw Bean constructor that allows for an id. If you provide an id then you can use the id during dependency injection. Additionally, beans are stored within the framework by class type unless you provide an id. So if you have two beans of the same type you will need to specify an id or subsequent beans will overwrite the previous beans. For example:
```as3
var beans:Array = [new Bean(new GameModel(),"gameModelEasy"),new Bean(new GameModel(),"gameModelHard"), new ViewManager(this)];
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
var beans:Array = [new Models(), new ViewManager(this)];
```

###ProtoBeans
A ProtoBean is a bean that is created at the time of injection. Where normal beans require a class instance, a ProtoBean requires a class and an id.
```as3
var beans:Array = [new ProtoBean(Character,"character"), new ViewManager(this)];
```
Using a ProtoBean here will allow StarlingMVC to create the instances of this class for you. Each time it is injected, it will be a new instance of the, in this case, "Character" class instead of using a singleton like a normal Bean. The advantage to allowing the framework to create the class over just using "new Character()" is that when StarlingMVC creates the instance it will run injection and all processing on the created instance.

Dependency Injection
------------
Dependency injection occurs on all beans and all Starling display objects. A dependency is denoted with an `Inject` metadata tag over a public property or getter/setter. Injection can be done by type:
```as3
package com.mygame.controllers
{
	public class GameController
	{
		[Inject]
		public var gameModel:GameModel;

		public function GameController():void
		{

		}
	}
}
```
or by id, if an id was specified when the bean was created:
```as3
package com.mygame.controllers
{
	public class GameController
	{
		[Inject(source="gameModel")]
		public var gameModel:GameModel;

		public function GameController():void
		{

		}
	}
}
```
In the above example, if the GameModel is a normal bean, the framework will set the value to the singleton instance that was created during setup. If it was a protobean, a new instance will be created and injected into the property.

Starling also supports injecting properties of beans. In order to use this functionality, the source Bean must contain an id (i.e. `new Bean(new GameModel(),"gameModel");`). To inject a property of a bean, simply append the property name to the end of the id parameter in your Inject tag:
```as3
package com.mygame.controllers
{
	public class GameController
	{
		[Inject(source="gameModel")]
		public var gameModel:GameModel;

		[Inject(source="userModel.currentUser")]
		public var currentUser:User;

		public function GameController():void
		{

		}
	}
}
```
In the example above, the value of the `currentUser` property on the `userModel` bean would be injected into the currentUser property of our controller. This functionality is also recursive. If you wanted to inject the first name of the currentUser you could potentially use `[Inject(source="userModel.currentUser.firstName")]`.

###Binding
The InjectProcessor also supports a very simple binding mechanism that will cause injected properties to be automatically refreshed when they are changed.
```as3
package com.mygame.controllers
{
	public class GameController
	{
		[Inject(source="gameModel")]
		public var gameModel:GameModel;

		[Inject(source="userModel.currentUser", bind="true")]
		public var currentUser:User;

		public function GameController():void
		{

		}
	}
}
```
The example above uses the optional `bind="true"` parameter of the `[Inject]` tag to create a binding.  When the currentUser property of the userModel is updated StarlingMVC will automatically update any injections using binding. This will also work with getter/setters methods. Using these will allow code to easily react to changes in the properties.
```as3
package com.mygame.controllers
{
	public class GameController
	{
		[Inject(source="gameModel")]
		public var gameModel:GameModel;

		[Inject(source="userModel.currentUser", bind="true")]
		public function set currentUser(value:User):void
		{
			_currentUser = value;

			// Do something to update your UI with the new value
		}

		public function get currentUser():User
		{
			return _currentUser;
		}
		private var _currentUser:User;

		public function GameController():void
		{

		}
	}
}
```
Binding is connected directly to the Starling juggler instance and will check for changes on each bound property everytime the `advanceTime()` method is called. This does not provide a binding that works as instantaneously as Flex binding. Binding should be used sparingly as there is still overhead to check for changes to the bound properties.

As an alternative to auto bound properties, StarlingMVC supports binding through invalidation. This method is much more efficient than the auto bound properties because it give you much more control over when properties are updated. This is done through an injected `Bindings` class and the optional "auto" parameter.
```as3
package com.mygame.controllers
{
	public class GameController
	{
		[Inject(source="gameModel")]
		public var gameModel:GameModel;

		[Inject(source="userModel.currentUser", bind="true", auto="false")]
		public function set currentUser(value:User):void
		{
			_currentUser = value;

			// Do something to update your UI with the new value
		}

		public function get currentUser():User
		{
			return _currentUser;
		}
		private var _currentUser:User;

		public function GameController():void
		{

		}
	}
}

package com.mygame.models
{
	public class UserModel
	{
		[Bindings]
		public var bindings:Bindings;

		public function set currentUser(value:User):void
		{
			if(value != _currentUser)
			{
				_currentUser = value;

				bindings.invalidate(this, "currentUser");
			}
		}

		public function get currentUser():User
		{
			return _currentUser;
		}
		private var _currentUser:User;
	}
}
```

Events
------------
###Dispatching Events
Events in StarlingMVC are dispatched in one of two ways:
1) StarlingMVC contains a global instance of `starling.events.EventDispatcher`. The quickest way to dispatch an event into the StarlingMVC framework is to use this dispatcher. This dispatcher can be injected into your bean by using the `[Dispatcher]` metadata tag.
2) DisplayObjects can dispatchEvents using their own `dispatchEvent()` method. This is only available to DisplayObjects and the events must set `bubbles=true'.

###Handling Events
Event handlers are denoted by using the `[EventHandler(event="")]` metadata tag on a public method of a bean. The event argument in the tag can contain one of two options: the event type string
```as3
package com.mygame.controllers
{
	public class GameController
	{
		[EventHandler(event="scoreChanged")]
		public function scoreChanged(event:ScoreEvent):void
		{

		}
	}
}
```
or the typed event
```as3
package com.mygame.controllers
{
	public class GameController
	{
		[EventHandler(event="com.mygame.events.ScoreEvent.SCORE_CHANGED")]
		public function scoreChanged(event:ScoreEvent):void
		{

		}
	}
}
```
By using the second approach, you will gain the benefit that StarlingMVC will type check any of the events during initialization and throw and error if the event or event type doesn't exist. This protects against typos.

In both examples above, the handler must accept the type of the dispatched event to handle. However, a second optional parameter exists in the EventHandler tag that will allow you to specify specific properties of the event to use as parameters to the event handler. For example:
```as3
package com.mygame.controllers
{
	public class GameController
	{
		[EventHandler(event="com.mygame.events.ScoreEvent.SCORE_CHANGED", properties="user, newScore")]
		public function scoreChanged(user:User, newScore:int):void
		{

		}
	}
}
```
In the above example, instead of passing the entire event into the handler, StarlingMVC will pass only the "user" and "newScore" properties. Note that the types must match or an error will be thrown.

View Mediation
------------
View mediators are a great way of keeping your view classes separate from the code that controls them. A view mediator is set up just like any other bean. To link a view to a view mediator a `[ViewAdded]` metadata tag is used on a public method. When a DisplayObject is added to the stack, StarlingMVC will look for instances of the ViewAdded tag. If the parameter of any ViewAdded methods are of the type of the view that was just added, the new DisplayObject will be passed to that method. To unlink a mediator from a view when the view has been removed the `[ViewRemoved]` metadata tag is used.
```as3
package com.mygame.mediators
{
	public class GameMediator
	{
		private var view:Game;

		[ViewAdded]
		public function viewAdded(view:Game):void
		{
			this.view = view;
		}

		[ViewRemoved]
		public function viewRemoved(view:Game):void
		{
			this.view = null;
		}
	}
}
```
Bean Lifecycle
------------
Normal beans are set up on initialization. However, since the dependency injection and event handling happens after creation bean values are not available immediately. To receive notification of when a bean has been fully processed we can add the `[PostConstruct]` tag to a public method. This method will be automatically called when all DI has been completed. Similarly, when a bean is being destroyed we can specify a public method to be called with the `[PreDestroy]` tag. This works in all standard beans and DisplayObjects.
```as3
package com.mygame.controllers
{
	public class GameController
	{
		[Inject]
		public var gameModel:GameModel;

		[PostConstruct]
		public function postConstruct():void
		{
			// set up code here
		}

		[PreDestroy]
		public function preDestroy():void
		{
			// tear down code here
		}

		[EventHandler(event="com.mygame.events.ScoreEvent.SCORE_CHANGED", properties="user, newScore")]
		public function scoreChanged(user:User, newScore:int):void
		{

		}
	}
}

package com.mygame.controllers
{
	public class GameModel
	{
		[Bindings]
		public var bindings:Bindings;

		public function set score(value:int):void
		{
			if(value != _score)
			{
				_score = value;

				bindings.invalidate(this, "score");
			}
		}

		public function get score():int
		{
			return _score;
		}
		private var _score:int;
	}
}
```
In the above example you can see that in the controller the Inject tag includes "auto='false'". This disables the auto binding so that a check is not done on every iteration of the Juggler. In the GameMode, we are injecting the Bindings instance and then invalidating manually when the property changes. Once the property is invalidated, it will be automatically updated on the next pass of the juggler.

Manual Bean Creation/Removal
------------
Manual bean creation and removal is done through the event system. Dispatching `BeanEvent.ADD_BEAN` will add and process a new bean. Dispatching `BeanEvent.REMOVE_BEAN` will remove the bean from the system.
```as3
package com.mygame.view
{
	public class Game
	{
		public var gamePresentationModel:GamePresentationModel;

		[PostConstruct]
		public function postConstruct():void
		{
			gamePresentationModel = new GamePresentationModel();

			dispatchEvent(new BeanEvent(BeanEvent.ADD_BEAN, gamePresentationModel));
		}

		[PreDestroy]
		public function preDestroy():void
		{
			dispatchEvent(new BeanEvent(BeanEvent.REMOVE_BEAN, gamePresentationModel));

			gamePresentationModel = null;
		}
	}
}
```
In the example above, we create a presentation model for our view and add it to StarlingMVC as a bean. In doing this, the PM will be processed as a bean and gain all of the benefits of DI and EventHandling.

Command Pattern
------------
StarlingMVC includes support for the command pattern. Commands are essentially beans that are created when a specified event is dispatched, executed, and then disposed of. To add a command to the framework, an instance of the Command class should be added to the beans.
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
			config.viewPackages = ["com.mygame.views"];

			var beans:Array = [new GameModel(), new ViewManager(this), new Command(DoSomethingEvent.DO_SOMETHING, DoSomethingCommand)];

			starlingMVC = new StarlingMVC(this, config, beans);
		}
	}
}
```
This will map the event to the command. The command class can receive all of the same injections as any other bean. It cannot handle events, however, since the instance will only exist long enough to execute a single command. The method to execute in the command instance is noted with the `[Execute]` metadata.
```as3
package com.mygame.commands
{
	import com.mygame.events.NavigationEvent;
	import com.mygame.models.BubbleModel;

	import starling.events.EventDispatcher;

	public class DoSomethingCommand
	{
		[Dispatcher]
		public var dispatcher:EventDispatcher;

		[Inject]
		public var bubbleModel:BubbleModel;

		[Execute]
		public function execute(event:DoSomethingEvent):void
		{
			trace("did something!");
		}
	}
}
```
In this example, whenever the `DoSomethingEvent.DO_SOMETHING` is dispatched, StarlingMVC will create an instance of DoSomethingCommand, run the execute method, and then dispose of the instance. The Command class also contains an optional parameter called runOnce.
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
			config.viewPackages = ["com.mygame.views"];

			var beans:Array = [new GameModel(), new ViewManager(this), new Command(DoSomethingEvent.DO_SOMETHING, DoSomethingCommand, true)];

			starlingMVC = new StarlingMVC(this, config, beans);
		}
	}
}
```
In this example, the command bean is added with the following line: `new Command(DoSomethingEvent.DO_SOMETHING, DoSomethingCommand, true)`. The optional last parameter, `true`, specifies that this command should be run once. So in this case, when the DO_SOMETHING event is dispatched, the framework would create an instance of DoSomethingCommand, run execute, dispose of the instance, and then remove the mapping. This functionality is very useful for initialization commands.

EventMap
------------
EventMap is a utility class for creating and managing event listeners. Using EventMap exclusively to create listeners within your class makes cleanup very easy.
```as3
package com.mygame.mediators
{
	import com.creativebottle.starlingmvc.events.EventMap;

	public class GameMediator
	{
		private var eventMap:EventMap = new EventMap();

		[ViewAdded]
		public function viewAdded(view:Game):void
		{
			eventMap.addMap(view.playButton,TouchEvent.TOUCH, playButtonTouched);
			eventMap.addMap(view.instructionsButton,TouchEvent.TOUCH, instructionsTouched);
		}

		[ViewRemoved]
		public function viewRemoved(view:Game):void
		{
			event.removeAllMappedEvents();
		}

		private function playButtonTouched(event:TouchEvent):void
		{

		}

		private function instructionsButtonTouched(event:TouchEvent):void
		{

		}
	}
}
```
Juggler
------------
The Juggler class in Starling is used to handle all animation within a game. For a class to take advantage of the Juggler instance, it must implement the IAnimatable interface but defining `advanceTime(time:Number)`. The global juggler reference can be accessed as a static property of Starling as `Starling.juggler1`. However, this property can also be directly injected into your class instances using the `[Juggler]` tag.
 ```as3
 package com.mygame.mediators
 {
 	import com.creativebottle.starlingmvc.events.EventMap;

 	public class GameMediator implements IAnimatable
 	{
 		[Juggler]
        public var juggler:Juggler;

 		[ViewAdded]
 		public function viewAdded(view:Game):void
 		{
 			juggler.add(this);
 		}

 		[ViewRemoved]
 		public function viewRemoved(view:Game):void
 		{
 		    juggler.remove(this);
 		}

 		public function advanceTime(time:Number):void
 		{
            // do some animation logic
 		}
 	}
 }
 ```

ViewManager
------------
ViewManager is a utility class to facilitate creating views and adding/removing them from the stage. When creating the instance of ViewManager the constructor requires a reference to the root view of the game (i.e. `new ViewManager(this)`) from the root DisplayObject. Adding the ViewManager instance to the StarlingMVC beans makes it easy to swap views from anywhere in the Starling application.
###setView
Calls to setView will remove existing views and add the new view. ViewManager handles instantiating the view and adding it to the stack.
```as3
package com.mygame.controllers
{
	public class NavigationController
	{
		[Inject]
		public var viewManager:ViewManager;

		[EventHandler(event="com.mygame.events.NavigationEvent.NAVIGATE_TO_VIEW", properties="viewClass")]
		public function navigateToView(viewClass:Class):void
		{
			viewManager.setView(viewClass);
		}
	}
}
```
###addView
Calls to addView will add a new view on top of the existing view. This is handy for popups, HUDs, etc. Whereas setView accepts a parameter of type Class, addView accepts a view instance.
```as3
package com.mygame.views
{
	public class Game
	{
		[Inject]
		public var viewManager:ViewManager;

		private var hud:GameHUD;

		[PostConstruct]
		public function postConstruct():void
		{
			hud = new GameHUD();

			viewManager.addView(hud);
		}
	}
}
```
###removeView
Calls to removeView will remove the specified view from the stack.
###removeAll
Calls to removeAll will remove all views from the stack. This is called automatically when calling `setView()`.
