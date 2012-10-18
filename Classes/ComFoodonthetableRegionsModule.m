/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComFoodonthetableRegionsModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation ComFoodonthetableRegionsModule

@synthesize locationManager, lastEvent, options;


#pragma mark - Titanium Module

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"01778b3e-0a89-434b-8318-79d7ff74bc36";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.foodonthetable.regions";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
//	NSLog(@"[REGIONS] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
    [locationManager release];
    
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
//	NSLog(@"[REGIONS] listenerAdded %@", type);
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
//	NSLog(@"[REGIONS] listenerRemoved %@", type);
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma mark - Regions Implementation

-(CLLocationManager*)getLocationManager
{
    if (NULL == locationManager) {
        // Location Management stuff
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self fireEvent:@"didInitialize"];
    }
    return locationManager;
}


#pragma Public APIs
-(void)initialize:(id)newOptions
{
    ENSURE_SINGLE_ARG(newOptions, NSDictionary);
    [self setOptions:newOptions];
}

-(void)startMonitoring:(id)region
{
    ENSURE_UI_THREAD_1_ARG(region);
    ENSURE_SINGLE_ARG(region,NSDictionary);
    
    if ([CLLocationManager regionMonitoringAvailable]) {
//        NSLog(@"[REGIONS] startMonitoring");
        
        
        double lat = [(NSNumber*)[region objectForKey:@"lat"] doubleValue];
        double lng = [(NSNumber*)[region objectForKey:@"lng"] doubleValue];
        double radius = [(NSNumber*)[region objectForKey:@"radius"] doubleValue];
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lng);
        
        CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:coord
                                                radius:radius
                                                identifier:[region objectForKey:@"id"]];
        
        [[self getLocationManager] startMonitoringForRegion:newRegion];
        
        [newRegion release];
        
        [self fireEvent:@"startedMonitoringRegion" withObject:region];
    } else {
        NSLog(@"[REGIONS] regionMonitoring not available");
    }
}

-(void)stopMonitoring:(id)region
{
    ENSURE_UI_THREAD_1_ARG(region);
    ENSURE_SINGLE_ARG(region,NSDictionary);
    
    if ([CLLocationManager regionMonitoringAvailable]) {
        NSLog(@"[REGIONS] stopMonitoring");
        // Get all regions being monitored for this application.
        NSArray *regions = [[[self getLocationManager] monitoredRegions] allObjects];
        
        // Iterate through the regions and add annotations to the map for each of them.
        for (int i = 0; i < [regions count]; i++) {
            CLRegion *oldregion = [regions objectAtIndex:i];
            if ([[oldregion identifier] isEqualToString:[region objectForKey:@"id"]])
            {
                [[self getLocationManager] stopMonitoringForRegion:oldregion];
                [self fireEvent:@"stoppedMonitoringRegion" withObject:region];
            }
        }
    } else {
        NSLog(@"[REGIONS] regionMonitoring not available");
    }
}

-(void)stopMonitoringAllRegions:(id)args
{
    ENSURE_UI_THREAD_0_ARGS;
    // Get all regions being monitored for this application.
    if ([CLLocationManager regionMonitoringAvailable]) {
//        NSLog(@"[REGIONS] stopMonitoringAllRegions");
        NSArray *regions = [[locationManager monitoredRegions] allObjects];
	
        // Iterate through the regions and add annotations to the map for each of them.
        for (int i = 0; i < [regions count]; i++) {
            CLRegion *oldregion = [regions objectAtIndex:i];
            NSDictionary *jsRegion = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithDouble:oldregion.center.latitude],@"lat",
                                     [NSNumber numberWithDouble:oldregion.center.longitude],@"lng",
                                     [NSNumber numberWithDouble:oldregion.radius],@"radius",
                                     oldregion.identifier,@"id",
                                     nil];
            [[self getLocationManager] stopMonitoringForRegion:oldregion];
            [self fireEvent:@"stoppedMonitoringRegion" withObject:jsRegion];
        }
    } else {
        NSLog(@"[REGIONS] regionMonitoring not available");
    }
}

