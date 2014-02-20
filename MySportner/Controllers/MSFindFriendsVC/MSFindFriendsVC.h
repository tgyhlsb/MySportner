//
//  MSFindFriendsVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSportner.h"
#import "MSCenterController.h"

@interface MSFindFriendsVC : MSCenterController

@property (strong, nonatomic) MSSportner *sportner;

+ (MSFindFriendsVC *)newController;

@end
