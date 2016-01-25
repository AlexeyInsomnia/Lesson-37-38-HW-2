//
//  ViewController.m
//  Lesson 37-38 HW 2
//
//  Created by Alex on 22.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//


#import "ViewController.h"



@interface ViewController ()


@property (strong, nonatomic) NSMutableArray* students;
@property (assign, nonatomic) CLLocationCoordinate2D centerPoint;
@property (assign, nonatomic) CLLocationCoordinate2D meetPoint;
@property (assign, nonatomic) BOOL haveMeetPlaceMark;
@property (assign, nonatomic) BOOL haveRoutes;
@property (assign, nonatomic) double firstCircleRadius;
@property (assign, nonatomic) double secondCircleRadius;
@property (assign, nonatomic) double thirdCircleRadius;

// Массивы студентов в кругах, а также согласившихся придти на встречу студентов
@property (strong, nonatomic) NSMutableArray* allFirstCircleStudents;
@property (strong, nonatomic) NSMutableArray* allFirstCircleStudentsSayingYES;

@property (strong, nonatomic) NSMutableArray* allSecondCircleStudents;
@property (strong, nonatomic) NSMutableArray* allSecondCircleStudentsSayingYES;

@property (strong, nonatomic) NSMutableArray* allThirdCircleStudents;
@property (strong, nonatomic) NSMutableArray* allThirdCircleStudentsSayingYES;

// Массив, в который кладем маршруты до места встречи. Мы его очищаем (убираем маршруты с карты) при повторном нажатии на кнопку Refresh.
@property (strong, nonatomic) NSMutableArray* allRoutesArray;

// test - this is for description popover
@property (strong, nonatomic) CLGeocoder* geoCoder;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // test
    self.geoCoder = [[CLGeocoder alloc] init];

    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // this is just for upwork in ios 8+
    
    self.locationManager = [[CLLocationManager alloc ] init];
    self.locationManager.delegate = self;
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    _mapView.showsUserLocation = YES;
    
    // upper for ios 8+
    
    
    
    // Current Location по умолчанию - Адрес Apple в Сан-Франциско
    
    // Moscow - 55.62, 37.7 (latitude, longitude)
    
    self.allFirstCircleStudents = [NSMutableArray array];
    self.allFirstCircleStudentsSayingYES = [NSMutableArray array];
    self.allSecondCircleStudents = [NSMutableArray array];
    self.allSecondCircleStudentsSayingYES = [NSMutableArray array];
    self.allThirdCircleStudents = [NSMutableArray array];
    self.allThirdCircleStudentsSayingYES = [NSMutableArray array];
    
    self.allRoutesArray = [NSMutableArray array];
    self.students = [NSMutableArray array];
   
   
    self.haveRoutes = NO;
    
    
    // Вызов сообщения о разрешении отслеживания геопозиции.
    [self.locationManager requestWhenInUseAuthorization];
    
    self.mapView.showsUserLocation = YES;
    
    //[self.locationManager startUpdatingLocation];
    
    // кнопка показывает друзей
    UIBarButtonItem* showFriendsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showFriendsAction)];
    
    // кнопка позволяет добавить на карту место встречи
    UIBarButtonItem* addMeetPlaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMeetPlaceAction:)];
    
    // кнопка прокладывает маршруты от студентов до места встречи
    UIBarButtonItem* addRoutesButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(addRoutesAction:)];
    
    self.navigationItem.rightBarButtonItems = @[self.userGeopositionButton, showFriendsButton, addMeetPlaceButton];
    
    self.navigationItem.leftBarButtonItem = addRoutesButton;

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Own methods

- (void) createStudents {
    // Создание студентов
    
    int studentsCount = arc4random_uniform(11) + 10; // от 10 до 20 студентов
    
    self.centerPoint = self.mapView.userLocation.location.coordinate;
    
    if ([self.students count] > 0) {
        // Если студенты заново создаются, массив очищается для записи новой партии студентов
        
        [self.students removeAllObjects];
        
    }
    
    for (int i = 1; i < studentsCount; i++) {
        
        APStudent* student = [[APStudent alloc] initWithStudentGeoInformationAndCenterPoint:self.centerPoint];
        
        [self.students addObject:student];
        
    }
    
}

