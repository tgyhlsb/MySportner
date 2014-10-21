//
//  MSNotificationCenter.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 21/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSNotificationCenter.h"
#import <LNNotificationsUI/LNNotificationsUI.h>

#define APP_IDENTIFIER @"MySportner-X568"
#define APP_NAME @"MySportner"
#define APP_ICON @"icon120.png"

@implementation MSNotificationCenter

+ (void)registerApplication
{
    UIImage *appImage = [UIImage imageNamed:APP_ICON];
    [[LNNotificationCenter defaultCenter] registerApplicationWithIdentifier:APP_IDENTIFIER
                                                                       name:APP_NAME
                                                                       icon:appImage
                                                            defaultSettings:LNNotificationDefaultAppSettings];

}

+ (void)handleNotification:(NSDictionary *)userInfo
{
    LNNotification* notification = [LNNotification notificationWithTitle:@"Notif" message:@"Ca marche !"];
    
    [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:APP_IDENTIFIER];
}

@end
