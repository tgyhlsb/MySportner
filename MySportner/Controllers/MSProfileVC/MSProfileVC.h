//
//  MSProfileVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 22/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCenterController.h"
#import "MSSportner.h"

@interface MSProfileVC : MSCenterController

@property (strong, nonatomic) MSSportner *sportner;

+ (MSProfileVC *)newController;

@end
