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
#import "MSChooseSportsVC.h"
#import "QBFlatButton.h"
#import "MSColorFactory.h"
#import "MSFontFactory.h"
#import "TKAlertCenter.h"
#import "MSFindFriendsVC.h"

#define NIB_NAME @"MSWelcomeVC"

@interface MSWelcomeVC () <MSUserAuthentificationDelegate, MZFormSheetBackgroundWindowDelegate>

@property (strong, nonatomic) MBProgressHUD *loadingView;
@property (weak, nonatomic) IBOutlet QBFlatButton *facebookLoginButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *createAccountButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *loginButton;

@end

@implementation MSWelcomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.facebookLoginButton setTitle:@"CONNECT VIA FACEBOOK" forState:UIControlStateNormal];
    [self.createAccountButton setTitle:@"CREATE ACCOUNT" forState:UIControlStateNormal];
    [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    
    [self setButtonsAppearance];
    
    self.view.backgroundColor = [MSColorFactory mainColor];
    
    if ([MSUser currentUser])
    {
//        [MSUser currentUser] 
        [self performLogin];
    }
}

- (void)setButtonsAppearance
{
    self.facebookLoginButton.faceColor = [MSColorFactory facebookColorLight];
    self.facebookLoginButton.sideColor = [MSColorFactory facebookColorDark];
    self.facebookLoginButton.titleLabel.font = [MSFontFactory fontForButtonLight];
    
    self.createAccountButton.faceColor = [MSColorFactory whiteLight];
    self.createAccountButton.sideColor = [MSColorFactory whiteDark];
    self.createAccountButton.titleLabel.font = [MSFontFactory fontForButtonLight];
    [self.createAccountButton setTitleColor:[MSColorFactory mainColor] forState:UIControlStateNormal];
    
    self.loginButton.faceColor = [MSColorFactory whiteLight];
    self.loginButton.sideColor = [MSColorFactory whiteDark];
    self.loginButton.titleLabel.font = [MSFontFactory fontForButtonLight];
    [self.loginButton setTitleColor:[MSColorFactory mainColor] forState:UIControlStateNormal];
    
    
    // removes title from pushed VC
    UIBarButtonItem *emptyBackButton = [[UIBarButtonItem alloc] initWithTitle: @"" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: emptyBackButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    NSLog(@"TODO, find a way not to do this hsit.");
    [[MSSportner currentSportner] fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self hideLoadingView];
        if ([MSSportner currentSportner].sportLevels) {
            MSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            
            [appDelegate setDrawerMenu];
            
            [self presentViewController:appDelegate.drawerController animated:YES completion:nil];
        } else {
            [self redirectToSportchooser];
        }
    }];

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

- (void)applicationIsBackFromBackground
{
    [self hideLoadingView];
}

- (IBAction)showLoginFormSheet:(UIButton *)sender
{
    UIViewController *vc = [MSLoginFormVC newController];
    CGSize formSheetSize = CGSizeMake(280, 300);
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:formSheetSize viewController:vc];
//    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    formSheet.shadowRadius = 1.0;
    formSheet.shadowOpacity = 0.2;
    formSheet.cornerRadius = 3.0;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVerticallyWhenKeyboardAppears = YES;
    formSheet.shouldCenterVertically = YES;
    
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
    [self redirectToSportchooser];
}

- (void)redirectToSportchooser
{
    MSChooseSportsVC *destinationVC = [MSChooseSportsVC newController];
    
    destinationVC.sportner = [MSSportner currentSportner];
    
    __weak MSChooseSportsVC *weakDestination = destinationVC;
    destinationVC.validateBlock = ^{
        MSFindFriendsVC *destinationVC = [MSFindFriendsVC newController];
        
        destinationVC.sportner = weakDestination.sportner;
        
        [weakDestination.navigationController pushViewController:destinationVC animated:YES];
    };
    
    [self hideLoadingView];
    [self.navigationController pushViewController:destinationVC animated:YES];
}

- (void)userSignUpDidFailWithError:(NSError *)error
{
//    [[[UIAlertView alloc] initWithTitle:@"ERROR" message:[error description] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:[error.userInfo objectForKey:@"error"]];
    
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
