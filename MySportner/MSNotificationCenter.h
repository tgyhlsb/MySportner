//
//  MSNotificationCenter.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 21/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSNotificationCenter : NSObject

+ (void)registerApplication;
+ (void)handleNotification:(NSDictionary *)userInfo;

@end
