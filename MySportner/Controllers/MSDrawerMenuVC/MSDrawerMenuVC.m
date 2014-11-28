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
#import "MSUser.h"
#import "UIView+MSRoundedView.h"
#import "QBFlatButton.h"
#import "MSColorFactory.h"
#import "MSStyleFactory.h"
#import "MSFontFactory.h"
#import "MSProfilePictureView.h"

#define NIB_NAME @"MSDrawerMenuVC"

@interface MSDrawerMenuVC ()
@property (weak, nonatomic) IBOutlet MSProfilePictureView *fbProfilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet QBFlatButton *activitiesButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *notificationsButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *setAGameButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet QBFlatButton *fiendFriendsButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIView *topContainer;
@property (weak, nonatomic) IBOutlet UIButton *viewProfileButton;

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
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drawer_background.png"]];
    
    self.view.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:93.0/255.0 blue:101.0/255.0 alpha:1.0];
    int width = 320;
    int height = self.view.bounds.size.height;
    imgView.frame = CGRectMake(0, 0, width, height);
    [self.view insertSubview:imgView atIndex:0];
    imgView.hidden = YES;
    
    self.topContainer.backgroundColor = [UIColor clearColor];
    self.topContainer.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.08] CGColor];
    self.topContainer.layer.borderWidth = 1.0;
    self.topContainer.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.topContainer.layer.shadowRadius = 0.4;
    self.topContainer.layer.shadowOpacity = 0.08;
    self.topContainer.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    
    self.viewProfileButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.viewProfileButton setTitle:@"View profile" forState:UIControlStateNormal];
    [self.viewProfileButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
    self.viewProfileButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:12.0];
    
    
    self.bottomContainerView.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:73.0/255.0 blue:82.0/255.0 alpha:1.0];
    self.fbProfilePictureView.backgroundColor = [UIColor clearColor];
    
    self.fbProfilePictureView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.4] CGColor];
    self.fbProfilePictureView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    
    [MSStyleFactory setUILabel:self.userNameLabel withStyle:MSLabelStyleUserName];
    [MSStyleFactory setUILabel:self.welcomeLabel withStyle:MSLabelStyleUserName];
    self.welcomeLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0];
    
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
    
    [self.fiendFriendsButton setTitle:@"SHARE" forState:UIControlStateNormal];
    [MSStyleFactory setQBFlatButton:self.fiendFriendsButton withStyle:MSFlatButtonStyleDrawerMenuLight];
    
    [self.logoutButton setTitle:@"LOGOUT" forState:UIControlStateNormal];
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
    self.fbProfilePictureView.sportner = [MSSportner currentSportner];
    self.welcomeLabel.text = @"HELLO";
    self.userNameLabel.text = [[MSSportner currentSportner].firstName uppercaseString];
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
    self.selectedButton = nil;
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
