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
#import "MSVerifyAccountVC.h"
#import "MBProgressHUD.h"
#import "MZFormSheetController.h"
#import "MSLoginFormVC.h"
#import "MSChooseSportsVC.h"
#import "QBFlatButton.h"
#import "MSColorFactory.h"
#import "MSFontFactory.h"
#import "TKAlertCenter.h"
#import "MSFindFriendsVC.h"
#import "MSFacebookManager.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

#define NIB_NAME @"MSWelcomeVC"

@interface MSWelcomeVC () <MSUserAuthentificationDelegate, MZFormSheetBackgroundWindowDelegate>

@property (strong, nonatomic) MBProgressHUD *loadingView;
@property (weak, nonatomic) IBOutlet QBFlatButton *facebookLoginButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *createAccountButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *facebookIconView;

@end

@implementation MSWelcomeVC

- (void)viewDidLoad
{
    self.shouldHideLoadingWhenAppOpens = YES;
    [super viewDidLoad];
    
    [self.facebookLoginButton setTitle:@"Login via facebook" forState:UIControlStateNormal];
    [self.createAccountButton setTitle:@"CREATE ACCOUNT" forState:UIControlStateNormal];
    [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    
    self.createAccountButton.hidden = YES;
    self.loginButton.hidden = YES;
    self.facebookLoginButton.alpha = 0.0;
    self.facebookIconView.alpha = 0.0;
    
    [self setButtonsAppearance];
    
    self.view.backgroundColor = [MSColorFactory mainColor];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Splashscreen0.png"]];
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
    
    if (self.shouldAutoLoginWithFacebook) {
        [self tryAutoLoginWithFacebook];
        self.shouldAutoLoginWithFacebook = NO;
    } else {
        [self setButtonsVisible:YES];
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

#pragma mark - Facebook

- (void)tryAutoLoginWithFacebook
{
    if ([MSFacebookManager isSessionAvailable]) {
        [self login];
    } else {
        [self setButtonsVisible:YES];
    }
}

- (void)loginWithFacebook
{
    [PFFacebookUtils logInWithPermissions:FACEBOOK_READ_PERMISIONS block:^(PFUser *user, NSError *error) {
        if (!error) {
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                [self cancelFacebookLogin];
            } else if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
                [self requestFacebookInformationsForUser:(MSUser *)user];
            } else {
                NSLog(@"User logged in through Facebook!");
                [self setButtonsVisible:NO];
                [self performLogin];
            }
        } else {
            [self cancelFacebookLogin];
        }
    }];
}

- (void)requestFacebookInformationsForUser:(MSUser *)user
{
    [self showLoadingViewInView:self.view];
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        [self hideLoadingView];
        if (!error) {
            [user setWithFacebookInfo:result];
            [user saveInBackground];
            [self pushToVerifyProfileWithUser:user];
        } else {
            [self cancelFacebookLogin];
        }
    }];
}

- (void)requestSportnerForUser:(MSUser *)user
{
    [user.sportner fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        //        [self hideLoadingView];
        if ([MSSportner currentSportner].sportLevels) {
            [self userIsLoggedIn];
        } else {
            [self pushToVerifyProfileWithUser:[MSUser currentUser]];
        }
    }];
}

- (void)userIsLoggedIn
{
    if ([MSSport allSportsAreLoaded]) {
        [self openApp];
    } else {
        [self registerToSportsLoadingNotification];
    }
}

- (void)registerToSportsLoadingNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openApp)
                                                 name:MSNotificationSportsLoaded
                                               object:nil];
}

- (void)openApp
{
    MSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate setDrawerMenu];
    
    [self presentViewController:appDelegate.drawerController animated:YES completion:nil];
}

- (void)cancelFacebookLogin
{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Login with Facebook failed"];
    [self setButtonsVisible:YES];
}

- (void)setButtonsVisible:(BOOL)visible
{
    
    CGFloat alpha = visible ? 1.0 : 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.facebookLoginButton.alpha = alpha;
        self.facebookIconView.alpha = alpha;
    }];
}

- (void)pushToVerifyProfileWithUser:(MSUser *)user
{
    MSVerifyAccountVC *destination = [MSVerifyAccountVC newController];
    destination.user = user;
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)login
{
    if ([MSSportner currentSportner]) {
        [self performLogin];
    } else {
        [self loginWithFacebook];
    }
}

- (void)performLogin
{
    if ([MSSportner currentSportner]) {
        [self requestSportnerForUser:[MSUser currentUser]];
    } else {
        [self requestFacebookInformationsForUser:[MSUser currentUser]];
    }

}

- (IBAction)logInWithFacebookButtonPress:(UIButton *)sender
{
    [self loginWithFacebook];
}

- (IBAction)signUpButtonPress:(UIButton *)sender
{
    [self.navigationController pushViewController:[MSVerifyAccountVC newController] animated:YES];
}

- (IBAction)signInButtonPress:(UIButton *)sender
{
    
}

- (void)applicationIsBackFromBackground
{
    if (self.shouldHideLoadingWhenAppOpens) {
        [self hideLoadingView];
    } else {
        [self showLoadingViewInView:self.view];
    }
}

- (IBAction)showLoginFormSheet:(UIButton *)sender
{
//    UIViewController *vc = [MSLoginFormVC newController];
//    CGSize formSheetSize = CGSizeMake(280, 300);
//    
//    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:formSheetSize viewController:vc];
////    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
//    
//    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
//    formSheet.shadowRadius = 1.0;
//    formSheet.shadowOpacity = 0.2;
//    formSheet.cornerRadius = 3.0;
//    formSheet.shouldDismissOnBackgroundViewTap = YES;
//    formSheet.shouldCenterVerticallyWhenKeyboardAppears = YES;
//    formSheet.shouldCenterVertically = YES;
//    
//    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
//        
//    };
//    
//    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
//    
//    [self presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
//        
//    }];
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
