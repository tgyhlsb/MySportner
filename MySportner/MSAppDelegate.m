//
//  MSAppDelegate.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 22/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSAppDelegate.h"
#import "MMDrawerVisualState.h"
#import "MSNavigationVC.h"
#import "MSDrawerMenuVC.h"
#import "MSActivitiesVC.h"
#import "MSWelcomeVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "MSUser.h"
#import "MSActivity.h"
#import "MSColorFactory.h"
#import "MSFontFactory.h"
#import "MSTextField.h"
#import "QBFlatButton.h"
#import "MSNavigationVC.h"
#import "MSComment.h"
#import "MSSportner.h"
#import "MSSport.h"
#import "MSNotificationCenter.h"
#import "MSNotification.h"
#import "MSGameProfileVC.h"

#import "MSWindow.h"

#define STORYBOARD_NAME @"Main"

@interface MSAppDelegate()

@end

@implementation MSAppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBLoginView class];
    [FBProfilePictureView class];
    
    [MSComment registerSubclass];
    [MSUser registerSubclass];
    [MSActivity registerSubclass];
    [MSSportner registerSubclass];
    [MSSport registerSubclass];
    [MSNotification registerSubclass];
    
    [Parse setApplicationId:@"mXxe3WBY2KqxbWjjnBruVUyJGtyKjgjDpfuX6pAA"
                  clientKey:@"EFLTeHfWnuHxmwzKbg1xfsfYRRFSksMiWGlKYloM"];
    [MSSport fetchAllSports];
    [PFFacebookUtils initializeFacebook];
    
    [self registerForPushNotification:application];
    [self setAppearance];
    
    [MSSport fetchAllSports];
    
    self.window = [[MSWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MSWelcomeVC *rootVC = [MSWelcomeVC newController];
    rootVC.shouldAutoLoginWithFacebook = YES;
    rootVC.launchOptions = launchOptions;
    MSNavigationVC *mainVC = [[MSNavigationVC alloc] initWithRootViewController:rootVC];
    
    [self.window setRootViewController:mainVC];
    
    // Reset badge 
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
//    [self checkFontsName];
    
    return YES;
}

- (void)setAppearance
{
    
    [[MSTextField appearance] setFont:[MSFontFactory fontForFormTextField]];
}

- (void)checkFontsName
{
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

- (void)registerForPushNotification:(UIApplication *)application
{
    // Register for Push Notitications, if running iOS 8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [MSNotificationCenter handleNotification:userInfo];
}

- (void)setDrawerMenuWithOptions:(NSDictionary *)launchOptions
{
    MSDrawerMenuVC * leftSideDrawerViewController = [MSDrawerMenuVC newController];
    
    MSGameProfileVC *invitationVC = nil;
    if (launchOptions) {
        
        NSDictionary *notificationInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (notificationInfo) {
            NSString *activityId = [[notificationInfo objectForKey:@"activity"] objectForKey:@"objectId"];
            NSString *notificationType = [notificationInfo objectForKey:@"type"];
            
            if ([notificationType isEqualToString:MSNotificationTypeComment]) {
                invitationVC = [MSGameProfileVC newController];
                invitationVC.activityId = activityId;
                invitationVC.hasDirectAccessToDrawer = YES;
                invitationVC.shouldPushToComments = YES;
            } else {
                invitationVC = [MSGameProfileVC newController];
                invitationVC.activityId = activityId;
                invitationVC.hasDirectAccessToDrawer = YES;
                invitationVC.shouldPushToComments = NO;
            }
        }
    }
    
    UIViewController * centerViewController = invitationVC ? invitationVC : [MSActivitiesVC newController];
    
    UIViewController * rightSideDrawerViewController = nil;
    
    UINavigationController * navigationController = [[MSNavigationVC alloc] initWithRootViewController:centerViewController];
    //[navigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
    
    self.drawerController = [[MSDrawerController alloc]
                             initWithCenterViewController:navigationController
                             leftDrawerViewController:leftSideDrawerViewController
                             rightDrawerViewController:rightSideDrawerViewController];
    [self.drawerController setGestureRecognizerBlock];
    [self.drawerController setRestorationIdentifier:@"MSDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:260.0];
    [self.drawerController setShowsShadow:YES];
    self.drawerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

@end
