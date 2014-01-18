//
//  MSLocationPickerVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 31/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSLocationPickerVC.h"
#import "MSLocationCell.h"
#import "MSAutocompleteRequest.h"

@interface MSLocationPickerVC () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MSAutocompleteRequestDelegate>

@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSString *searchText;
@property (weak, nonatomic) MSLocationCell *searchDisplayCell;

@property (strong, nonatomic) MSAutocompleteRequest *autcompleteRequest;

@end

@implementation MSLocationPickerVC

+ (MSLocationPickerVC *)newControler
{
    return [[MSLocationPickerVC alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"CHOOSE LOCATION";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [MSLocationCell registerToTableView:self.tableView];
    
    self.searchBar.delegate = self;
}

- (MSAutocompleteRequest *)autcompleteRequest
{
    if (!_autcompleteRequest)
    {
        _autcompleteRequest = [[MSAutocompleteRequest alloc] init];
        _autcompleteRequest.delegate = self;
    }
    
    return _autcompleteRequest;
}

#pragma mark UITableViewDataSoure

- (BOOL)hasMultipleSections
{
    return (self.searchText && [self.searchText length]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self hasMultipleSections]) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [MSLocationCell reusableIdentifier];
    MSLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if ([self hasMultipleSections]) {
        switch (indexPath.section) {
            case 0:
            {
                cell.textLabel.text = self.searchText;
                self.searchDisplayCell = cell;
                return cell;
            }
            
            case 1:
            {
                cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
                return cell;
            }
                
            default:
                return nil;
        }
    } else {
        cell.textLabel.text = self.searchText;
        return cell;
    }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSLocationCell *cell = (MSLocationCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [self.delegate didSelectLocation:cell.textLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self hasMultipleSections]) {
        switch (section) {
            case 1:
                return @"Suggestions";
                
            default:
                return nil;
        }
    } else {
        return @"Suggetions";
    }
}

#pragma mark UISearchBarDelegate

- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    self.searchDisplayCell.textLabel.text = searchText;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    BOOL oldMultiplesection = [self hasMultipleSections];
    self.searchText = searchText;
//    if (oldMultiplesection != [self hasMultipleSections]) {
//        [self.tableView reloadData];
//        
//    }
    [self.autcompleteRequest requestWithString:searchText andLocation:CGPointMake(45.77904,4.91574)];
    
}

#pragma mark MSAutocompleteRequestDelegate

- (void)autocompleteRequestDidFinishWithPredictions:(NSArray *)predictions
{
    self.data = predictions;
    [self.tableView reloadData];
}

@end
