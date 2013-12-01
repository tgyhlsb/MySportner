//
//  MSLoginFormVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 26/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSLoginFormVC.h"
#import "MBProgressHUD.h"
#import "MSUser.h"
#import "MSWelcomeVC.h"
#import "MSColorFactory.h"
#import "QBFlatButton.h"
#import "UITextField+MSTextFieldAppearance.h"
#import "MSTextField.h"
#import "MSFontFactory.h"

#define NIB_NAME @"MSLoginFormVC"

@interface MSLoginFormVC ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet MSTextField *emailTextField;
@property (weak, nonatomic) IBOutlet MSTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *forgotPasswordLabel;
@property (weak, nonatomic) IBOutlet QBFlatButton *connectButton;

@property (strong, nonatomic) MBProgressHUD *loadingView;

@end

@implementation MSLoginFormVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = @"LOGIN";
    
    [self.view setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.9]];
    
    [self setAppearance];
}

- (void)setAppearance
{
    self.connectButton.faceColor = [MSColorFactory redLight];
    self.connectButton.sideColor = [MSColorFactory redDark];
    self.connectButton.titleLabel.font = [MSFontFactory fontForButton];
    [self.connectButton setTitleColor:[MSColorFactory whiteLight] forState:UIControlStateNormal];
    
    self.emailTextField.focusBorderColor = [MSColorFactory redLight];
    self.emailTextField.textColor = [MSColorFactory redLight];
    
    self.passwordTextField.focusBorderColor = [MSColorFactory redLight];
    self.passwordTextField.textColor = [MSColorFactory redLight];
    
    self.forgotPasswordLabel.textColor = [MSColorFactory redLight];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Access to form sheet controller
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = YES;
}

+ (MSLoginFormVC *)newController
{
    return [[MSLoginFormVC alloc] initWithNibName:NIB_NAME bundle:Nil];
}

- (IBAction)connectButtonPress:(UIButton *)sender
{
    [self showLoadingViewInView:self.view];
    [MSUser logInWithUsernameInBackground:self.emailTextField.text
                                 password:self.passwordTextField.text
                                   target:self
                                 selector:@selector(handleUserLogin:error:)];
}

// First set up a callback.
- (void)handleUserLogin:(PFUser *)user error:(NSError *)error
{
    [self hideLoadingView];
    if (user) {
        [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
            MSWelcomeVC *welcomeVC = (MSWelcomeVC *)formSheetController.presentingViewController;
            [welcomeVC performLogin];
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
    }
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
