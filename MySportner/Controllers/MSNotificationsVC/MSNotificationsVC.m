//
//  MSNotificationsVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSNotificationsVC.h"

#define NIB_NAME @"MSNotificationsVC"

@interface MSNotificationsVC ()

@end

@implementation MSNotificationsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

+ (MSNotificationsVC *)newController
{
    return [[MSNotificationsVC alloc] initWithNibName:NIB_NAME bundle:nil];
}

@end
