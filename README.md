Regions
=======

This is a thin wrapper around the CLCoreLocation region monitoring in iOS.


TESTING
-------

Check out  `example/app.js` for a complete example of how to integrate this
into your project.


INSTALL
-------

Unzip the zip file included to your modules directory.

Register your module with your application by editing `tiapp.xml` and adding your module.
Example:

    <modules>
      <module version="0.1">com.foodonthetable.regions</module>
    </modules>

When you run your project, the compiler will know automatically compile in your module
dependencies and copy appropriate image assets into the application.


USING REGIONS IN CODE
---------------------

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
