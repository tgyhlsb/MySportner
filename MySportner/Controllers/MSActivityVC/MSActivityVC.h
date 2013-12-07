//
//  MSActivityVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCenterController.h"
#import "MSActivity.h"

@interface MSActivityVC : MSCenterController

@property (strong, nonatomic) MSActivity *activity;


+ (MSActivityVC *)newController;

@end
