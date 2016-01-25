//
//  APDescriptionPopover.h
//  Lesson 37-38 HW 2
//
//  Created by Alex on 23.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface APDescriptionPopover : UITableViewController


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateBirthLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* userLastName;
@property (strong, nonatomic) NSString* userDateOfBirth;
@property (strong, nonatomic) NSString* userGender;
@property (strong, nonatomic) NSString* userAddress;

@end