// NOTE: not on the UI thread since it returns something... hmmmm...
// If this is called too fast, it could cause problems
-(id)monitoredRegions:(id)args
{
    if ([CLLocationManager regionMonitoringAvailable])
    {
        if (locationManager)
        {
            // Get all regions being monitored for this application.
            NSArray *regions = [[locationManager monitoredRegions] allObjects];
            NSMutableArray* jsRegions = [NSMutableArray arrayWithCapacity:[regions count]];
            
            // Iterate through the regions and add annotations to the map for each of them.
            for (int i = 0; i < [regions count]; i++) {
                CLRegion *region = [regions objectAtIndex:i];
                NSDictionary *jsRegion = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithDouble:region.center.latitude],@"lat",
                                         [NSNumber numberWithDouble:region.center.longitude],@"lng",
                                         [NSNumber numberWithDouble:region.radius],@"radius",
                                         region.identifier,@"id",
                                         nil];
                [jsRegions addObject:jsRegion];
            }
            return jsRegions;
        } else {
            NSLog(@"[REGIONS] monitoredRegions called before locationManager properly initialized.");
            return [NSMutableArray arrayWithCapacity:0];
        }
    } else {
        NSLog(@"[REGIONS] regionMonitoring not available");
        return [NSMutableArray arrayWithCapacity:0];
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSString *formattedError = [NSString stringWithFormat:@"%@", error];
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                           formattedError,@"error",
                           nil];
	NSLog(@"[REGIONS] didFailWithError %@", formattedError);
    [self fireEvent:@"didFailWithError" withObject:event];
}


// This shouldn't be called since we're not using location stuff
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region  {
	NSString *msg = [NSString stringWithFormat:@"Enter %@ at %@", region.identifier, [NSDate date]];
    if (![msg isEqualToString:self.lastEvent])
    {

        [self setLastEvent:[NSString stringWithString:msg]];
        NSDictionary *region_info = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithDouble:region.center.latitude],@"lat",
                                     [NSNumber numberWithDouble:region.center.longitude],@"lng",
                                     [NSNumber numberWithDouble:region.radius],@"radius",
                                     region.identifier,@"id",
                                     nil];
        
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                               msg,@"message",
                               region_info,@"region",
                               nil];
//        NSLog(@"[REGIONS] didEnterRegion %@", msg);
        [self fireEvent:@"didEnterRegion" withObject:event];
    }
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
	NSString *msg = [NSString stringWithFormat:@"Exit %@ at %@", region.identifier, [NSDate date]];
    if (![msg isEqualToString:self.lastEvent])
    {
        [self setLastEvent:[NSString stringWithString:msg]];
        NSDictionary *region_info = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithDouble:region.center.latitude],@"lat",
                                 [NSNumber numberWithDouble:region.center.longitude],@"lng",
                                 [NSNumber numberWithDouble:region.radius],@"radius",
                                 region.identifier,@"id",
                                 nil];
    
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                               msg,@"message",
                               region_info,@"region",
                               nil];
//        NSLog(@"[REGIONS] didExitRegion %@", msg);
        [self fireEvent:@"didExitRegion" withObject:event];
    }
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
	NSString *formattedError = [NSString stringWithFormat:@"%@", error];
    [self setLastEvent:@""];
    NSDictionary *region_info = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithDouble:region.center.latitude],@"lat",
                                 [NSNumber numberWithDouble:region.center.longitude],@"lng",
                                 [NSNumber numberWithDouble:region.radius],@"radius",
                                 region.identifier,@"id",
                                 nil];
    
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                           formattedError,@"error",
                           region_info,@"region",
                           nil];
	NSLog(@"[REGIONS] monitoringDidFailForRegion %@", formattedError);
    [self fireEvent:@"monitoringDidFailForRegion" withObject:event];
}

@end
