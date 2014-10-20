//
//  MSAttendeesVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSAttendeesVC.h"

#define NIB_NAME @"MSPageSportnerVC"

@interface MSAttendeesVC ()

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
    
    [activity fetchAwaitings];
    [activity fetchGuests];
    [activity fetchParticipants];
    
    [self.confirmedAttendeesVC startLoading];
    [self.invitedAttendeesVC startLoading];
    [self.awaitingAttendeesVC startLoading];
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
    }
    return _confirmedAttendeesVC;
}

- (MSSportnerListVC *)awaitingAttendeesVC
{
    if (!_awaitingAttendeesVC) {
        _awaitingAttendeesVC = [MSSportnerListVC newController];
    }
    return _awaitingAttendeesVC;
}

- (MSSportnerListVC *)invitedAttendeesVC
{
    if (!_invitedAttendeesVC) {
        _invitedAttendeesVC = [MSSportnerListVC newController];
    }
    return _invitedAttendeesVC;
}

@end
