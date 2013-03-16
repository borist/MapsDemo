//
//  BTViewController.m
//  MapsDemo
//
//  Created by Boris Treskunov on 3/15/13.
//  Copyright (c) 2013 Boris Treskunov. All rights reserved.
//

#import "BTViewController.h"

#define METERS_PER_MILE 1609.344

@interface BTViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@end

@implementation BTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set up notification listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnteredForeground:) name:@"appEnteredForeground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnteredBackground:) name:@"appEnteredBackground" object:nil];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
    self.locationManager.delegate = self;
    
    // Check if User has Location Services Enabled
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                        message:@"To enable, please go to Settings and turn on Location Services"
                                                        delegate:nil
                                                        cancelButtonTitle:@"Okay"
                                                        otherButtonTitles:nil, nil];
        [alert show];
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 1000;
    // Only update location when movement > 1000 meters
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    // Log the location change
    NSLog(@"lat: %f, lon: %f", location.coordinate.latitude, location.coordinate.longitude);
    // Add a pint to the map at the new location
    [self addPinToMapAtLocation:location];
}

- (void)addPinToMapAtLocation:(CLLocation *)location {
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = location.coordinate;
    
    // Get address from coordinates and set as title for pin
    [self.geocoder reverseGeocodeLocation:location completionHandler: ^(NSArray *placemarks, NSError *error) {
        //Get address from the coordinates, otherwise set title to coordinates
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString* locationAddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            pin.title = [[NSString alloc] initWithFormat:@"Last Determined Location:"];
            pin.subtitle = [[NSString alloc] initWithString:locationAddress];
        } else {
            pin.title = [[NSString alloc] initWithFormat:@"lat: %f, lon: %f", location.coordinate.latitude, location.coordinate.longitude];
        }
        
        [self.mapView addAnnotation:pin];
        
        // Zoom in on the newly dropped pin
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, .5*METERS_PER_MILE, .5*METERS_PER_MILE);
        [self.mapView setRegion:viewRegion animated:YES];
     }];
}

#pragma mark - methods responding to BTAppDelegate notifications

- (void)appEnteredForeground:(NSNotification *) notification {
    [self.locationManager startUpdatingLocation];
}

- (void)appEnteredBackground:(NSNotification *) notification {
    // Arrow in left hand corner of app still present - change in meaning of arrow in iOS 5+?
    [self.locationManager stopUpdatingLocation];
}

@end
