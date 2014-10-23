//
//  MSNotificationsVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSNotificationsVC.h"

#import "MSNotificationCell.h"

#import "MSNotification.h"
#import "MSNotificationCenter.h"

#define NIB_NAME @"MSNotificationsVC"

@interface MSNotificationsVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *notifications;

@end

@implementation MSNotificationsVC

+ (MSNotificationsVC *)newController
{
    MSNotificationsVC *notificationsVC = [[MSNotificationsVC alloc] initWithNibName:NIB_NAME bundle:nil];
    notificationsVC.hasDirectAccessToDrawer = YES;
    return notificationsVC;
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MSNotificationCell registerToTableview:self.tableView];
    [self registerToLocalNotifications];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MSNotificationCenter fetchUserNotifications];
    [self loadNotifications];
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
    NSString *identifier = [MSNotificationCell reusableIdentifier];
    MSNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.notification = [self.notifications objectAtIndex:indexPath.row];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end