- (void) createCirclesOnMeetPlace:(CLLocationCoordinate2D) coordinate {
    // Создание оверлеев. 3 круга вокруг места встречи.
    
    // значения в метрах
    self.firstCircleRadius = 5000;
    self.secondCircleRadius = 10000;
    self.thirdCircleRadius = 15000;
    
    MKCircle* firstCircle = [MKCircle circleWithCenterCoordinate:coordinate radius:self.firstCircleRadius];
    
    MKCircle* secondCircle = [MKCircle circleWithCenterCoordinate:coordinate radius:self.secondCircleRadius];
    
    MKCircle* thirdCircle = [MKCircle circleWithCenterCoordinate:coordinate radius:self.thirdCircleRadius];
    
    [self.mapView addOverlays:@[firstCircle, secondCircle, thirdCircle] level:MKOverlayLevelAboveRoads];
    
}

- (void) clearCircleAreaStudentsArrays {
    // Очищение массивов студентов в случае перемещения метки встречи. Другие студенты теперь могут попасть в круги.
    
    if ([self.allFirstCircleStudents count] > 0) {
        
        [self.allFirstCircleStudents removeAllObjects];
        
    }
    
    if ([self.allFirstCircleStudentsSayingYES count] > 0) {
        
        [self.allFirstCircleStudentsSayingYES removeAllObjects];
        
    }
    
    if ([self.allSecondCircleStudents count] > 0) {
        
        [self.allSecondCircleStudents removeAllObjects];
        
    }
    
    if ([self.allSecondCircleStudentsSayingYES count] > 0) {
        
        [self.allSecondCircleStudentsSayingYES removeAllObjects];
        
    }
    
    if ([self.allThirdCircleStudents count] > 0) {
        
        [self.allThirdCircleStudents removeAllObjects];
        
    }
    
    if ([self.allThirdCircleStudentsSayingYES count] > 0) {
        
        [self.allThirdCircleStudentsSayingYES removeAllObjects];
        
    }
    
}

- (void) calculateStudentsCatchingInMeetPlaceArea {
    
    // Метод чистит массивы студентов в кругах, в случае, если метка переносится
    [self clearCircleAreaStudentsArrays];
    
    // функция считает расстояние между точками на карте! точки (CLLocation)
    //    CLLocationDistance distance = [location1 getDistanceFrom:location2];
    
    CLLocation* meetPlace = [[CLLocation alloc] initWithLatitude:self.meetPoint.latitude longitude:self.meetPoint.longitude];
    
    for (APStudent* student in self.students) {
        
        CLLocation* studentLocation = [[CLLocation alloc] initWithLatitude:student.coordinate.latitude longitude:student.coordinate.longitude];
        
        CLLocationDistance distance = [studentLocation distanceFromLocation:meetPlace];
        
        // ЗНАЕМ расстояния от каждого студента до места встречи. Теперь надо сгенерировать пожелания студентов пойти на встречу!!!
        
        distance = distance / 1000; // переводим в километры
        
        //        NSLog(@"distance between %@ %@ and meetPlace - %.2f km", student.name, student.surname, distance);
        
        // расстояние от студента до места встречи
        student.distanceToMeeting = distance; // сохранили в километрах
        
        BOOL iWillCome = NO;
        
        // оформим вероятность прихода на встречу (в радиусе 5 км - 90%, что придет, в радиусе 10 км - 50%, в радиусе 15 км - 10%, больше 15 км - 0%)
        
        // Нам нужны только студенты, которые придут на встречу, поэтому мы раскидываем студентов в три массива, кто в каком круге, тех кто придет кладем в отдельный массив для отображения
        
        if (distance <= self.firstCircleRadius/1000) {
            
            // Внутри 5 километрового радиуса (вероятность придти - 90%)
            
            int chance = arc4random_uniform(10) + 1; // (от 1 до 10, 90% - 9 чисел из 10)
            
            iWillCome = YES ? chance <= 9 : NO;
            
            if (iWillCome == YES) {
                
                // массив всех согласившихся придти на встречу в первом круге
                [self.allFirstCircleStudentsSayingYES addObject:student];
                
                // массив всех студентов первого круга
                [self.allFirstCircleStudents addObject:student];
                
            } else {
                
                // отказавшиеся идут в общий массив
                [self.allFirstCircleStudents addObject:student];
                
            }
            
        } else if (distance > self.firstCircleRadius/1000 && distance <= self.secondCircleRadius/1000) {
            
            // Внутри 10 километрового радиуса, но вне 5 километрового (вероятность придти - 50%)
            
            iWillCome = arc4random_uniform(2); // 0 или 1 (нет или да)
            
            if (iWillCome == YES) {
                
                [self.allSecondCircleStudentsSayingYES addObject:student];
                
                [self.allSecondCircleStudents addObject:student];
                
            } else {
                
                [self.allSecondCircleStudents addObject:student];
                
            }
            
        } else if (distance > self.secondCircleRadius/1000 && distance <= self.thirdCircleRadius/1000) {
            
            // Внутри 15 километрового радиуса, но вне 10 километрового (вероятность придти - 10%)
            
            int chance = arc4random_uniform(10) + 1; // (от 1 до 10, 10% - 1 число из 10)
            
            iWillCome = YES ? chance > 9 : NO;
            
            if (iWillCome == YES) {
                
                [self.allThirdCircleStudentsSayingYES addObject:student];
                
                [self.allThirdCircleStudents addObject:student];
                
            } else {
                
                [self.allThirdCircleStudents addObject:student];
                
            }
            
        }
        
    } // Массивы для поповера заполнены
    
}



