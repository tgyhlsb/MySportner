//
//  MSVInviteSportnersVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSVInviteSportnersVC.h"
#import "TKAlertCenter.h"

#define NIB_NAME @"MSPageSportnerVC"

@interface MSVInviteSportnersVC ()

@property (strong, nonatomic) MSAttendeesListVC *sportnersVC;
@property (strong, nonatomic) MSAttendeesListVC *facebookVC;
@property (strong, nonatomic) MSAttendeesListVC *othersVC;

@end

@implementation MSVInviteSportnersVC

+ (instancetype)newController
{
    MSVInviteSportnersVC *controller = [[MSVInviteSportnersVC alloc] initWithNibName:NIB_NAME bundle:nil];
    controller.hasDirectAccessToDrawer = NO;
    [controller registerToSportnerNotifications];
    [controller setUpInviteButton];
    return controller;
}

#pragma mark - Appearance

- (void)setUpInviteButton
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Invite"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(inviteButtonHandler)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)setUpAppearance
{
    [super setUpAppearance];
    
    self.title = [@"Invite sportners" uppercaseString];
    
    self.viewControllers = @[
                             self.sportnersVC,
                             self.facebookVC,
                             self.othersVC
                             ];
    
    [self.firstListButton setTitle:@"SPORTNERS" forState:UIControlStateNormal];
    [self.secondListButton setTitle:@"FACEBOOK" forState:UIControlStateNormal];
    [self.thirdListButton setTitle:@"OTHERS" forState:UIControlStateNormal];
}

#pragma mark - Getters & Setters

- (void)setActivity:(MSActivity *)activity
{
    _activity = activity;
    
    self.sportnersVC.sportnerList = [MSSportner currentSportner].sportners;
    self.facebookVC.sportnerList = self.activity.awaitings;
    self.othersVC.sportnerList = nil;
    
    [self fetchOthersSportners];
}

#pragma mark - Handlers

- (void)inviteButtonHandler
{
    [self showLoadingViewInView:self.navigationController.view];
    
    NSMutableArray *selectedSportners = [self.sportnersVC.selectedSportners mutableCopy];
    [selectedSportners addObjectsFromArray:self.facebookVC.selectedSportners];
    [selectedSportners addObjectsFromArray:self.othersVC.selectedSportners];
    
    __weak MSVInviteSportnersVC *weakSelf = self;
    [self.activity addGuests:selectedSportners withBlock:^(BOOL succeeded, NSError *error) {
        [weakSelf hideLoadingView];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Invitations sent"];
    }];
}

#pragma mark - Fetch & network

- (void)fetchOthersSportners
{
    [self.othersVC startLoading];
    PFQuery *query = [MSSportner query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            self.othersVC.sportnerList = objects;
            [self filterOthersSportners];
        } else {
            NSLog(@"%@", error);
        }
        [self.othersVC stopLoading];
    }];
}

- (void)filterOthersSportners
{
    NSMutableArray *sportners = [self.facebookVC.sportnerList mutableCopy];
    [sportners removeObject:[MSSportner currentSportner]];
    [sportners removeObjectsInArray:self.sportnersVC.sportnerList];
    self.facebookVC.sportnerList = sportners;
    
    sportners = [self.othersVC.sportnerList mutableCopy];
    [sportners removeObject:[MSSportner currentSportner]];
    [sportners removeObjectsInArray:self.sportnersVC.sportnerList];
    [sportners removeObjectsInArray:self.facebookVC.sportnerList];
    self.othersVC.sportnerList = sportners;
}

#pragma mark - Sportner notification

- (void)registerToSportnerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sportnerNotificationReceived)
                                                 name:MSNotificationSportnerStateChanged
                                               object:[MSSportner currentSportner]];
}

- (void)sportnerNotificationReceived
{
    self.sportnersVC.sportnerList = [MSSportner currentSportner].sportners;
    [self filterOthersSportners];
    [self.sportnersVC stopLoading];
}


#pragma mark - AttendeesListControllers

- (MSAttendeesListVC *)sportnersVC
{
    if (!_sportnersVC) {
        _sportnersVC = [MSAttendeesListVC newController];
        _sportnersVC.allowsMultipleSelection = YES;
    }
    return _sportnersVC;
}

- (MSAttendeesListVC *)facebookVC
{
    if (!_facebookVC) {
        _facebookVC = [MSAttendeesListVC newController];
        _facebookVC.allowsMultipleSelection = YES;
    }
    return _facebookVC;
}

- (MSAttendeesListVC *)othersVC
{
    if (!_othersVC) {
        _othersVC = [MSAttendeesListVC newController];
        _othersVC.allowsMultipleSelection = YES;
    }
    return _othersVC;
}


@end
