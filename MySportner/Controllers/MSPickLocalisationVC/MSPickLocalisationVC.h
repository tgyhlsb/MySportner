//
//  MSPickLocalisationVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 26/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCenterController.h"

@protocol MSPickLocalisationVCDelegate;

@interface MSPickLocalisationVC : MSCenterController

@property (weak, nonatomic) id <MSPickLocalisationVCDelegate> delegate;

+ (MSPickLocalisationVC *)newControler;

@end


@protocol MSPickLocalisationVCDelegate <NSObject>

- (void)didPickLocalisation:(CGPoint)localisation withRadius:(CGFloat)radius;

@end
