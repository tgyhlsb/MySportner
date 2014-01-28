//
//  MSPickLocalisationVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 26/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSPickLocalisationVC.h"
#import "MSAnnotation.h"
#import "MSPinView.h"
#import "TKAlertCenter.h"

@interface MSPickLocalisationVC () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *locateUserButton;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBarView;
@property (strong, nonatomic) UIBarButtonItem *validateButton;

@property (strong, nonatomic) MSAnnotation *activityPin;
@property (strong, nonatomic) MSPinView *circleView;

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
    
    self.radiusSlider.maximumValue = 200;
    self.radiusSlider.minimumValue = 0;
    self.radiusSlider.value = 20;
    
    [self registerGestureRecognizers];
    [self addValidateButton];
}

- (void)addValidateButton
{
    self.validateButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(validateButtonHandler)];
    self.navigationItem.rightBarButtonItem = self.validateButton;
}

- (void)validateButtonHandler
{
    if ([self.delegate respondsToSelector:@selector(didPickLocalisation:withRadius:)]) {
        [self.delegate didPickLocalisation:self.activityPin.coordinate withRadius:self.activityPin.radius];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (MSAnnotation *)activityPin
{
    if (!_activityPin) {
        _activityPin = [[MSAnnotation alloc] init];
        _activityPin.coordinate = self.mapView.userLocation.coordinate;
        [self.mapView addAnnotation:_activityPin];
        [self updateRadiusOverlay];
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
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.activityPin.coordinate, [self mettersForSliderValue], 0);
    
    CGRect circle = [self.mapView convertRegion:region toRectToView:Nil];
    [self.circleView setSize:CGSizeMake(circle.size.height, circle.size.height)];
    [self.circleView setDistance:[self mettersForSliderValue]/2.0];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    [self updateRadiusOverlay];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Enable to locate your position"];
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    return circleView;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == self.mapView.userLocation) {
        return [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"user"];
    }
    self.circleView = (MSPinView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if (!self.circleView) {
        self.circleView = [[MSPinView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    }
    return self.circleView;
}

- (void)didTapMapView:(UITapGestureRecognizer *)tapGesture
{
    CGPoint pixelPosition = [tapGesture locationInView:self.mapView];
    self.activityPin.coordinate = [self.mapView convertPoint:pixelPosition toCoordinateFromView:self.mapView];
    
    [self updateRadiusOverlay];
}

@end
