//
//  MSAttendeesVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSAttendeesVC.h"
#import "MSProfileVC.h"

#define NIB_NAME @"MSPageSportnerVC"

@interface MSAttendeesVC () <MSAttendeesListDelegate>

@property (strong, nonatomic) MSSportnerListVC *confirmedAttendeesVC;
@property (strong, nonatomic) MSSportnerListVC *awaitingAttendeesVC;
@property (strong, nonatomic) MSSportnerListVC *invitedAttendeesVC;

@end

@implementation MSAttendeesVC

+ (instancetype)newController
{
    MSAttendeesVC *controller = [[MSAttendeesVC alloc] initWithNibName:NIB_NAME bundle:nil];
    controller.hasDirectAccessToDrawer = NO;
    [controller registerToActivityNotifications];
    return controller;
}

- (void)setUpAppearance
{
    [super setUpAppearance];
    
    self.title = [@"Attendees" uppercaseString];
    
    self.viewControllers = @[
                             self.confirmedAttendeesVC,
                             self.awaitingAttendeesVC,
                             self.invitedAttendeesVC
                             ];
    
    [self.firstListButton setTitle:@"CONFIRMED" forState:UIControlStateNormal];
    [self.secondListButton setTitle:@"AWAITING" forState:UIControlStateNormal];
    [self.thirdListButton setTitle:@"INVITED" forState:UIControlStateNormal];
}

#pragma mark - Getters & Setters

- (void)setActivity:(MSActivity *)activity
{
    _activity = activity;
    
    
    self.confirmedAttendeesVC.sportnerList = self.activity.participants;
    self.invitedAttendeesVC.sportnerList = self.activity.guests;
    self.awaitingAttendeesVC.sportnerList = self.activity.awaitings;
}

#pragma mark - Activity notification

- (void)registerToActivityNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activityConfirmedSportnerNotificationReceived)
                                                 name:MSNotificationActivityConfirmedChanged
                                               object:self.activity];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activityInvitedSportnerNotificationReceived)
                                                 name:MSNotificationActivityInvitedChanged
                                               object:self.activity];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activityAwaitingSportnerNotificationReceived)
                                                 name:MSNotificationActivityAwaitingChanged
                                               object:self.activity];
}

- (void)activityConfirmedSportnerNotificationReceived
{
    self.confirmedAttendeesVC.sportnerList = self.activity.participants;
    [self.confirmedAttendeesVC stopLoading];
}

- (void)activityInvitedSportnerNotificationReceived
{
    self.invitedAttendeesVC.sportnerList = self.activity.guests;
    [self.invitedAttendeesVC stopLoading];
}

- (void)activityAwaitingSportnerNotificationReceived
{
    self.invitedAttendeesVC.sportnerList = self.activity.guests;
    [self.awaitingAttendeesVC stopLoading];
}

#pragma mark - AttendeesListControllers

- (MSSportnerListVC *)confirmedAttendeesVC
{
    if (!_confirmedAttendeesVC) {
        _confirmedAttendeesVC = [MSSportnerListVC newController];
        _confirmedAttendeesVC.delegate = self;
    }
    return _confirmedAttendeesVC;
}

- (MSSportnerListVC *)awaitingAttendeesVC
{
    if (!_awaitingAttendeesVC) {
        _awaitingAttendeesVC = [MSSportnerListVC newController];
        _awaitingAttendeesVC.delegate = self;
    }
    return _awaitingAttendeesVC;
}

- (MSSportnerListVC *)invitedAttendeesVC
{
    if (!_invitedAttendeesVC) {
        _invitedAttendeesVC = [MSSportnerListVC newController];
        _invitedAttendeesVC.delegate = self;
    }
    return _invitedAttendeesVC;
}

#pragma mark - MSAttendeesListDelegate

- (void)sportnerList:(MSSportnerListVC *)sportnerListVC didSelectSportner:(MSSportner *)sportner atIndexPath:(NSIndexPath *)indexPath
{
    MSProfileVC *destination = [MSProfileVC newController];
    destination.hasDirectAccessToDrawer = NO;
    destination.sportner = sportner;
    [self.navigationController pushViewController:destination animated:YES];
}

@end
