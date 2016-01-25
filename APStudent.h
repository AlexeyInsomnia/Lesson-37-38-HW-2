//
//  APStudent.h
//  Lesson 37-38 HW 2
//
//  Created by Alex on 22.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ViewController.h"

@interface APStudent : NSObject <MKAnnotation> // Реализовали тут протокол, чтобы объекты данного класса отображать на карте

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* surname;
@property (strong, nonatomic) NSString* gender;
@property (assign, nonatomic) NSDate* dateOfBirth;
@property (strong, nonatomic) NSString* address;
@property (assign, nonatomic) double distanceToMeeting;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithStudentGeoInformationAndCenterPoint:(CLLocationCoordinate2D) centerPoint;


@end






