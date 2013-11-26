//
//  MSWelcomeVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSWelcomeVC.h"
#import "MSAppDelegate.h"
#import "MSUser.h"
#import "MSCreateAccountVC.h"
#import "MBProgressHUD.h"
#import "MZFormSheetController.h"
#import "MSLoginFormVC.h"


#define NIB_NAME @"MSWelcomeVC"

@interface MSWelcomeVC () <MSUserAuthentificationDelegate, MZFormSheetBackgroundWindowDelegate>

@property (strong, nonatomic) MBProgressHUD *loadingView;

@end

@implementation MSWelcomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([MSUser currentUser])
    {
        [self performLogin];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

+ (MSWelcomeVC *)newController
{
    return [[MSWelcomeVC alloc] initWithNibName:NIB_NAME bundle:nil];
}

- (void)performLogin
{
    [self hideLoadingView];
    MSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate setDrawerMenu];
    
    [self presentViewController:appDelegate.drawerController animated:YES completion:nil];
}

- (IBAction)logInWithFacebookButtonPress:(UIButton *)sender
{
    [self showLoadingViewInView:self.view];
    [MSUser tryLoginWithFacebook:self];
}

- (IBAction)signUpButtonPress:(UIButton *)sender
{
    [self.navigationController pushViewController:[MSCreateAccountVC newController] animated:YES];
}

- (IBAction)signInButtonPress:(UIButton *)sender
{
    
}
- (IBAction)showLoginFormSheet:(UIButton *)sender
{
    UIViewController *vc = [MSLoginFormVC newController];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.5;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVerticallyWhenKeyboardAppears = YES;
    formSheet.shouldCenterVertically = YES;
    //    formSheet.shouldMoveToTopWhenKeyboardAppears = NO;
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
    };
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

#pragma mark MSUserAuthentificationDelegate

- (void)userDidLogIn
{
    [self performLogin];
}

- (void)userDidSignUp:(MSUser *)user
{
    [self performLogin];
}

- (void)userSignUpDidFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"ERROR" message:[error description] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
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
