//
//  MSActivitiesVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 22/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSActivitiesVC.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

#define NIB_NAME @"MSActivitiesVC"

@interface MSActivitiesVC ()

@end

@implementation MSActivitiesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

+ (MSActivitiesVC *)newController
{
    return [[MSActivitiesVC alloc] initWithNibName:NIB_NAME bundle:nil];
}

@end
