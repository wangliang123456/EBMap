//
//  ViewController.m
//  EBDemo
//
//  Created by Eric on 2016/8/18.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    MKMapView *mapView;
    UITextField *searchField;
    UIButton *currentLocation;
    CLLocationManager *locationManager;
}

#pragma mark init the view
-(void) initView
{
    self.view.backgroundColor = [UIColor yellowColor];
    mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    mapView.mapType = MKMapTypeStandard;
    mapView.showsCompass = YES;
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.view addConstraints:@[width,height,centerX,centerY]];
    
    searchField = [[UITextField alloc] initWithFrame:CGRectZero];
    searchField.delegate = self;
    searchField.translatesAutoresizingMaskIntoConstraints = NO;
    searchField.placeholder = @"search the location";
    [self.view addSubview:searchField];
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.textAlignment = NSTextAlignmentCenter;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSLayoutConstraint *searchFieldCenterX = [NSLayoutConstraint constraintWithItem:searchField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *searchFieldTop = [NSLayoutConstraint constraintWithItem:searchField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:26];
    UIScreen *screen = [UIScreen mainScreen];
    NSLayoutConstraint *searchFieldWidth = [NSLayoutConstraint constraintWithItem:searchField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:screen.bounds.size.width - 46];
    NSLayoutConstraint *searchFieldHeight = [NSLayoutConstraint constraintWithItem:searchField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
    [self.view addConstraints:@[searchFieldCenterX,searchFieldTop,searchFieldWidth,searchFieldHeight]];
    
    currentLocation = [[UIButton alloc] initWithFrame:CGRectZero];
    currentLocation.translatesAutoresizingMaskIntoConstraints = NO;
    currentLocation.layer.cornerRadius = 50 / 2;
    currentLocation.backgroundColor = [UIColor whiteColor];
    currentLocation.titleLabel.font = [UIFont systemFontOfSize:12];
    currentLocation.titleLabel.textColor = [UIColor blackColor];
    [currentLocation setTitle:@"当前位置" forState:UIControlStateNormal];
    [currentLocation setTitle:@"当前位置" forState:UIControlStateHighlighted];
    [currentLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [currentLocation setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [currentLocation addTarget:self action:@selector(showCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:currentLocation];
    NSLayoutConstraint *currentLocationWidth = [NSLayoutConstraint constraintWithItem:currentLocation attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
    NSLayoutConstraint *currentLocationHeight = [NSLayoutConstraint constraintWithItem:currentLocation attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
    NSLayoutConstraint *currentLocationBottom = [NSLayoutConstraint constraintWithItem:currentLocation attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50];
    NSLayoutConstraint *currentLocationTrailing = [NSLayoutConstraint constraintWithItem:currentLocation attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-50];
    [self.view addConstraints:@[currentLocationWidth,currentLocationBottom,currentLocationHeight,currentLocationTrailing]];
}

#pragma mark init the var
-(void) initVar
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

#pragma mark show current location
-(void) showCurrentLocation:(id) sender
{
    NSLog(@"showCurrentLocation--->%@",sender);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initVar];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark location delegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate,1000 ,1000);
//    [mapView setRegion:region animated:YES];
    CLLocationCoordinate2D userLocation;
    CLLocationDegrees latitude = 115.25;
    CLLocationDegrees longtitude = 50.26;
    userLocation.latitude = latitude;
    userLocation.longitude = longtitude;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.subtitle = @"subtitle";
    annotation.title = @"title";
    [mapView showAnnotations:@[annotation] animated:YES];
}
@end
