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
@end

@implementation BTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
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
    NSLog(@"lat: %f, lon: %f", location.coordinate.latitude, location.coordinate.longitude);
    [self addPinToMapAtLocation:location];
}

- (void)addPinToMapAtLocation:(CLLocation *)location {
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = location.coordinate;
    pin.title = [[NSString alloc] initWithFormat:@"lat: %f, long: %f", location.coordinate.latitude, location.coordinate.longitude];
    [self.mapView addAnnotation:pin];
}

@end
