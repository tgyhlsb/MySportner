//
//  MSActivityVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSActivityVC.h"

#define NIB_NAME @"MSActivityVC"

@interface MSActivityVC ()

@end

@implementation MSActivityVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"GAME PROFILE";
}

+ (MSActivityVC *)newController
{
    MSActivityVC *activityVC = [[MSActivityVC alloc] initWithNibName:NIB_NAME bundle:nil];
    activityVC.hasDirectAccessToDrawer = NO;
    return activityVC;
}

@end
