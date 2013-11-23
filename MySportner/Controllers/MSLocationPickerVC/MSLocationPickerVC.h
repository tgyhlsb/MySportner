//
//  MSLocationPickerVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MSLocationPickerVC : UIViewController

+ (MSLocationPickerVC *)newController;

+ (void)presentFromViewController:(UIViewController *)viewController;

@end
