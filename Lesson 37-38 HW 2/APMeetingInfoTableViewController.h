//
//  APMeetingInfoTableViewController.h
//  Lesson 37-38 HW 2
//
//  Created by Alex on 23.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APMeetingCell.h"
#import "APStudent.h"

@interface APMeetingInfoTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray* allFirstCircleStudentsSayingYES;
@property (strong, nonatomic) NSMutableArray* allFirstCircleStudents;

@property (strong, nonatomic) NSMutableArray* allSecondCircleStudentsSayingYES;
@property (strong, nonatomic) NSMutableArray* allSecondCircleStudents;

@property (strong, nonatomic) NSMutableArray* allThirdCircleStudentsSayingYES;
@property (strong, nonatomic) NSMutableArray* allThirdCircleStudents;

@end

