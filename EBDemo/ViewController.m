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
    currentLocation.backgroundColor = [UIColor greenColor];
    [currentLocation addTarget:self action:@selector(showCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:currentLocation];
    NSLayoutConstraint *currentLocationWidth = [NSLayoutConstraint constraintWithItem:currentLocation attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
    NSLayoutConstraint *currentLocationHeight = [NSLayoutConstraint constraintWithItem:currentLocation attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
    NSLayoutConstraint *currentLocationBottom = [NSLayoutConstraint constraintWithItem:currentLocation attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50];
    NSLayoutConstraint *currentLocationTrailing = [NSLayoutConstraint constraintWithItem:currentLocation attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-50];
    [self.view addConstraints:@[currentLocationWidth,currentLocationBottom,currentLocationHeight,currentLocationTrailing]];
}

#pragma mark show current location
-(void) showCurrentLocation:(id) sender
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
@end
