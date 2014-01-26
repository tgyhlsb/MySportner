//
//  MSPickLocalisationVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 26/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSPickLocalisationVC.h"
#import <MapKit/MapKit.h>
#import "MSAnnotation.h"

@interface MSPickLocalisationVC () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *locateUserButton;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBarView;

@property (strong, nonatomic) MKCircle *radiusCircle;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) MSAnnotation *activityPin;

@property (strong, nonatomic) MKCircleView *circleViewBuffer;

@end

@implementation MSPickLocalisationVC

+ (MSPickLocalisationVC *)newControler
{
    return [[MSPickLocalisationVC alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"PICK A PLACE";
    
    self.mapView.delegate = self;
    
    self.radiusSlider.maximumValue = 100;
    self.radiusSlider.minimumValue = 0;
    self.radiusSlider.value = 20;
    
    [self registerGestureRecognizers];
}

- (void)registerGestureRecognizers
{
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] init];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self.mapView addGestureRecognizer:doubleTapGesture];
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMapView:)];
    [singleTapGesture setNumberOfTapsRequired:1];
    [singleTapGesture setNumberOfTouchesRequired:1];
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [self.mapView addGestureRecognizer:singleTapGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    return _locationManager;
}

- (MSAnnotation *)activityPin
{
    if (!_activityPin) {
        _activityPin = [[MSAnnotation alloc] init];
        _activityPin.coordinate = self.mapView.userLocation.coordinate;
        [self.mapView addAnnotation:_activityPin];
    }
    return _activityPin;
}

- (IBAction)locateUserButtonHandler:(id)sender
{
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

#pragma mark - MSCenterViewControler

- (BOOL)shouldCancelTouch:(UITouch *)touch
{
    CGPoint touchLocation = [touch locationInView:self.view];
    
    return CGRectContainsPoint(self.mapView.frame, touchLocation) || CGRectContainsPoint(self.toolBarView.frame, touchLocation);
}

#pragma mark - RadiusSlider

- (CGFloat)mettersForSliderValue
{
    return pow(self.radiusSlider.value, 2.0);
}

- (IBAction)radiusValueDidChange:(UISlider *)sender
{
    [self updateRadiusOverlay];
}

- (void)updateRadiusOverlay
{
    [self.mapView removeOverlay:self.radiusCircle];
    self.radiusCircle = [MKCircle circleWithCenterCoordinate:self.activityPin.coordinate radius:[self mettersForSliderValue]];
    [self.mapView addOverlay:self.radiusCircle];
}


#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    
    if (!_activityPin) {
        [self updateRadiusOverlay];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    return circleView;
}

//- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
//{
//    MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
//    circleView.strokeColor = [UIColor redColor];
//    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
//    return circleView;
//}

- (void)didTapMapView:(UITapGestureRecognizer *)tapGesture
{
    CGPoint pixelPosition = [tapGesture locationInView:self.mapView];
    self.activityPin.coordinate = [self.mapView convertPoint:pixelPosition toCoordinateFromView:self.mapView];
    
    [self updateRadiusOverlay];
}

@end
