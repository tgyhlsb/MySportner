//
//  MSVInviteSportnersVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSVInviteSportnersVC.h"

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
    return controller;
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

#pragma mark - Fetch & network

- (void)fetchOthersSportners
{
    [self.othersVC startLoading];
    PFQuery *query = [MSSportner query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            NSMutableArray *sportners = [objects mutableCopy];
            [sportners removeObject:[MSSportner currentSportner]];
            
            self.othersVC.sportnerList = sportners;
        } else {
            NSLog(@"%@", error);
        }
        [self.othersVC stopLoading];
    }];
}

#pragma mark - AttendeesListControllers

- (MSAttendeesListVC *)sportnersVC
{
    if (!_sportnersVC) {
        _sportnersVC = [MSAttendeesListVC newController];
    }
    return _sportnersVC;
}

- (MSAttendeesListVC *)facebookVC
{
    if (!_facebookVC) {
        _facebookVC = [MSAttendeesListVC newController];
    }
    return _facebookVC;
}

- (MSAttendeesListVC *)othersVC
{
    if (!_othersVC) {
        _othersVC = [MSAttendeesListVC newController];
    }
    return _othersVC;
}

@end
