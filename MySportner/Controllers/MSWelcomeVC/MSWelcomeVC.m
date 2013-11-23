//
//  MSWelcomeVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSWelcomeVC.h"
#import "MSAppDelegate.h"

#define NIB_NAME @"MSWelcomeVC"

@interface MSWelcomeVC ()

@end

@implementation MSWelcomeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    [self performLogin];
}
@end
