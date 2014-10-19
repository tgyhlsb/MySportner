//
//  MSAttendeesListVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSAttendeesListVC.h"

#define NIB_NAME @"MSAttendeesListVC"

@interface MSAttendeesListVC ()

@end

@implementation MSAttendeesListVC

+ (instancetype)newController
{
    MSAttendeesListVC *controller = [[MSAttendeesListVC alloc] initWithNibName:NIB_NAME bundle:nil];
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
