//
//  APMeetingCell.h
//  Lesson 37-38 HW 2
//
//  Created by Alex on 23.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APMeetingInfoTableViewController.h"

@interface APMeetingCell : UITableViewCell

// Класс для нашей кастомной ячейки

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameSurnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *yesOrNoView;


@end
