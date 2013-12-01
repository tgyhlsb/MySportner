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
#import "MSUser.h"
#import "MSActivity.h"
#import "MSColorFactory.h"
#import "MSFontFactory.h"
#import "MSTextField.h"

#define STORYBOARD_NAME @"Main"

@interface MSAppDelegate()

@end

@implementation MSAppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBLoginView class];
    [FBProfilePictureView class];
    
    [MSUser registerSubclass];
    [MSActivity registerSubclass];
    [Parse setApplicationId:@"mXxe3WBY2KqxbWjjnBruVUyJGtyKjgjDpfuX6pAA"
                  clientKey:@"EFLTeHfWnuHxmwzKbg1xfsfYRRFSksMiWGlKYloM"];
    
    [PFFacebookUtils initializeFacebook];
    
    [self setDrawerMenu];
    [self setAppearance];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    UINavigationController *mainVC = [[UINavigationController alloc] initWithRootViewController:[MSWelcomeVC newController]];
    
    [self.window setRootViewController:mainVC];
    
    return YES;
}

- (void)setAppearance
{
    NSShadow *titleShadow = [[NSShadow alloc] init];
    titleShadow.shadowColor = [UIColor grayColor];
    titleShadow.shadowOffset = CGSizeMake(0.5, 0.5);
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[MSColorFactory whiteLight],
                                                NSShadowAttributeName:titleShadow};
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[MSColorFactory whiteLight]];
//    [[UINavigationBar appearance] setBackgroundColor:[MSColorFactory mainColor]];
    [[UINavigationBar appearance] setBarTintColor:[MSColorFactory mainColor]];
    
    [[MSTextField appearance] setFont:[MSFontFactory fontForFormTextField]];
    
    
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
    
    [self.drawerController setRestorationIdentifier:@"MSDrawer"];
    [self.drawerController setMaximumRightDrawerWidth:200.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

@end
