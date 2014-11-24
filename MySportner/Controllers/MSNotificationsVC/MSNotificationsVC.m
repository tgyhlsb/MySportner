//
//  MSNotificationsVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSNotificationsVC.h"
#import "MSGameProfileVC.h"

#import "MSNotificationCell.h"
#import "MSNotificationRequestCell.h"

#import "MSNotification.h"
#import "TKAlertCenter.h"
#import "MSNotificationCenter.h"
#import "MSColorFactory.h"

#define NIB_NAME @"MSNotificationsVC"

@interface MSNotificationsVC () <UITableViewDataSource, UITableViewDelegate, MSNotificationRequestCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *notifications;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation MSNotificationsVC

+ (MSNotificationsVC *)newController
{
    MSNotificationsVC *notificationsVC = [[MSNotificationsVC alloc] initWithNibName:NIB_NAME bundle:nil];
    notificationsVC.hasDirectAccessToDrawer = YES;
    notificationsVC.title = @"NOTIFICATIONS";
    return notificationsVC;
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [MSNotificationCell registerToTableview:self.tableView];
    [MSNotificationRequestCell registerToTableview:self.tableView];
    [self registerToLocalNotifications];
    
    self.loadingIndicator.tintColor = [MSColorFactory mainColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startLoading];
    
    [MSNotificationCenter fetchUserNotifications];
    [self loadNotifications];
}

#pragma mark - Loading

- (void)startLoading
{
    self.tableView.hidden = YES;
}

- (void)stopLoading
{
    self.tableView.hidden = NO;
}

#pragma mark - Getters & Setters

- (void)setNotifications:(NSArray *)notifications
{
    _notifications = notifications;
    
    [self reloadTableView];
}

#pragma mark - Local notifications

- (void)registerToLocalNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userNotificationsFetchedHandler)
                                                 name:MSNotificationUserNotificationsFetched
                                               object:nil];
}

- (void)userNotificationsFetchedHandler
{
    [self loadNotifications];
}

- (void)loadNotifications
{
    self.notifications = [[MSNotificationCenter userNotifications] sortedArrayUsingSelector:@selector(compareWithCreationDate:)];
    [self stopLoading];
}

#pragma mark - UITableViewDataSource

- (void)reloadTableView
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.notifications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSNotification *notification = [self.notifications objectAtIndex:indexPath.row];
    NSString *identifier = nil;
    
    if ([notification.type isEqualToString:MSNotificationTypeInvitation] && ![notification isExpired]) {
        identifier = [MSNotificationRequestCell reusableIdentifier];
    } else if ([notification.type isEqualToString:MSNotificationTypeAwaiting] && ![notification isExpired]) {
        identifier = [MSNotificationRequestCell reusableIdentifier];
    } else {
        identifier = [MSNotificationCell reusableIdentifier];
    }
        
    MSNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.notification = notification;
    
    if ([cell isKindOfClass:[MSNotificationRequestCell class]]) {
        ((MSNotificationRequestCell *)cell).delegate = self;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MSNotificationCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSNotification *notification = [self.notifications objectAtIndex:indexPath.row];
    
    if (notification.activity) {
        MSGameProfileVC *destination = [MSGameProfileVC newController];
        destination.hasDirectAccessToDrawer = NO;
        destination.activity = notification.activity;
        [self.navigationController pushViewController:destination animated:YES];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"No action available"];
    }
}

#pragma mark - MSNotificationRequestCellDelegate

- (void)notificationRequestCellDidTapAccept:(MSNotificationRequestCell *)cell
{
    
    [MSNotificationCenter setStatusBarWithTitle:@"Sending answer..."];
    MSNotification *notification = cell.notification;
    [notification acceptWithBlock:^(PFObject *object, NSError *error) {
        [MSNotificationCenter dismissStatusBarNotification];
        if (!error) {
            cell.notification.expired = @(YES);
            [cell.notification saveEventually];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

- (void)notificationRequestCellDidTapDecline:(MSNotificationRequestCell *)cell
{
    [MSNotificationCenter setStatusBarWithTitle:@"Sending answer..."];
    MSNotification *notification = cell.notification;
    [notification declineWithBlock:^(PFObject *object, NSError *error) {
        [MSNotificationCenter dismissStatusBarNotification];
        if (!error) {
            cell.notification.expired = @(YES);
            [cell.notification saveEventually];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

@end
