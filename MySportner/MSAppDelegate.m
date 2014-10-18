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
    [Parse setApplicationId:@"mXxe3WBY2KqxbWjjnBruVUyJGtyKjgjDpfuX6pAA"
                  clientKey:@"EFLTeHfWnuHxmwzKbg1xfsfYRRFSksMiWGlKYloM"];
    
    [self registerForPushNotification:application];
    
    [PFFacebookUtils initializeFacebook];
    
    [self setDrawerMenu];
    [self setAppearance];
    
    [MSSport fetchAllSports];
    
    self.window = [[MSWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    MSNavigationVC *mainVC = [[MSNavigationVC alloc] initWithRootViewController:[MSWelcomeVC newController]];
    
    [self.window setRootViewController:mainVC];
    
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
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)setDrawerMenu
{
    MSDrawerMenuVC * leftSideDrawerViewController = [MSDrawerMenuVC newController];
    
    UIViewController * centerViewController = [MSActivitiesVC newController];
    
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    UIViewController *activeVC = ((UINavigationController *)self.window.rootViewController).topViewController;
    if ([activeVC isKindOfClass:[MSWelcomeVC class]]) {
        [((MSWelcomeVC *)activeVC) applicationIsBackFromBackground];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled = [PFFacebookUtils handleOpenURL:url];
    if (urlWasHandled) {
        UIViewController *activeVC = ((UINavigationController *)self.window.rootViewController).topViewController;
        if ([activeVC isKindOfClass:[MSWelcomeVC class]]) {
            ((MSWelcomeVC *)activeVC).shouldHideLoadingWhenAppOpens = NO;
            [((MSWelcomeVC *)activeVC) applicationIsBackFromBackground];
        }
    }
    
    return urlWasHandled;
}

@end
