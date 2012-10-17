// open a single window
var win = Ti.UI.createWindow({ backgroundColor:'white' });
var label = Ti.UI.createLabel({ text:'Loaded, awaiting changes...' });
win.add(label);
win.open();


// Initialize the Regions Code
var regions = require('com.foodonthetable.regions');

regions.addEventListener("didInitialize", function () {
  Ti.API.info('initialized locationManager');
  Ti.API.info(JSON.stringify(regions.monitoredRegions()));
});

// Started Monitoring/Stopped Monitoring
regions.addEventListener("startedMonitoringRegion", function (region) {
  Ti.API.info('startedMonitoringRegion');
  Ti.API.info(JSON.stringify(regions.monitoredRegions()));
});
regions.addEventListener("stoppedMonitoringRegion", function (region) {
  Ti.API.info('stoppedMonitoringRegion');
  Ti.API.info(JSON.stringify(regions.monitoredRegions()));
});


// Events when we cross boundaries
regions.addEventListener("didFailWithError", function (event) {
  label.text = 'didFailWithError: ' + event.error;
  Ti.API.info('didFailWithError: ' + event.error);
});
regions.addEventListener("didEnterRegion", function (event) {
  label.text = 'didEnterRegion: ' + event.region.id + " (" + event.message + ")";
  Ti.API.info('didEnterRegion: ' + event.region.id + " (" + event.message + ")");
});
regions.addEventListener("didExitRegion", function (event) {
  label.text = 'didExitRegion: ' + event.region.id + " (" + event.message + ")";
  Ti.API.info('didExitRegion: ' + event.region.id + " (" + event.message + ")");
});
regions.addEventListener("monitoringDidFailForRegion", function (event) {
  label.text = 'monitoringDidFailForRegion: ' + event.region.id + " (" + event.error + ")";
  Ti.API.info('monitoringDidFailForRegion: ' + event.region.id + " (" + event.error + ")");
});


Ti.App.addEventListener('pause', function (event) {
  // Save Battery Life when we go to the background
  regions.monitorChangesSignificantOnly();
});
Ti.App.addEventListener('resume', function (event) {
  // Normal change events when app is in foreground
  regions.monitorChangesNormal();
});

var testRegion = {
  id:'test',
  radius:100.0,
  lat:30.2796,
  lng:-97.7595
};
regions.startMonitoring(testRegion);
