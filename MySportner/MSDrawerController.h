//
//  MSDrawerController.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MMDrawerController.h"
#import "MSActivity.h"

typedef NS_ENUM(int, MSCenterView) {
    MSCenterViewProfile,
    MSCenterViewActivities,
    MSCenterViewNotifications,
    MSCenterViewSetAGame,
    MSCenterViewSettings,
    MSCenterViewFiendFriends
};

@interface MSDrawerController : MMDrawerController


- (void)setGestureRecognizerBlock;
- (void)displayCenterControlerForView:(MSCenterView)view;

- (void)openViewControllerForActivityId:(NSString *)activityId;
- (void)openViewControllerForMessagesWithActivityId:(NSString *)activityId;

@end
