//
//  APMeetingInfoTableViewController.m
//  Lesson 37-38 HW 2
//
//  Created by Alex on 23.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "APMeetingInfoTableViewController.h"

@interface APMeetingInfoTableViewController ()

// Массив в котором лежат массивы студентов в радиусах.
@property (strong, nonatomic) NSMutableArray* allCircles;


@end

@implementation APMeetingInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allCircles = [NSMutableArray array];
    self.navigationItem.title = @"Meeting info";
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backButtonAction:)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self checkArrays];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    
    NSLog(@"EGMeetingInfoTableViewController has been deallocated");
    
}

#pragma mark - Own methods

- (void) checkArrays {
    // Проверяем, передали ли мы данные из другого контроллера
    
    if (self.allFirstCircleStudents) {
        
        self.allFirstCircleStudents = self.allFirstCircleStudents;
        
        [self.allCircles addObject:self.allFirstCircleStudents];
        
    }
    
    if (self.allFirstCircleStudentsSayingYES) {
        
        self.allFirstCircleStudentsSayingYES = self.allFirstCircleStudentsSayingYES;
        
    }
    
    if (self.allSecondCircleStudents) {
        
        self.allSecondCircleStudents = self.allSecondCircleStudents;
        
        [self.allCircles addObject:self.allSecondCircleStudents];
        
    }
    
    if (self.allSecondCircleStudentsSayingYES) {
        
        self.allSecondCircleStudentsSayingYES = self.allSecondCircleStudentsSayingYES;
        
    }
    
    if (self.allThirdCircleStudents) {
        
        self.allThirdCircleStudents = self.allThirdCircleStudents;
        
        [self.allCircles addObject:self.allThirdCircleStudents];
        
    }
    
    if (self.allThirdCircleStudentsSayingYES) {
        
        self.allThirdCircleStudentsSayingYES = self.allThirdCircleStudentsSayingYES;
        
    }
    
}


#pragma mark - Actions

- (void) backButtonAction:(UIBarButtonItem*) sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITableViewDelegate


#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString* header;
    
    // Выставляем названия секциям из сравнения массивов.
    
    NSMutableArray* array = [self.allCircles objectAtIndex:section];
    
    if ([array count] == 0) {
        
        return nil;
        
    } else {
        
        if (array == self.allFirstCircleStudents) {
            
            header = @"Friends in 5 km circle";
            
        } else if (array == self.allSecondCircleStudents) {
            
            header = @"Friends in 10 km circle";
            
        } else if (array == self.allThirdCircleStudents) {
            
            header = @"Friends in 15 km circle";
            
        }
        
    }
    
    return header;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return [self.allCircles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSMutableArray* array = [self.allCircles objectAtIndex:section];
    
    return [array count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"meetingCell";
    
    // Кастомная ячейка со своим классом, созданная в сториборде
    APMeetingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    NSMutableArray* resultArray = [self.allCircles objectAtIndex:indexPath.section];
    
    APStudent* student = [resultArray objectAtIndex:indexPath.row];
    
    if ([student.gender isEqualToString:@"Male"]) {
        
        cell.avatar.image = [UIImage imageNamed:@"male.png"];
        
    } else {
        
        cell.avatar.image = [UIImage imageNamed:@"female.png"];
        
    }
    
    cell.nameSurnameLabel.text = [NSString stringWithFormat:@"%@ %@", student.name, student.surname];
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.2f km", student.distanceToMeeting];
    
    // Если, хоть в каком нибудь массиве содержится студент, согласившийся придти на встречу, мы ему ставим зеленую галочку!!!
    if ([self.allFirstCircleStudentsSayingYES containsObject:student] || [self.allSecondCircleStudentsSayingYES containsObject:student] || [self.allThirdCircleStudentsSayingYES containsObject:student]) {
        
        cell.yesOrNoView.image = [UIImage imageNamed:@"checkYES.png"];
        
    } else {
        
        cell.yesOrNoView.image = [UIImage imageNamed:@"checkNO.png"];
        
    }
    
    return cell;
}



@end
