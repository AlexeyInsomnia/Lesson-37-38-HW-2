//
//  ViewController.h
//  Lesson 37-38 HW 2
//
//  Created by Alex on 22.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "APStudent.h"
#import "UIView+MKAnnotationView.h"
#import "APDescriptionPopover.h"
#import "APMeetPlace.h"
#import "APMeetingInfoTableViewController.h"



//#import <CoreLocation/Corelocation.h>

@class MKMapView;
@class CLLocation;
@class CLLocationManager;

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *userGeopositionButton;

- (IBAction)performUserGeopositionAction:(UIBarButtonItem *)sender;

@property (strong, nonatomic) CLLocationManager   *locationManager;
@property (strong, nonatomic) CLLocation          * location;

@end

