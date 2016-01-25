//
//  UIView+MKAnnotationView.h
//  Lesson 37-38 HW 2
//
//  Created by Alex on 23.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKAnnotationView;

@interface UIView (MKAnnotationView)

// Категория, где мы делаем рекурсию, для того чтобы определять, по какой именно кнопке информации какого студента мы нажимаем.

- (MKAnnotationView*) superAnnotationView;

@end
