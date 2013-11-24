//
//  MSWelcomeVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSWelcomeVC.h"
#import "MSAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MSUser.h"

#define NIB_NAME @"MSWelcomeVC"

@interface MSWelcomeVC ()

@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginview;

@end

@implementation MSWelcomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.fbLoginview setReadPermissions:FACEBOOK_READ_PERMISIONS];
//    self.fbLoginview.delegate = [MSUser sharedUser];
}

+ (MSWelcomeVC *)newcontroller
{
    return [[MSWelcomeVC alloc] initWithNibName:NIB_NAME bundle:nil];
}

- (void)performLogin
{
    MSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    [appDelegate setDrawerMenu];
    
    appDelegate.drawerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:appDelegate.drawerController animated:YES completion:nil];
}

- (IBAction)loginButtonPress:(UIButton *)sender
{
    [MSUser tryLoginWithFacebook];
//    [self performLogin];
}


@end
