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

	public class PopEmMain extends Sprite
	{
		private var starlingMVC:StarlingMVC;

		public function PopEmMain()
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
A BeanProvider is a collection of Beans. The beans within the provider, like with a simple array, can be of any type. 