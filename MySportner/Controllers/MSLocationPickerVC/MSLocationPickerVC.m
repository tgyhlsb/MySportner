//
//  MSLocationPickerVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 31/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSLocationPickerVC.h"
#import "MSLocationCell.h"

@interface MSLocationPickerVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
}

#pragma mark UITableViewDataSoure

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
    NSString *identifier = [MSLocationCell reusableIdentifier];
    MSLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"Lyon, France";
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSLocationCell *cell = (MSLocationCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [self.delegate didSelectLocation:cell.textLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
