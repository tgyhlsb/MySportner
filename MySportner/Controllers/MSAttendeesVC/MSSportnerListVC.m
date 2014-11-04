//
//  MSAttendeesListVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSSportnerListVC.h"

#import "MSSportnerCell.h"

#import "MSColorFactory.h"

#define NIB_NAME @"MSSportnerListVC"

@interface MSSportnerListVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (nonatomic) BOOL isLoading;

@end

@implementation MSSportnerListVC

+ (instancetype)newController
{
    MSSportnerListVC *controller = [[MSSportnerListVC alloc] initWithNibName:NIB_NAME bundle:nil];
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [MSSportnerCell registerToTableview:self.tableView];
    
    self.loadingIndicator.color = [MSColorFactory mainColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateLoadingView];
}

- (void)reloadData
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Getters & Setters

- (void)setSportnerList:(NSArray *)sportnerList
{
    _sportnerList = sportnerList;
    
    [self reloadData];
}

- (void)startLoading
{
    self.isLoading = YES;
}

- (void)stopLoading
{
    self.isLoading = NO;
}

- (void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
    
    [self updateLoadingView];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
}

- (void)updateLoadingView
{
    if (self.isLoading) {
        [self.loadingIndicator startAnimating];
    } else {
        [self.loadingIndicator stopAnimating];
    }
    self.tableView.hidden = self.isLoading;
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
    
    if (self.allowsMultipleSelection) {
        cell.isSelected = [self.selectedSportners containsObject:cell.sportner];
    }
    
    if ([self.datasource respondsToSelector:@selector(sportnerList:shouldDisableCellForSportner:)]) {
        cell.isDisabled = [self.datasource sportnerList:self shouldDisableCellForSportner:cell.sportner];
    }
    
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
    MSSportnerCell *cell = (MSSportnerCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (self.allowsMultipleSelection && !cell.isDisabled) {
        MSSportner *sportner = [self.sportnerList objectAtIndex:indexPath.row];
        
        if ([self.selectedSportners containsObject:sportner]) {
            [self.selectedSportners removeObject:sportner];
        } else {
            [self.selectedSportners addObject:sportner];
        }
        
        cell.isSelected = [self.selectedSportners containsObject:cell.sportner];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(sportnerList:didSelectSportner:atIndexPath:)]) {
        [self.delegate sportnerList:self didSelectSportner:cell.sportner atIndexPath:indexPath];
    }
}


@end
