//
//  APMeetPlace.h
//  Lesson 37-38 HW 2
//
//  Created by Alex on 23.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ViewController.h"

@interface APMeetPlace : NSObject <MKAnnotation>

// Класс для места встречи

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (instancetype)initWithMeetPlace:(CLLocationCoordinate2D) meetPlaceCoordinate;

@end



