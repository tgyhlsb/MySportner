//
//  MSPickLocalisationVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 26/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MSCenterController.h"

@protocol MSPickLocalisationVCDelegate;

@interface MSPickLocalisationVC : MSCenterController

@property (weak, nonatomic) id <MSPickLocalisationVCDelegate> delegate;

+ (MSPickLocalisationVC *)newControler;

@end


@protocol MSPickLocalisationVCDelegate <NSObject>

- (void)didPickLocalisation:(CLLocationCoordinate2D)localisation withRadius:(CGFloat)radius placeInfo:(NSDictionary *)placeInfo;

@end
