//
//  MSDrawerMenuVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 22/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSDrawerMenuVC.h"
#import "UIViewController+MMDrawerController.h"
#import "MSDrawerController.h"
#import "MSProfileVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MSUser.h"
#import "UIView+MSRoundedView.h"
#import "QBFlatButton.h"
#import "MSColorFactory.h"
#import "MSStyleFactory.h"
#import "MSFontFactory.h"

#define NIB_NAME @"MSDrawerMenuVC"

@interface MSDrawerMenuVC ()
@property (weak, nonatomic) IBOutlet FBProfilePictureView *fbProfilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet QBFlatButton *activitiesButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *notificationsButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *setAGameButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet QBFlatButton *fiendFriendsButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *logoutButton;

@property (weak, nonatomic) QBFlatButton *selectedButton;

@end

@implementation MSDrawerMenuVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.fbProfilePictureView setRounded];
    
    [self setGestureRecognizer];
    
    [self setAppearance];
    self.selectedButton = self.activitiesButton;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)setGestureRecognizer
{
    UITapGestureRecognizer *profileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileTapHandler)];
    UITapGestureRecognizer *pictureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileTapHandler)];
    UITapGestureRecognizer *welcomeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileTapHandler)];
    
    [self.fbProfilePictureView addGestureRecognizer:pictureTap];
    self.fbProfilePictureView.userInteractionEnabled = YES;
    [self.userNameLabel addGestureRecognizer:profileTap];
    self.userNameLabel.userInteractionEnabled = YES;
    [self.welcomeLabel addGestureRecognizer:welcomeTap];
    self.welcomeLabel.userInteractionEnabled = YES;
    
    self.selectedButton = nil;
}

- (void)setAppearance
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iOS_blur.png"]];
    //self.view.backgroundColor = [UIColor colorWithRed:0.45f green:0.51f blue:0.53f alpha:1.00f];
    UIView *grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    [grayView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    [self.view insertSubview:grayView atIndex:0];
    self.bottomContainerView.backgroundColor = [UIColor colorWithRed:0.40f green:0.43f blue:0.49f alpha:0.5f];
    self.fbProfilePictureView.backgroundColor = [UIColor clearColor];
    
    [MSStyleFactory setUILabel:self.userNameLabel withStyle:MSLabelStyleUserName];
    
    [self.activitiesButton setTitle:@"ACTIVITIES" forState:UIControlStateNormal];
    [MSStyleFactory setQBFlatButton:self.activitiesButton withStyle:MSFlatButtonStyleDrawerMenu];
    
    [self.notificationsButton setTitle:@"NOTIFICATIONS" forState:UIControlStateNormal];
    [MSStyleFactory setQBFlatButton:self.notificationsButton withStyle:MSFlatButtonStyleDrawerMenu];
    
    [self.setAGameButton setTitle:@"SET A GAME" forState:UIControlStateNormal];
    [MSStyleFactory setQBFlatButton:self.setAGameButton withStyle:MSFlatButtonStyleDrawerMenu];
    
    [self.settingsButton setTitle:@"SETTINGS" forState:UIControlStateNormal];
    [MSStyleFactory setQBFlatButton:self.settingsButton withStyle:MSFlatButtonStyleDrawerMenu];
    
    self.welcomeLabel.textColor = [MSColorFactory whiteLight];
    self.userNameLabel.textColor = [MSColorFactory whiteLight];
    
    [self.fiendFriendsButton setTitle:@"FIEND FRIENDS" forState:UIControlStateNormal];
    [MSStyleFactory setQBFlatButton:self.fiendFriendsButton withStyle:MSFlatButtonStyleDrawerMenuLight];
    
    [self.logoutButton setTitle:@"LOG OUT" forState:UIControlStateNormal];
    [MSStyleFactory setQBFlatButton:self.logoutButton withStyle:MSFlatButtonStyleDrawerMenuLight];
}

- (void)setSelectedButton:(QBFlatButton *)selectedButton
{
    _selectedButton.faceColor = [UIColor clearColor];
    [_selectedButton setNeedsDisplay];
    selectedButton.faceColor = [MSColorFactory mainColor];
    [selectedButton setNeedsDisplay];
    
    _selectedButton = selectedButton;
}

- (void)profileTapHandler
{
    [self profileButtonPress:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateView];
}

- (void)updateView
{
    self.fbProfilePictureView.profileID = [MSUser currentUser].facebookID;
    self.welcomeLabel.text = @"HELLO";
    self.userNameLabel.text = [[[MSUser currentUser] fullName] uppercaseString];
}



#pragma mark Class methods

+ (MSDrawerMenuVC *)newController
{
    return [[MSDrawerMenuVC alloc] initWithNibName:NIB_NAME bundle:nil];
}

#pragma mark Actions

- (IBAction)profileButtonPress:(UIButton *)sender
{
    [self.mm_drawerController displayCenterControlerForView:MSCenterViewProfile];
    self.selectedButton = (QBFlatButton *)sender;
}

- (IBAction)activitiesButtonPress:(UIButton *)sender
{
    [self.mm_drawerController displayCenterControlerForView:MSCenterViewActivities];
    self.selectedButton = (QBFlatButton *)sender;
}

- (IBAction)notificationsButtonPress:(id)sender
{
    [self.mm_drawerController displayCenterControlerForView:MSCenterViewNotifications];
    self.selectedButton = (QBFlatButton *)sender;
}

- (IBAction)setAGameButtonPress:(UIButton *)sender
{
    [self.mm_drawerController displayCenterControlerForView:MSCenterViewSetAGame];
    self.selectedButton = (QBFlatButton *)sender;
}

- (IBAction)settingsButtonPress:(UIButton *)sender
{
    [self.mm_drawerController displayCenterControlerForView:MSCenterViewSettings];
    self.selectedButton = (QBFlatButton *)sender;
}

- (IBAction)fiendFriendsButtonPress:(UIButton *)sender
{
    [self.mm_drawerController displayCenterControlerForView:MSCenterViewFiendFriends];
    self.selectedButton = nil;
}

- (IBAction)logoutButtonPress:(UIButton *)sender
{
    [MSUser logOut];
    [((UINavigationController *)self.presentingViewController) popToRootViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
