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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

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

#pragma mark - Getters & Setters

- (void)setSportnerList:(NSArray *)sportnerList
{
    _sportnerList = sportnerList;
    
    [self.tableView reloadData];
}

- (void)startLoading
{
    [self.loadingIndicator startAnimating];
    self.tableView.hidden = YES;
}

- (void)stopLoading
{
    [self.loadingIndicator stopAnimating];
    self.tableView.hidden = NO;
}

- (NSMutableArray *)selectedSportners
{
    if (!_selectedSportners) {
        _selectedSportners = [[NSMutableArray alloc] init];
    }
    return _selectedSportners;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sportnerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifer = [MSSportnerCell reusableIdentifier];
    MSSportnerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    
    cell.sportner = [self.sportnerList objectAtIndex:indexPath.row];
    [cell setActionButtonHidden:YES];
    [cell setAppearanceWithOddIndex:((indexPath.row + 1) % 2)];
    
    cell.isSelected = [self.selectedSportners containsObject:cell.sportner];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.allowsMultipleSelection) {
        MSSportner *sportner = [self.sportnerList objectAtIndex:indexPath.row];
        
        if ([self.selectedSportners containsObject:sportner]) {
            [self.selectedSportners removeObject:sportner];
        } else {
            [self.selectedSportners addObject:sportner];
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


@end
