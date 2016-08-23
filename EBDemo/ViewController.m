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
    UITableView *autoCompleteTableView;
    NSMutableArray *predictions;
    NSUInteger selectedIndex;
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
    mapView.zoomEnabled = YES;
    
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
    [currentLocationBtn setTitle:@"当前" forState:UIControlStateNormal];
    [currentLocationBtn setTitle:@"当前" forState:UIControlStateHighlighted];
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
    predictions = [NSMutableArray array];
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
    [textField resignFirstResponder];
    [self getSearchResult:textField.text];
    return YES;
}

#pragma mark get the location info
-(void) getSearchResult:(NSString *) locationText
{
    NSString *autoCompleteApi = @"https://maps.googleapis.com/maps/api/place/autocomplete/json?types=geocode&key=AIzaSyC3_TyXqumwHJ3sLlLHoRAab7A87eKF_C8";
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    autoCompleteApi = [autoCompleteApi stringByAppendingFormat:@"&input=%@",locationText];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    autoCompleteApi = [autoCompleteApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:autoCompleteApi];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *status = [responseObject valueForKey:@"status"];
                if ([status isEqualToString:@"OK"]) {
                    [predictions removeAllObjects];
                    NSArray *localPredictions = [responseObject objectForKey:@"predictions"];
                    [predictions addObjectsFromArray:localPredictions];
                    autoCompleteTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                    autoCompleteTableView.translatesAutoresizingMaskIntoConstraints = NO;
                    autoCompleteTableView.delegate = self;
                    autoCompleteTableView.dataSource = self;
                    [self.view addSubview:autoCompleteTableView];
                    NSLayoutConstraint *autoCompleteTableViewTop = [NSLayoutConstraint constraintWithItem:autoCompleteTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:searchField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
                    NSLayoutConstraint *autoCompleteTableViewLeading = [NSLayoutConstraint constraintWithItem:autoCompleteTableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:searchField attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
                    NSLayoutConstraint *autoCompleteTableViewWidth = [NSLayoutConstraint constraintWithItem:autoCompleteTableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:searchField attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
                    NSLayoutConstraint *autoCompleteTableViewHeight = [NSLayoutConstraint constraintWithItem:autoCompleteTableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
                    [self.view addConstraints:@[autoCompleteTableViewTop,autoCompleteTableViewLeading,autoCompleteTableViewWidth,autoCompleteTableViewHeight]];
                }
            }
        }
    }];
    [dataTask resume];
}

#pragma mark table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return predictions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    NSDictionary *dict = [predictions objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict valueForKey:@"description"];
    return cell;
}

#pragma mark table view delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    searchField.text = selectedCell.textLabel.text;
    [tableView removeFromSuperview];
    selectedIndex = indexPath.row;
    NSDictionary *dict = [predictions objectAtIndex:selectedIndex];
    NSString *place_id = [dict valueForKey:@"place_id"];
    [self getPlaceDetail:place_id];
}

#pragma mark get place detail
-(void) getPlaceDetail:(NSString *)place_id {
    NSString *locationDetailApi = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyC3_TyXqumwHJ3sLlLHoRAab7A87eKF_C8&placeid=%@",place_id];
    ;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:locationDetailApi];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask * dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error is %@",error);
        } else {
            NSLog(@"%@",responseObject);
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
}
@end
