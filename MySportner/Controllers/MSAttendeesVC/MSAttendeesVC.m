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

@property (strong, nonatomic) MSAttendeesListVC *confirmedAttendeesVC;
@property (strong, nonatomic) MSAttendeesListVC *awaitingAttendeesVC;
@property (strong, nonatomic) MSAttendeesListVC *invitedAttendeesVC;

@end

@implementation MSAttendeesVC

+ (instancetype)newController
{
    MSAttendeesVC *controller = [[MSAttendeesVC alloc] initWithNibName:NIB_NAME bundle:nil];
    controller.hasDirectAccessToDrawer = NO;
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

#pragma mark - AttendeesListControllers

- (MSAttendeesListVC *)confirmedAttendeesVC
{
    if (!_confirmedAttendeesVC) {
        _confirmedAttendeesVC = [MSAttendeesListVC newController];
    }
    return _confirmedAttendeesVC;
}

- (MSAttendeesListVC *)awaitingAttendeesVC
{
    if (!_awaitingAttendeesVC) {
        _awaitingAttendeesVC = [MSAttendeesListVC newController];
    }
    return _awaitingAttendeesVC;
}

- (MSAttendeesListVC *)invitedAttendeesVC
{
    if (!_invitedAttendeesVC) {
        _invitedAttendeesVC = [MSAttendeesListVC newController];
    }
    return _invitedAttendeesVC;
}

@end
