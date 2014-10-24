//
//  MSNotificationCenter.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 21/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

static NSString *MSNotificationUserNotificationsFetched = @"MSNotificationUserNotificationsFetched";

static NSString *MSNotificationObservedObjectUpdated = @"MSNotificationObservedObjectUpdated";

@interface MSNotificationCenter : NSObject

+ (void)handleNotification:(NSDictionary *)userInfo;

+ (void)fetchUserNotifications;
+ (NSArray *)userNotifications;

+ (void)setObservedObject:(PFObject *)object;

@end
