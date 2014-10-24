//
//  MSNotificationCenter.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 21/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "MSActivity.h"


typedef NS_ENUM(int, MSObservedActivityScreen) {
    MSObservedActivityScreenProfile,
    MSObservedActivityScreenAttendees,
    MSObservedActivityScreenInvitation,
    MSObservedActivityScreenComments
};

static NSString *MSNotificationUserNotificationsFetched = @"MSNotificationUserNotificationsFetched";
static NSString *MSNotificationObservedActivityNeedsUpdate = @"MSNotificationObservedActivityNeedsUpdate";

@interface MSNotificationCenter : NSObject

+ (void)handleNotification:(NSDictionary *)userInfo;

+ (void)fetchUserNotifications;
+ (NSArray *)userNotifications;

+ (void)setObservedActivity:(MSActivity *)activity onScreen:(MSObservedActivityScreen)screen;


+ (void)setStatusBarWithTitle:(NSString *)title;
+ (void)dismissStatusBarNotification;

@end
