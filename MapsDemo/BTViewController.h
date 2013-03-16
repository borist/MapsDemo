//
//  BTViewController.h
//  MapsDemo
//
//  Created by Boris Treskunov on 3/15/13.
//  Copyright (c) 2013 Boris Treskunov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface BTViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
