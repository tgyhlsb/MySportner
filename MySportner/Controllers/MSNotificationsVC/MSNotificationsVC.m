//
//  MSNotificationsVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSNotificationsVC.h"
#import "MSNotification.h"
#import "MSNotificationCenter.h"

#define NIB_NAME @"MSNotificationsVC"

@interface MSNotificationsVC ()

@end

@implementation MSNotificationsVC

+ (MSNotificationsVC *)newController
{
    MSNotificationsVC *notificationsVC = [[MSNotificationsVC alloc] initWithNibName:NIB_NAME bundle:nil];
    notificationsVC.hasDirectAccessToDrawer = YES;
    return notificationsVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MSNotificationCenter fetchUserNotifications];
}

@end
