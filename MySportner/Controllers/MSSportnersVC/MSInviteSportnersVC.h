//
//  MSInviteSportnersVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSCenterController.h"
#import "MSActivity.h"

@interface MSInviteSportnersVC : MSCenterController

@property (strong, nonatomic) MSActivity *activity;

+ (MSInviteSportnersVC *)newControler;

@end
