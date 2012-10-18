'Regions' Intro
===============

This is a thin wrapper around the CLCoreLocation region monitoring in iOS.
When you start monitoring a region, iOS will continue monitoring that region
even when you app is _not running_.  If it detects someone moving into a region
that you have defined, then your app will be started and the appropriate events
will be triggered.

These are the same API's that drive the 'reminders' app (i.e. "Remind me to pay
my bills when I get home")

Regions are circular, and are defined as a latitude, longitude and radius size.
Additionally, you provide an id that's unique for your app.  These attributes
will also be passed to each relevant event listener.

### What this is NOT

This will not help you if you want to do location monitoring or significant
change monitoring.  I could add that if someone needs it, but I don't right
now, so this module is region monitoring only.


### Contributing

If you have improvements I'm happy to merge pull requests (if they include some
sort of test plan).


Testing
-------
There aren't any real automated tests here since you sort of need to simulate
moving around to get events firing.  You can do this in the iPhone Simulator
'Debug' menu item.

Check out  `example/app.js` for a complete example of how to integrate this
into your project.


Install
-------

Unzip the zip file included to your modules directory.  You can also build the
app yourself if you want (but I've included the latest .zip in case you need
it).

Register your module with your application by editing `tiapp.xml` and adding
your module.

Example:

    <modules>
      <module version="0.1">com.foodonthetable.regions</module>
    </modules>

When you run your project, the compiler will know automatically compile in your module
dependencies and copy appropriate image assets into the application.


Using Regions in Code
---------------------

I've tried to make this as simple as possible.

    var regions = require('com.foodonthetable.regions');

    regions.addEventListener("didEnterRegion", function (event) {
      Ti.API.info('didEnterRegion: ' + event.region.id + " (" + event.message + ")");
    });

    regions.startMonitoring({
      id:'test',
      radius:100.0,
      lat:30.2796,
      lng:-97.7595
    });

Check out `example/app.js` for a complete example of all available events.
