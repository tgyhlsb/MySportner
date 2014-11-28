//
//  MSGameProfileVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSCenterController.h"
#import "MSActivity.h"

@interface MSGameProfileVC : MSCenterController

@property (strong, nonatomic) MSActivity *activity;
@property (strong, nonatomic) NSString *activityId;
@property (nonatomic) BOOL shouldPushToComments;

@end
