//
//  MSFindFriendsVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSFindFriendsVC.h"
#import "MSAppDelegate.h"
#import "MBProgressHUD.h"

#define NIB_NAME @"MSFindFriendsVC"

@interface MSFindFriendsVC ()

@property (strong, nonatomic) MBProgressHUD *loadingView;

@end

@implementation MSFindFriendsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"FIND FRIENDS";
}

- (void)performLogin
{
    MSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate setDrawerMenu];
    
    [self presentViewController:appDelegate.drawerController animated:YES completion:nil];
}

- (IBAction)validateButtonPress:(UIButton *)sender
{
    if (self.user) {
        [self showLoadingViewInView:self.view];
        [self.user signUpInBackgroundWithTarget:self selector:@selector(handleSignUp:error:)];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't sign up" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
    }
}
         

- (void)handleSignUp:(NSNumber *)result error:(NSError *)error
{
    [self hideLoadingView];
    if (!error) {
        [self performLogin];
    }
}

+ (MSFindFriendsVC *)newController
{
    return [[MSFindFriendsVC alloc] initWithNibName:NIB_NAME bundle:Nil];
}

#pragma mark - MBProgressHUD

- (void) showLoadingViewInView:(UIView*)v
{
    UIView *targetV = (v ? v : self.view);
    
    if (!self.loadingView) {
        self.loadingView = [[MBProgressHUD alloc] initWithView:targetV];
        self.loadingView.minShowTime = 1.0f;
        self.loadingView.mode = MBProgressHUDModeIndeterminate;
        self.loadingView.removeFromSuperViewOnHide = YES;
        self.loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    }
    if(!self.loadingView.superview) {
        self.loadingView.frame = targetV.bounds;
        [targetV addSubview:self.loadingView];
    }
    [self.loadingView show:YES];
}
- (void) hideLoadingView
{
    if (self.loadingView.superview)
        [self.loadingView hide:YES];
}

@end
