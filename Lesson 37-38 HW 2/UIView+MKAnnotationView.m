//
//  UIView+MKAnnotationView.m
//  Lesson 37-38 HW 2
//
//  Created by Alex on 23.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "UIView+MKAnnotationView.h"
#import <MapKit/MKAnnotationView.h>

@implementation UIView (MKAnnotationView)

- (MKAnnotationView*) superAnnotationView {
    
    if ([self isKindOfClass:[MKAnnotationView class]]) {
        
        return (MKAnnotationView*)self;
        
    }
    
    if (!self.superview) {
        
        return nil;
        
    }
    
    return [self.superview superAnnotationView];
    
}

@end