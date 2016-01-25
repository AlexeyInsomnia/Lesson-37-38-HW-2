//
//  APDescriptionPopover.m
//  Lesson 37-38 HW 2
//
//  Created by Alex on 23.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APDescriptionPopover.h"

@implementation APDescriptionPopover

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // dismiss by tap
    
    // Выставляем поповеру свойства, полученные из дочернего контроллера
    
    if (self.userName) {
        
        NSLog(@"GOT THE NAME");
        
        [self.nameLabel setText:self.userName];
        
    }
    
    if (self.userLastName) {
        
        NSLog(@"GOT THE SURNAME");
        
        [self.lastNameLabel     setText:self.userLastName];
        
    }
    
    if (self.userDateOfBirth) {
        
        NSLog(@"GOT THE BIRTHDAY");
        
        [self.dateBirthLabel setText:self.userDateOfBirth];
        
    }
    
    if (self.userGender) {
        
        NSLog(@"GOT THE GENDER");
        
        [self.genderLabel setText:self.userGender];
        
    }
    
    if (self.userAddress) {
        
        NSLog(@"GOT THE ADDRESS");
        
        [self.addressLabel setText:self.userAddress];
        
        NSLog(@"userAddress - %@", self.userAddress);
        
    }
    


    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInfoViewController)];
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}

-(void)dismissInfoViewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    
    NSLog(@"APDescriptionPopover deallocated");
}


@end

