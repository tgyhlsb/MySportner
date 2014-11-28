//
//  MSNotificationCenter.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 21/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSNotificationCenter.h"

#import "CRToast.h"
#import "UIImage+resize.h"
#import "MSColorFactory.h"

#import "MSSportner.h"
#import "MSActivity.h"
#import "MSNotification.h"

#import "MSAppDelegate.h"
#import "MSDrawerController.h"

static NSArray *userNotifications;

static PFObject *observedActivity;
static MSObservedActivityScreen observedActivityScreen;

static NSDictionary *displayedNotification;

static BOOL isNotificationDisplayedOnStatusBar;
static BOOL shouldDisplayNotificationOnStatusBar;

@implementation MSNotificationCenter

+ (NSArray *)userNotifications
{
    return userNotifications;
}

+ (void)fetchUserNotifications
{
    PFQuery *query = [PFQuery queryWithClassName:@"MSNotification"];
    [query includeKey:@"sportner"];
    [query includeKey:@"activity"];
    [query includeKey:@"activity.sport"];
    [query includeKey:@"target"];
    [query orderByDescending:@"createdAt"];
    [query setLimit:30];
    [query whereKey:@"target" equalTo:[MSSportner currentSportner]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            userNotifications = objects;
            [self notifyUserNotificationsFetched];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

+ (void)notifyUserNotificationsFetched
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MSNotificationUserNotificationsFetched
                                                        object:nil
                                                      userInfo:nil];
}

#pragma mark - Observed Object

+ (void)setObservedActivity:(MSActivity *)activity onScreen:(MSObservedActivityScreen)screen
{
    observedActivity = activity;
    observedActivityScreen = screen;
}

+ (void)notifyObservedActivityNeedsUpdate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MSNotificationObservedActivityNeedsUpdate
                                                        object:nil
                                                      userInfo:nil];
}


#pragma mark - Push Notifications

+ (void)handleNotification:(NSDictionary *)userInfo
{
    [self fetchUserNotifications];
    
    NSString *activityId = [[userInfo objectForKey:@"activity"] objectForKey:@"objectId"];
    if ([activityId isEqualToString:observedActivity.objectId]) {
        [self notifyObservedActivityNeedsUpdate];
        
        if (observedActivityScreen != MSObservedActivityScreenComments) {
            [self showInAppPushNotification:userInfo];
        }
    } else {
        [self showInAppPushNotification:userInfo];
    }
}

+ (void)showInAppPushNotification:(NSDictionary *)userInfo
{
    NSString *title = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *imageName = [userInfo objectForKey:@"imageName"];
    
    if (!imageName) {
        imageName = @"Icon120.png";
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(30, 30)];
    
    NSMutableDictionary *options = [[MSNotificationCenter options] mutableCopy];
    
    if (title) {
        [options setObject:title forKey:kCRToastTextKey];
    }
    
    if (image) {
        [options setObject:image forKey:kCRToastImageKey];
    }
    
    displayedNotification = userInfo;
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                }];
}

+ (NSDictionary *)options
{
    CRToastInteractionResponder *responder = [CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                                             automaticallyDismiss:YES
                                                                                                            block:^(CRToastInteractionType interactionType){
                                                                                                                [MSNotificationCenter handleNotificationTap:interactionType];
                                                                                                            }];
    NSDictionary *options = @{
                              kCRToastAnimationInDirectionKey: @0,
                              kCRToastAnimationInTypeKey: @0,
                              kCRToastAnimationOutDirectionKey: @0,
                              kCRToastAnimationOutTypeKey: @0,
                              kCRToastInteractionRespondersKey: @[responder],
                              kCRToastNotificationPresentationTypeKey: @0,
                              kCRToastNotificationTypeKey: @1,
                              kCRToastSubtitleTextAlignmentKey: @0,
                              kCRToastTextAlignmentKey: @0,
                              kCRToastUnderStatusBarKey: @NO,
                              kCRToastBackgroundColorKey: [UIColor colorWithWhite:0 alpha:0.8],
                              kCRToastTextColorKey: [UIColor whiteColor],
                              kCRToastTimeIntervalKey: @3
                              };
    
    
    return options;
}

+ (void)handleNotificationTap:(CRToastInteractionType)interactionType
{
    
    NSString *activityId = [[displayedNotification objectForKey:@"activity"] objectForKey:@"objectId"];
    NSString *notificationType = [displayedNotification objectForKey:@"type"];
    
    MSAppDelegate *appDelegate = (MSAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([notificationType isEqualToString:MSNotificationTypeComment]) {
        [appDelegate.drawerController openViewControllerForMessagesWithActivityId:activityId];
    } else {
        [appDelegate.drawerController openViewControllerForActivityId:activityId];
    }
}

+ (void)setStatusBarWithTitle:(NSString *)title
{
    if (isNotificationDisplayedOnStatusBar) {
        [self dismissStatusBarNotification];
    }
    
    shouldDisplayNotificationOnStatusBar = YES;
    
    NSMutableDictionary *options = [[MSNotificationCenter optionsForStatusBarText] mutableCopy];
    [options setObject:title forKey:kCRToastTextKey];
    
    [CRToastManager showNotificationWithOptions:options
                                 apperanceBlock:^{
                                     isNotificationDisplayedOnStatusBar = YES;
                                     //Auto dismiss if notification no more need when it appears on screen
                                     if (!shouldDisplayNotificationOnStatusBar) {
                                         [CRToastManager dismissNotification:YES];
                                     }
                                     
                                 } completionBlock:^{
                                     isNotificationDisplayedOnStatusBar = NO;
                                 }];
}

+ (void)dismissStatusBarNotification
{
    if (shouldDisplayNotificationOnStatusBar && isNotificationDisplayedOnStatusBar) {
        [CRToastManager dismissNotification:YES];
    }
    shouldDisplayNotificationOnStatusBar = NO;
}

+ (NSDictionary *)optionsForStatusBarText
{
    
    NSDictionary *options = @{
                              kCRToastAnimationInDirectionKey: @0,
                              kCRToastAnimationInTypeKey: @0,
                              kCRToastAnimationOutDirectionKey: @0,
                              kCRToastAnimationOutTypeKey: @0,
                              kCRToastInteractionRespondersKey: @[],
                              kCRToastNotificationPresentationTypeKey: @1,
                              kCRToastNotificationTypeKey: @0,
                              kCRToastSubtitleTextAlignmentKey: @1,
                              kCRToastTextAlignmentKey: @1,
                              kCRToastUnderStatusBarKey: @NO,
                              kCRToastBackgroundColorKey: [MSColorFactory mainColor],
                              kCRToastTextColorKey: [UIColor whiteColor],
                              kCRToastTimeIntervalKey: @(DBL_MAX)
                              };
    return options;
}

@end
