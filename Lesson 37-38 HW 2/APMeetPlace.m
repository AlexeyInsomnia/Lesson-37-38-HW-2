//
//  APMeetPlace.m
//  Lesson 37-38 HW 2
//
//  Created by Alex on 23.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APMeetPlace.h"

@implementation APMeetPlace

- (instancetype)initWithMeetPlace:(CLLocationCoordinate2D) meetPlaceCoordinate
{ // создали отдельный класс, с которым будем инициализировать метку встречи по отправленной координате meetPlaceCoordinate
    self = [super init];
    
    if (self) {
        
        self.coordinate = meetPlaceCoordinate;
        
        self.title = @"MEETING PLACE";
        
        self.subtitle = [NSString stringWithFormat:@"latitude - %.2f longitude - %.2f", self.coordinate.latitude, self.coordinate.longitude];
        
    }
    
    return self;
}

@end
