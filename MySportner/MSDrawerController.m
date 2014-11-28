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
#import "MSSetAGameVC2.h"
#import "MSFindFriendsVC.h"
#import "MSAppDelegate.h"
#import "MSVerifyAccountVC.h"
#import "MSUser.h"
#import "MSFacebookManager.h"
#import "MSNavigationVC.h"
#import "MSGameProfileVC.h"
#import "MSMessageVC.h"

@interface MSDrawerController ()

@end

@implementation MSDrawerController

- (void)setGestureRecognizerBlock
{
    self.openDrawerGestureModeMask = MMOpenDrawerGestureModeCustom;
    self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    [self setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
        
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            UIViewController *activeVC = [((UINavigationController *)drawerController.centerViewController).viewControllers lastObject];
            
            // find view touched if setting a game
            if ([activeVC respondsToSelector:@selector(shouldCancelTouch:)]) {
                
                return ![((MSCenterController *)activeVC) shouldCancelTouch:touch];
            }
            
            return YES;
        }
        return NO;
    }];
}

- (void)displayCenterControlerForView:(MSCenterView)view
{
    MSCenterController *newCenterVC = nil;
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
            newCenterVC = [MSSetAGameVC2 newController];
            break;
        }
        case MSCenterViewSettings:
        {
            newCenterVC = [MSVerifyAccountVC newController];
            ((MSVerifyAccountVC *)newCenterVC).user = [MSUser currentUser];
            ((MSVerifyAccountVC *)newCenterVC).state = MSVerifyAccountUserStateExisting;
            newCenterVC.hasDirectAccessToDrawer = YES;
            break;
        }
        case MSCenterViewFiendFriends:
        {
            [MSFacebookManager shareInviteFriends];
            break;
        }
            
        default:
            break;
    }
    
    [self presentCenterViewController:newCenterVC animated:YES];
}

- (void)presentCenterViewController:(MSCenterController *)destination animated:(BOOL)animated
{
    if (destination) {
        MSCenterController *actualCenter = (MSCenterController *)self.centerViewController;
        if ([actualCenter isKindOfClass:[UINavigationController class]]) {
            actualCenter = (MSCenterController *)((UINavigationController *)actualCenter).topViewController;
        }
        
        if ([actualCenter isEqual:destination])
        {
            [self closeDrawerAnimated:YES completion:nil];
        }
        else
        {
            MSNavigationVC *navigationController = [[MSNavigationVC alloc] initWithRootViewController:destination];
            destination.hasDirectAccessToDrawer = YES;
            
            if (animated) {
                [self setCenterViewController:navigationController withFullCloseAnimation:YES completion:^(BOOL finished) {
                    
                }];
            } else {
                [self setCenterViewController:navigationController];
            }
        }
    }
}

- (void)openViewControllerForActivityId:(NSString *)activityId
{
    MSGameProfileVC *destination = [MSGameProfileVC newController];
    destination.activityId = activityId;
    [self presentCenterViewController:destination animated:NO];
}

- (void)openViewControllerForMessagesWithActivityId:(NSString *)activityId
{
    MSGameProfileVC *destination = [MSGameProfileVC newController];
    destination.activityId = activityId;
    destination.shouldPushToComments = YES;
    [self presentCenterViewController:destination animated:NO];
}

@end
