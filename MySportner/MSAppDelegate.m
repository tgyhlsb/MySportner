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

#define STORYBOARD_NAME @"Main"

@interface MSAppDelegate()

@end

@implementation MSAppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [self setDrawerMenu];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MSWelcomeVC *mainVC = [MSWelcomeVC newcontroller];
    
    [self.window setRootViewController:mainVC];
    
    return YES;
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

@end
