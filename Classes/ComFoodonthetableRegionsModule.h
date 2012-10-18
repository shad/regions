/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"

#import <CoreLocation/CoreLocation.h>

@interface ComFoodonthetableRegionsModule : TiModule<CLLocationManagerDelegate>
{
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *lastEvent;
@property (nonatomic, retain) NSDictionary *options;

//- (void) startMonitoring:(id)region;
//- (void) stopMonitoring:(id)region;
//- (void) stopMonitoringAllRegions:(id)args;
@end