- (void) showAlertWithTitle:(NSString*) title andMessage:(NSString*) message {
    
    // since UIAlertView is deprecated lets use UIAlertController
    // Метод показывает AlertView с переданными значениями title и message
    
    UIAlertAction* actionCancel = nil;
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    //cancel button
    
    actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                            style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * _Nonnull action) {
                                              // cancel code
                                          }];
    [alertController addAction:actionCancel];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark - Actions

- (IBAction)performUserGeopositionAction:(UIBarButtonItem *)sender {
    
    
    // Метод увеличивает нам район с текущей нашей геопозицией
    
    if ([self.mapView.annotations count] <= 1) {
        // текущая геопозиция
        
        //    NSLog(@"performUserGeopositionAction");
        
        MKMapPoint center = MKMapPointForCoordinate(self.mapView.userLocation.location.coordinate);
        
        static double delta = 20000;
        
        // делаем прямоугольник, центр - наша геопозиция
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, 2 * delta, 2 * delta);
        
        // Метод вписывает наш прямоугольник в экран девайса (ВАЖНО!)
        rect = [self.mapView mapRectThatFits:rect];
        
        [self.mapView setVisibleMapRect:rect
                            edgePadding:UIEdgeInsetsMake(0, 0, 0, 0)
                               animated:YES];
        
    } else {
        // код показывает текущую геопозицию вместе со студентами на экране
        
        //        NSLog(@"CorrectGeopositionToWatchingFriends");
        
        MKMapRect zoomRect = MKMapRectNull;
        
        for (id <MKAnnotation> annotation in self.mapView.annotations) {
            // для всех маркеров на карте, мы делаем общий zoomRect, объединяющий все rect всех маркеров
            
            CLLocationCoordinate2D location = annotation.coordinate; // градусы
            
            MKMapPoint center = MKMapPointForCoordinate(location); // 2Д координаты
            
            static double delta = 100000;
            
            MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, 2 * delta, 2 * delta);
            
            // метод объядиняет прямоугольники zoomRect и rect (выдает нам прямоугольник, содержащий данные два)
            zoomRect = MKMapRectUnion(zoomRect, rect);
            
            zoomRect = [self.mapView mapRectThatFits:zoomRect];
            
            [self.mapView setVisibleMapRect:rect
                                edgePadding:UIEdgeInsetsMake(0, 0, 0, 0) //сделали отступы чтобы пины не были на грани ректа
                                   animated:YES];
            
        }
        
        
    }
    

}


