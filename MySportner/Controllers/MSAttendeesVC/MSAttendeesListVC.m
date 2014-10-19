//
//  MSAttendeesListVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSAttendeesListVC.h"
#import "MSSportnerCell.h"

#define NIB_NAME @"MSAttendeesListVC"

@interface MSAttendeesListVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MSAttendeesListVC

+ (instancetype)newController
{
    MSAttendeesListVC *controller = [[MSAttendeesListVC alloc] initWithNibName:NIB_NAME bundle:nil];
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [MSSportnerCell registerToTableview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifer = [MSSportnerCell reusableIdentifier];
    MSSportnerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    
    cell.sportner = [MSSportner currentSportner];
    
    [cell setAppearanceWithOddIndex:((indexPath.row + 1) % 2)];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MSSportnerCell height];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MSSportnerCell height];
}


@end
