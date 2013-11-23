//
//  MSActivitiesVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 22/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSActivitiesVC.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "MSactivity.h"
#import "MSActivityCell.h"
#import "MSActivitiesFilterCell.h"
#import "MSActivityVC.h"

#define NIB_NAME @"MSActivitiesVC"

@interface MSActivitiesVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *data;

@end

@implementation MSActivitiesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [MSActivityCell registerToTableview:self.tableView];
    [MSActivitiesFilterCell registerToTableView:self.tableView];
    
    [self generateSampleData];
}

- (void)generateSampleData
{
    NSMutableArray *tempData = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++)
    {
        MSActivity *activity = [[MSActivity alloc] init];
        activity.title = @"Tennis Match";
        activity.place = @"Paris, France";
        [tempData addObject:activity];
    }
    self.data = tempData;
    [self reloadData];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

+ (MSActivitiesVC *)newController
{
    return [[MSActivitiesVC alloc] initWithNibName:NIB_NAME bundle:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return [self.data count];
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            NSString *identifier = [MSActivitiesFilterCell reusableIdentifier];
            MSActivitiesFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            
            
            
            return cell;
        }
            
        default:
        {
            NSString *identifier = [MSActivityCell reusableIdentifier];
            MSActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            
            MSActivity *activity = [self.data objectAtIndex:indexPath.row];
            
            cell.titleLabel.text = activity.title;
            cell.placeLabel.text = activity.place;
            return cell;
        }
    }
    
}

#pragma mark UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [MSActivitiesFilterCell height];
        case 1:
            return [MSActivityCell height];
            
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MSActivityVC *destinationVC = [MSActivityVC newController];
    
    [self.navigationController pushViewController:destinationVC animated:YES];
}

@end
