//
//  MSFindFriendsVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSFindFriendsVC.h"
#import "MSAppDelegate.h"

#define NIB_NAME @"MSFindFriendsVC"

@interface MSFindFriendsVC ()

@end

@implementation MSFindFriendsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)performLogin
{
    MSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate setDrawerMenu];
    
    [self presentViewController:appDelegate.drawerController animated:YES completion:nil];
}

- (IBAction)validateButtonPress:(UIButton *)sender
{
    [self performLogin];
}

+ (MSFindFriendsVC *)newController
{
    return [[MSFindFriendsVC alloc] initWithNibName:NIB_NAME bundle:Nil];
}

@end
