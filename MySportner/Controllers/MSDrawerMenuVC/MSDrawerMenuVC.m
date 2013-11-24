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

#define NIB_NAME @"MSDrawerMenuVC"

@interface MSDrawerMenuVC ()
@property (weak, nonatomic) IBOutlet FBProfilePictureView *fbProfilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;

@end

@implementation MSDrawerMenuVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateViewWithUser:[MSUser currentUser]];
}

- (void)updateViewWithUser:(MSUser *)user
{
    self.fbProfilePictureView.profileID = user.facebookID;
    self.firstNameLabel.text = user.firstName;
    self.lastNameLabel.text = user.lastName;
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
}

- (IBAction)activitiesButtonPress:(UIButton *)sender
{
    [self.mm_drawerController displayCenterControlerForView:MSCenterViewActivities];
}

- (IBAction)notificationsButtonPress:(id)sender
{
    [self.mm_drawerController displayCenterControlerForView:MSCenterViewNotifications];
}

- (IBAction)setAGameButtonPress:(UIButton *)sender
{
    [self.mm_drawerController displayCenterControlerForView:MSCenterViewSetAGame];
}

- (IBAction)settingsButtonPress:(UIButton *)sender
{
    [self.mm_drawerController displayCenterControlerForView:MSCenterViewSettings];
}

- (IBAction)fiendFriendsButtonPress:(UIButton *)sender
{
    [self.mm_drawerController displayCenterControlerForView:MSCenterViewFiendFriends];
}

- (IBAction)logoutButtonPress:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