- (void) showFriendsAction { // Метод для отображения друзей на карте
    
    NSLog(@"showFriendsAction");
    
    
    
    for (APStudent* student in self.students) {
        
        
        [self.mapView addAnnotation:student];
        
    }
    
}

- (void) descriptionButtonAction:(UIButton*) sender {
    
    MKAnnotationView* annotationView = [sender superAnnotationView];
    
    if (!annotationView) {
        return;
    }
    
    CLLocationCoordinate2D coordinate = annotationView.annotation.coordinate;
    
    CLLocation* location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
    
    if ([self.geoCoder isGeocoding]) {
        [self.geoCoder cancelGeocode];
    }
    
    [self.geoCoder
     reverseGeocodeLocation:location
     completionHandler:^(NSArray *placemarks, NSError *error) {
         
         NSString* message = nil;
         
         if (error) {
             
             message = [error localizedDescription];
             
         } else {
             
             if ([placemarks count] > 0) {
                 
                 MKPlacemark* placemark = [placemarks firstObject];
                 
                 message = [placemark.addressDictionary valueForKey:@"Street"];
                 
                 if ([message length] == 0) {
                     
                     message = @"No any names of streets";
                     
                 }

             } else {
                 message = @"No Placemarks Found";
             }
         }
         
         // Доступ к информации о студенте обеспечиваем при помощи свойства Annotation у MKAnnotationView.
         APStudent* student = annotationView.annotation;
         NSLog(@"%@, %@, %@, %@,%@",student.name, student.surname, student.subtitle,student.gender,message);
         
         //[self showAlertWithTitle:@"Location" andMessage:message]; // это если через Алерт
         // ниже метод если через Поповер
         [self descriptionPopover:sender
                             name:student.name
                         lastName:student.surname
                         birthDay:student.subtitle
                           gender:student.gender
                          address:message];

     }];
}


-(void) descriptionPopover:(id)sender
                      name:(NSString*) name
                  lastName:(NSString*) lastName
                  birthDay:(NSString*) birthDay
                    gender:(NSString*) gender
                   address:(NSString*) address
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    APDescriptionPopover* controller = [storyboard instantiateViewControllerWithIdentifier:@"APDescriptionPopover"];
    
    controller.modalPresentationStyle = UIModalPresentationPopover;
    
    controller.userName = name;
    controller.userLastName = lastName;
    controller.userDateOfBirth = birthDay;
    controller.userGender = gender;
    controller.userAddress = address;
    
    //controller.delegate = self; // activate subscribe to delegate of pickdateviewcontroller
    
    [self presentViewController:controller animated:YES completion:nil];
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    // in case we don't have a bar button as reference
    popController.sourceView = sender;
    popController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    popController.sourceView = sender;
    popController.sourceRect = CGRectMake(0,0,0,0);
    //popController.delegate = self; // also done in storyboard
}

- (void) addMeetPlaceAction:(UIBarButtonItem*) sender {
    // Метод добавления маркера встречи на карту
    
    //    NSLog(@"addMeetPlaceAction");
    
    self.haveMeetPlaceMark = YES; // даем сигнал, что хотим поставить маркер встречи
    
    // since UIAlertView is deprecated lets use UIAlertController
    // Метод показывает AlertView с переданными значениями title и message
    
    UIAlertAction* actionCancel = nil;
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Add meetmark"
                                                                             message:@"Click on map to add meetmark"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    //cancel button
    
    actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"GOT IT!", nil)
                                            style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * _Nonnull action) {
                                              // cancel code
                                          }];
    [alertController addAction:actionCancel];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // место встречи создается по тэпу по карте!
    // куда тэпаем, там и создается маркер
    
    // метод переводит координаты UIView в CLLocationCoordinate2D (долгота и широта).
    //    - (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view;
    // теперь нужно поймать точку касания.
    
    if (self.haveMeetPlaceMark == YES) {
        
        UITouch* touch = [touches anyObject];
        
        CGPoint meetPoint = [touch locationInView:self.mapView];
        
        
        self.meetPoint = [self.mapView convertPoint:meetPoint toCoordinateFromView:self.mapView];
        
        
        APMeetPlace* meetPlace = [[APMeetPlace alloc] initWithMeetPlace:self.meetPoint];
        
        [self.mapView addAnnotation:meetPlace];
        
        //        NSLog(@"touchesEnded");
        
    }
    
}

