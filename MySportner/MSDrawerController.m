//
//  MSDrawerController.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSDrawerController.h"
#import "MSProfileVC.h"
#import "MSActivitiesVC.h"
#import "MSNotificationsVC.h"
#import "MSSetAGameVC.h"

@interface MSDrawerController ()

@end

@implementation MSDrawerController

- (void)displayCenterControlerForView:(MSCenterView)view
{
    UIViewController *newCenterVC = nil;
    switch (view) {
        case MSCenterViewProfile:
        {
            newCenterVC = [MSProfileVC newController];
            break;
        }
        case MSCenterViewActivities:
        {
            newCenterVC = [MSActivitiesVC newController];
            break;
        }
        case MSCenterViewNotifications:
        {
            newCenterVC = [MSNotificationsVC newController];
            break;
        }
        case MSCenterViewSetAGame:
        {
            newCenterVC = [MSSetAGameVC newController];
            break;
        }
        case MSCenterViewSettings:
        {
            break;
        }
        case MSCenterViewFiendFriends:
        {
            break;
        }
            
        default:
            break;
    }
    
    if (newCenterVC)
    {
        [self setCenterViewController:newCenterVC withFullCloseAnimation:YES completion:nil];
    }
}

@end
