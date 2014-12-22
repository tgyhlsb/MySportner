//
//  MSAppDelegate.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 22/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSDrawerController.h"

@interface MSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) MSDrawerController * drawerController;

- (void)setDrawerMenuWithOptions:(NSDictionary *)launchOptions;

@end