- (void) showMeetingInfoAction:(UIButton*) sender {
    
    // ЗДЕСЬ БУДЕМ ДЕЛАТЬ ПОПОВЕР С ИНФОРМАЦИЕЙ, КТО ПРИДЕТ НА ВСТРЕЧУ И СКОЛЬКО СТУДЕНТОВ НАХОДИТСЯ В ТЕХ ИЛИ ИНЫХ КРУГАХ!
    // ПОПОВЕР ПОКАЗЫВАЕТ СПИСКИ ВСЕХ ДРУЗЕЙ РАЗБИТЫЕ ПО СЕКЦИЯМ (по 3 кругам)
    // ВЫДЕЛЯЕМ СТУДЕНТОВ КОТОРЫЕ ПРИДУТ
    
    //ДЕЛАЕМ ЯЧЕЙКИ EGMeetingInfoTableViewController для ОТОБРАЖЕНИЯ
    // Так как у нас кастомные ячейки, нужен класс под них для отображения данных
    // Данные - аватар, имя, фамилия, сколько километров до места встречи, значок идет на встречу или нет (галка или крестик)
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    APMeetingInfoTableViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"APMeetingInfoTableViewController"];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    
    vc.allFirstCircleStudents = self.allFirstCircleStudents;
    vc.allFirstCircleStudentsSayingYES = self.allFirstCircleStudentsSayingYES;
    
    vc.allSecondCircleStudents = self.allSecondCircleStudents;
    vc.allSecondCircleStudentsSayingYES = self.allSecondCircleStudentsSayingYES;
    
    vc.allThirdCircleStudents = self.allThirdCircleStudents;
    vc.allThirdCircleStudentsSayingYES = self.allThirdCircleStudentsSayingYES;
    
    nav.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:nav animated:YES completion:nil];
    UIPopoverPresentationController *popController = [nav popoverPresentationController];
    popController.sourceView = sender;
    popController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    popController.sourceView = sender;
    
    
}



