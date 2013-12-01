//
//  MSLocationPickerCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSLocationPickerCell.h"
#import "MSLocationPickerVC.h"

#define IDENTIFIER @"MSLocationPickerCell"

@interface MSLocationPickerCell() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocation *location;

@end

@implementation MSLocationPickerCell

+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSLocationPickerCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

- (void)setVenue:(MSVenue *)venue
{
    _venue = venue;
    if (venue)
    {
        self.textField.text = venue.name;
    }
    else
    {
        self.textField.text = @"";
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self startLocationPickerProcess];
    return NO;
}

- (void)startLocationPickerProcess
{
    __weak MSLocationPickerCell *weakSelf = self;
    
    MSLocationPickerVC *modalVC = [[MSLocationPickerVC alloc] init];
    __weak MSLocationPickerVC *weakModalVC = modalVC;
    
    modalVC.closeBlock = ^{
        weakSelf.venue = weakModalVC.selectedVenue;
        [weakModalVC dismissViewControllerAnimated:YES completion:nil];
    };
    
    modalVC.location = self.location;
    [self.viewController presentViewController:modalVC animated:YES completion:nil];
}


- (void)initializeLocation
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager startUpdatingLocation];
    self.location = [locationManager location];
}



#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];
    [manager stopUpdatingLocation];
}

@end
