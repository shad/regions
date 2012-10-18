// open a single window
var win = Ti.UI.createWindow({ backgroundColor:'white' });
var label = Ti.UI.createLabel({ text:'Loaded, awaiting changes...' });
win.add(label);
win.open();


// == Initialize the Regions Code ==
var regions = require('com.foodonthetable.regions');
regions.addEventListener("didInitialize", function () {
  Ti.API.info('initialized locationManager');
  Ti.API.info(JSON.stringify(regions.monitoredRegions()));
});

// == Boundary Events ==
// Once you set boundaries, these will be triggered when users cross those
// boundaries, even if the app is in the background.  If the app is not
// running, it will be started to fire these events... seriously.
regions.addEventListener("didEnterRegion", function (event) {
  Ti.API.info('didEnterRegion: ' + event.region.id + " " + event.message);
  label.text = 'didEnterRegion: ' + event.region.id + " " + event.message;
  Ti.App.iOS.cancelAllLocalNotifications();
  Ti.App.iOS.scheduleLocalNotification({
    alertBody:'didEnterRegion',
    date:new Date()
  });
});
regions.addEventListener("didExitRegion", function (event) {
  Ti.API.info('didExitRegion: ' + event.region.id + " " + event.message);
  label.text = 'didExitRegion: ' + event.region.id + " " + event.message;
});


// == Start/Stop Monitoring Region ==
regions.addEventListener("startedMonitoringRegion", function (region) {
  Ti.API.info('startedMonitoringRegion:' + region.id + ' all regions:' + JSON.stringify(regions.monitoredRegions()));
});
regions.addEventListener("stoppedMonitoringRegion", function (region) {
  Ti.API.info('stoppedMonitoringRegion:' + region.id + ' all regions:' + JSON.stringify(regions.monitoredRegions()));
});



// == Errors ==
regions.addEventListener("didFailWithError", function (event) {
  label.text = 'didFailWithError: ' + event.error;
});
regions.addEventListener("monitoringDidFailForRegion", function (event) {
  Ti.API.info('monitoringDidFailForRegion: ' + event.region.id + " " + event.error);
  label.text = 'monitoringDidFailForRegion: ' + event.region.id + " " + event.error;
});

// == Setup a single test region ==
var testRegion = {
  id:'test',
  radius:100.0,
  lat:30.2796,
  lng:-97.7595
};
regions.startMonitoring(testRegion);


// == Remove regions and stop monitoring ==
var button = Ti.UI.createButton({title:"Stop Listening", bottom:10});
win.add(button);
button.addEventListener('click', function () {
  regions.stopMonitoringAllRegions();
});