- (void) addRoutesAction:(UIBarButtonItem*) sender {
    
    // ЗДЕСЬ БУДЕМ ПРОКЛАДЫВАТЬ МАРШРУТЫ.
    // ПОСЛЕ ТОГО, КАК ПОСТАВИЛИ МЕТКУ, УЖЕ ЗНАЕМ, КТО ПОЙДЕТ НА ВСТРЕЧУ, КТО НЕТ - ЕСТЬ ДОСТУП К МАССИВАМ.
    
    if (self.haveRoutes == NO) {
        // Условие необходимо, так как при повторном нажатии мы будем убирать маршруты с карты
        
        self.haveRoutes = YES;
        
        // Если в массиве маршрутов до места встречи есть элементы, мы их удаляем, так как маршруты будут перестраиваться далее и записываться в тот же массив. Это нужно для того, чтобы self.allRoutesArray не накапливал элементы
        if ([self.allRoutesArray count] > 0) {
            
            [self.allRoutesArray removeAllObjects];
            
        }
        
        //        NSLog(@"addRoutesAction");
        
        NSMutableArray* allSayingYESStudents = [NSMutableArray array];
        
        NSMutableArray* routesArray = [NSMutableArray array];
        
        // Объединили всех, согласившихся придти на встречу в один массив
        allSayingYESStudents = (NSMutableArray*)[allSayingYESStudents arrayByAddingObjectsFromArray:self.allFirstCircleStudentsSayingYES];
        
        allSayingYESStudents = (NSMutableArray*)[allSayingYESStudents arrayByAddingObjectsFromArray:self.allSecondCircleStudentsSayingYES];
        
        allSayingYESStudents = (NSMutableArray*)[allSayingYESStudents arrayByAddingObjectsFromArray:self.allThirdCircleStudentsSayingYES];
        
        // Через данный класс будем прокладывать маршрут между двумя точками
        MKDirectionsRequest* request = [[MKDirectionsRequest alloc] init];
        
        MKPlacemark* destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.meetPoint addressDictionary:nil];
        
        // Определили геопозицию места встречи для прокладывания маршрутов.
        MKMapItem* destinationLocation = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
        
        request.destination = destinationLocation;
        
        for (APStudent* student in allSayingYESStudents) {
            
            MKPlacemark* studentLocationPlacemark = [[MKPlacemark alloc] initWithCoordinate:student.coordinate addressDictionary:nil];
            
            MKMapItem* sourceLocation = [[MKMapItem alloc] initWithPlacemark:studentLocationPlacemark];
            
            // Начальная геопозиция каждого согласившегося студента.
            request.source = sourceLocation;
            
            // Добираться на автомобиле.
            request.transportType = MKDirectionsTransportTypeAutomobile;
            
            MKDirections* directions = [[MKDirections alloc] initWithRequest:request];
            
            // прокладываем маршрут
            [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                
                if (error) {
                    
                    [self showAlertWithTitle:@"ERROR" andMessage:[error localizedDescription]];
                    
                } else if ([response.routes count] == 0) {
                    
                    [self showAlertWithTitle:@"NO ROUTES" andMessage:@"No routes found"];
                    
                } else {
                    
                    for (MKRoute* route in response.routes) {
                        
                        [routesArray addObject:route.polyline];
                        
                    }
                    
                    // добавляем линии маршрута на карту, прежде отрендерив.
                    [self.mapView addOverlays:routesArray level:MKOverlayLevelAboveRoads];
                    
                    [self.allRoutesArray addObject:routesArray];
                    
                }
                
            }];
            
        }
        
    } else {
        
        // Прячем проложенные маршруты
        
        for (NSArray* route in self.allRoutesArray) {
            
            [self.mapView removeOverlays:route];
            
        }
        
        self.haveRoutes = NO;
        
    }
    
}

#pragma mark -  CLLocationManagerDelegate


-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    // this is for work in ios 9
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    //self.locationManager = locations.lastObject;
    self.location = locations.lastObject;
    
    //    NSLog(@"location - %.2f, %.2f", self.mapView.userLocation.location.coordinate.latitude, self.mapView.userLocation.location.coordinate.longitude);
    
    [self createStudents]; // создаем здесь студентов, так как координата центра, от которой мы зависим, к этому моменту восстановится
    
}





#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    NSLog(@"location - %.2f, %.2f", self.mapView.userLocation.location.coordinate.latitude, self.mapView.userLocation.location.coordinate.longitude);
    
    [self createStudents]; // создаем здесь студентов, так как координата центра, от которой мы зависим, к этому моменту восстановится
    
    NSLog(@"%@", self.students);
    
}


- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    // в этом методе делегата в тестовом задании делали анимацию для пина и тп
    
    // В методе делаем свои метки на карте, выставляем картинки
    
    //    NSLog(@"viewForAnnotation");
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        // Если аннотация - наша геопозиция
        
        return nil;
        
    }
    
    static NSString* identifier = @"annotation";
    
    MKAnnotationView* pin = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    // Если делать через MKPinAnnotationView, то при перетаскивании метки, она будет заменяться на дефолтный красный пин, поэтому пин создаем через MKAnnotationView
    
    if (!pin) {
        
        pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
        UIButton* descriptionButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        [descriptionButton addTarget:self
                              action:@selector(descriptionButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        // кнопка информации о студенте
        pin.rightCalloutAccessoryView = descriptionButton;
        
    }
    
    if ([annotation isKindOfClass:[APStudent class]]) {
        // Если аннотация - студент
        
        APStudent* student = annotation;
        
        if ([student.gender isEqualToString:@"Male"]) { // Мужская метка на карте
            
            pin.image = [UIImage imageNamed:@"boy.png"];
            pin.canShowCallout = YES;
            
        } else { // Женская метка на карте
            
            pin.image = [UIImage imageNamed:@"girl.png"];
            pin.canShowCallout = YES;
            
        }
        
    }
    
    
     else if ([annotation isKindOfClass:[APMeetPlace class]]) {
     // Если аннотация - метка встречи!
     
     static NSString* meetingIdentifier = @"meetingAnnotation";
     
     pin = [mapView dequeueReusableAnnotationViewWithIdentifier:meetingIdentifier];
     
     if (!pin) {
     
     pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:meetingIdentifier];
     
     UIButton* showMeetingInfoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
     
     [showMeetingInfoButton addTarget:self
     action:@selector(showMeetingInfoAction:)
     forControlEvents:UIControlEventTouchUpInside];
     
     // Кнопка информации о встрече
     
     pin.rightCalloutAccessoryView = showMeetingInfoButton;
     
     }
     
     
     if (self.haveMeetPlaceMark == YES) {
     
     pin.image = [UIImage imageNamed:@"02.png"];
     pin.draggable = YES;
     pin.canShowCallout = YES;
     
     [self.mapView removeOverlays:self.mapView.overlays];
     
     // создание окружностей (5, 10, 15 км)
     [self createCirclesOnMeetPlace:self.meetPoint];
     
     // Считаем студентов, попавших под радиусы места встречи.
     [self calculateStudentsCatchingInMeetPlaceArea];
     
     self.haveMeetPlaceMark = NO;
     
     }
     
     
     }
    
    
    else {
        
        // метка по умолчанию
        pin.annotation = annotation;
        
        
    }
    
    return pin;
    
    
    
    
    
    
}





- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState {
    // метод вызывается, если меняем положение метки
    
    // так как меняем положение места встречи, на время убираем круги.
    [self.mapView removeOverlays:self.mapView.overlays];
    
    //    NSLog(@"didChangeDragState");
    
    
    // Если поставили метку на новое место
    
    
    
    if (newState == MKAnnotationViewDragStateEnding) {
        
        if ([view.annotation isKindOfClass:[APMeetPlace class]]) {
            
            view.dragState = MKAnnotationViewDragStateNone; // После установки маркера, он не будет ездить по карте вместе со скроллингом.
            
            // создаем круги после перемещения метки
            
            [self createCirclesOnMeetPlace:view.annotation.coordinate];
            
            self.meetPoint = view.annotation.coordinate;
            
            // маршрутов нет
            self.haveRoutes = NO;
            
            // При переносе метки, координаты местоположения обновляются
            APMeetPlace* meetPlace = view.annotation;
            
            meetPlace.subtitle = [NSString stringWithFormat:@"latitude - %.2f longitude - %.2f", meetPlace.coordinate.latitude, meetPlace.coordinate.longitude];
            
            // Пересчитываем студентов после перемещения метки встречи
            [self calculateStudentsCatchingInMeetPlaceArea];
            
            //            NSLog(@"refreshingMeetMark");
            
        }
        
    }
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    // Детали рисунка на карте (толщина линий, цвет и т.д.)
    
    //    NSLog(@"rendererForOverlay");
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        // если рисунок - круг!
        
        MKCircleRenderer* renderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        
        renderer.lineWidth = 2.f;
        
        renderer.strokeColor = [UIColor greenColor]; // цвет линии
        
        CGFloat r = 189.f; // слегка зеленый цвет)
        CGFloat g = 252.f;
        CGFloat b = 182.f;
        
        // цвет всего круга
        renderer.fillColor = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:0.2];
        
        return renderer;
        
    } else if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        // если рисунок - линии маршрутов
        
        MKPolylineRenderer* renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        
        renderer.lineWidth = 4.f;
        
        renderer.strokeColor = [UIColor blueColor];
        
        renderer.alpha = 0.5f;
        
        return renderer;
        
    }
    
    return nil;
    
}





@end
