//
//  MSVInviteSportnersVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSInviteSportnersVC.h"
#import "TKAlertCenter.h"
#import "MSNotificationCenter.h"

#define NIB_NAME @"MSPageSportnerVC"

@interface MSInviteSportnersVC () <MSAttendeesListDatasource>

@property (strong, nonatomic) MSSportnerListVC *sportnersVC;
@property (strong, nonatomic) MSSportnerListVC *facebookVC;
@property (strong, nonatomic) MSSportnerListVC *othersVC;

@end

@implementation MSInviteSportnersVC

+ (instancetype)newController
{
    MSInviteSportnersVC *controller = [[MSInviteSportnersVC alloc] initWithNibName:NIB_NAME bundle:nil];
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
    self.facebookVC.sportnerList = [[NSArray alloc] init];
    self.othersVC.sportnerList = nil;
    
    [self fetchOthersSportners];
}

#pragma mark - Handlers

- (void)inviteButtonHandler
{
    
    NSMutableArray *selectedSportners = [self.sportnersVC.selectedSportners mutableCopy];
    [selectedSportners addObjectsFromArray:self.facebookVC.selectedSportners];
    [selectedSportners addObjectsFromArray:self.othersVC.selectedSportners];
    
    
    if ([selectedSportners count]) {
        [self showLoadingViewInView:self.navigationController.view];
        __weak MSInviteSportnersVC *weakSelf = self;
        [self.activity addGuests:selectedSportners withBlock:^(PFObject *result, NSError *error) {
            [weakSelf hideLoadingView];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Invitations sent"];
        }];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Select sportners to invite"];
    }
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activityNotificationReceived)
                                                 name:MSNotificationActivityConfirmedChanged
                                               object:self.activity];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activityNotificationReceived)
                                                 name:MSNotificationActivityInvitedChanged
                                               object:self.activity];
}

- (void)sportnerNotificationReceived
{
    self.sportnersVC.sportnerList = [MSSportner currentSportner].sportners;
    [self filterOthersSportners];
    [self.sportnersVC stopLoading];
}

- (void)activityNotificationReceived
{
    [self.sportnersVC reloadData];
}

#pragma mark - AttendeesListControllers

- (MSSportnerListVC *)sportnersVC
{
    if (!_sportnersVC) {
        _sportnersVC = [MSSportnerListVC newController];
        _sportnersVC.allowsMultipleSelection = YES;
        _sportnersVC.datasource = self;
    }
    return _sportnersVC;
}

- (MSSportnerListVC *)facebookVC
{
    if (!_facebookVC) {
        _facebookVC = [MSSportnerListVC newController];
        _facebookVC.allowsMultipleSelection = YES;
        _facebookVC.datasource = self;
    }
    return _facebookVC;
}

- (MSSportnerListVC *)othersVC
{
    if (!_othersVC) {
        _othersVC = [MSSportnerListVC newController];
        _othersVC.allowsMultipleSelection = YES;
        _othersVC.datasource = self;
    }
    return _othersVC;
}

#pragma mark - MSAttendeesListDatasource

- (BOOL)sportnerList:(MSSportnerListVC *)sportListVC shouldDisableCellForSportner:(MSSportner *)sportner
{
    return [self.activity.guests containsObject:sportner];
}


@end
