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
#import "MSFacebookManager.h"

#define NIB_NAME @"MSPageSportnerVC"

@interface MSInviteSportnersVC () <MSAttendeesListDatasource, MSAttendeesListDelegate>

@property (strong, nonatomic) MSSportnerListVC *sportnersVC;
@property (strong, nonatomic) MSSportnerListVC *facebookVC;
@property (strong, nonatomic) MSSportnerListVC *othersVC;

@property (strong,nonatomic) UIBarButtonItem *inviteButton;
@property (strong,nonatomic) UIBarButtonItem *facebookButton;

@end

@implementation MSInviteSportnersVC

+ (instancetype)newController
{
    MSInviteSportnersVC *controller = [[MSInviteSportnersVC alloc] initWithNibName:NIB_NAME bundle:nil];
    controller.hasDirectAccessToDrawer = NO;
    [controller registerToSportnerNotifications];
    [controller setUpInviteButtonVisible:NO];
    return controller;
}

#pragma mark - Appearance

- (void)setUpInviteButtonVisible:(BOOL)visible
{
    self.navigationItem.rightBarButtonItem = visible ? self.inviteButton : nil;
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
    self.facebookVC.sportnerList = nil;
    self.othersVC.sportnerList = nil;
    
    [self fetchOthersSportners];
    [self fetchFacebookSportners];
}

- (UIBarButtonItem *)inviteButton
{
    if (!_inviteButton) {
        _inviteButton = [[UIBarButtonItem alloc] initWithTitle:@"Invite"
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(inviteButtonHandler)];
    }
    return _inviteButton;
}

- (UIBarButtonItem *)facebookButton
{
    if (!_facebookButton) {
        _facebookButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                        target:self
                                                                        action:@selector(facebookButtonHandler)];
    }
    return _facebookButton;
}

- (NSArray *)allSelectedSportners
{
    NSMutableArray *selectedSportners = [self.sportnersVC.selectedSportners mutableCopy];
    [selectedSportners addObjectsFromArray:self.facebookVC.selectedSportners];
    [selectedSportners addObjectsFromArray:self.othersVC.selectedSportners];
    return selectedSportners;
}

#pragma mark - Handlers

- (void)inviteButtonHandler
{
    NSArray *selectedSportners = [self allSelectedSportners];
    
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

- (void)facebookButtonHandler
{
    [MSFacebookManager shareInviteFriends];
}

#pragma mark - Fetch & network

- (void)fetchFacebookSportners
{
    [self.othersVC startLoading];
    [self.facebookVC startLoading];
    [MSFacebookManager requestForMyFriendsWithBlock:^(NSArray *objects, NSError *error) {
        [self.facebookVC stopLoading];
        self.facebookVC.sportnerList = objects;
        [self fetchOthersSportners];
        [self filterOthersSportners];
    }];
}

- (void)fetchOthersSportners
{
    PFQuery *query = [MSSportner query];
    [query whereKey:@"self" notContainedIn:self.facebookVC.sportnerList];
    [query whereKey:@"self" notContainedIn:self.sportnersVC.sportnerList];
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
        _sportnersVC.delegate = self;
    }
    return _sportnersVC;
}

- (MSSportnerListVC *)facebookVC
{
    if (!_facebookVC) {
        _facebookVC = [MSSportnerListVC newController];
        _facebookVC.allowsMultipleSelection = YES;
        _facebookVC.datasource = self;
        _facebookVC.delegate = self;
    }
    return _facebookVC;
}

- (MSSportnerListVC *)othersVC
{
    if (!_othersVC) {
        _othersVC = [MSSportnerListVC newController];
        _othersVC.allowsMultipleSelection = YES;
        _othersVC.datasource = self;
        _othersVC.delegate = self;
    }
    return _othersVC;
}

#pragma mark - MSAttendeesListDatasource

- (BOOL)sportnerList:(MSSportnerListVC *)sportListVC shouldDisableCellForSportner:(MSSportner *)sportner
{
    return [self.activity.guests containsObject:sportner];
}

#pragma mark - MSAttendeesListDelegate

- (void)sportnerList:(MSSportnerListVC *)sportnerListVC didSelectSportner:(MSSportner *)sportner atIndexPath:(NSIndexPath *)indexPath
{
    [self setUpInviteButtonVisible:([[self allSelectedSportners] count] > 0)];
}

#pragma mark - Overrides


- (void)setViewControllerAtIndex:(NSInteger)index
{
    [super setViewControllerAtIndex:index];
    
    if (index == 1) {
        NSMutableArray *rightItems = [[NSMutableArray alloc] init];
        [rightItems addObjectsFromArray:self.navigationItem.rightBarButtonItems];
        [rightItems addObject:self.facebookButton];
        self.navigationItem.rightBarButtonItems = rightItems;
    } else {
        NSMutableArray *rightItems = [[NSMutableArray alloc] init];
        [rightItems addObjectsFromArray:self.navigationItem.rightBarButtonItems];
        [rightItems removeObject:self.facebookButton];
        self.navigationItem.rightBarButtonItems = rightItems;
    }
}

@end
