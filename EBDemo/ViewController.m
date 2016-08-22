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
    UIButton *currentLocationBtn;
    CLLocationManager *locationManager;
    CLLocation *currentLotion;
}

#pragma mark init the view
-(void) initView
{
    self.view.backgroundColor = [UIColor yellowColor];
    mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    mapView.mapType = MKMapTypeStandard;
    [self.view addSubview:mapView];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.view addConstraints:@[width,height,centerX,centerY]];
    mapView.showsUserLocation = YES;
    
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
    
    currentLocationBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    currentLocationBtn.translatesAutoresizingMaskIntoConstraints = NO;
    currentLocationBtn.layer.cornerRadius = 50 / 2;
    currentLocationBtn.backgroundColor = [UIColor whiteColor];
    currentLocationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    currentLocationBtn.titleLabel.textColor = [UIColor blackColor];
    [currentLocationBtn setTitle:@"当前位置" forState:UIControlStateNormal];
    [currentLocationBtn setTitle:@"当前位置" forState:UIControlStateHighlighted];
    [currentLocationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [currentLocationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [currentLocationBtn addTarget:self action:@selector(showCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:currentLocationBtn];
    NSLayoutConstraint *currentLocationWidth = [NSLayoutConstraint constraintWithItem:currentLocationBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
    NSLayoutConstraint *currentLocationHeight = [NSLayoutConstraint constraintWithItem:currentLocationBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
    NSLayoutConstraint *currentLocationBottom = [NSLayoutConstraint constraintWithItem:currentLocationBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50];
    NSLayoutConstraint *currentLocationTrailing = [NSLayoutConstraint constraintWithItem:currentLocationBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-50];
    [self.view addConstraints:@[currentLocationWidth,currentLocationBottom,currentLocationHeight,currentLocationTrailing]];
}

#pragma mark init the var
-(void) initVar
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 1000.0f;
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

#pragma mark show current location
-(void) showCurrentLocation:(id) sender
{
    mapView.showsUserLocation = YES;
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
    [self getSearchResult:textField.text];
    return YES;
}

#pragma mark get the location info
-(void) getSearchResult:(NSString *) locationText
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *str = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=AIzaSyC6RiLj9o2Uv6DMThdyCkU597r9wVVilSc",locationText];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];
}

#pragma mark location delegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    currentLotion = newLocation;
    NSLog(@"current location is %@",currentLotion);
}
@end
