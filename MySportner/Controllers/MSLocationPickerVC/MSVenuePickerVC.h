//
//  MSLocationPickerVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MSVenue.h"

@interface MSVenuePickerVC : UIViewController

@property (nonatomic, strong) void (^closeBlock)(void);
@property (strong, nonatomic) MSVenue *selectedVenue;
@property (strong, nonatomic) CLLocation *location;

+ (MSVenuePickerVC *)newController;

+ (void)presentFromViewController:(UIViewController *)viewController;

@end
