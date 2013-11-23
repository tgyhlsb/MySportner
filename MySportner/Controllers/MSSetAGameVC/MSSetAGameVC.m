//
//  MSSetAGameVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSSetAGameVC.h"
#import "MSPickSportCell.h"

#define NIB_NAME @"MSSetAGameVC"

typedef NS_ENUM(int, MSSetAGameSection) {
    MSSetAGameSectionPickSport,
    MSSetAGameSectionTextField,
    MSSetAGameSectionSizePicker
};

@interface MSSetAGameVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MSSetAGameVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
	
    [MSPickSportCell registerToTableView:self.tableView];
}

+ (MSSetAGameVC *)newController
{
    return [[MSSetAGameVC alloc] initWithNibName:NIB_NAME bundle:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case MSSetAGameSectionPickSport:
            return 1;
        case MSSetAGameSectionTextField:
            return 0;
        case MSSetAGameSectionSizePicker:
            return 0;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case MSSetAGameSectionPickSport:
        {
            MSPickSportCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSPickSportCell reusableIdentifier] forIndexPath:indexPath];
            
            [cell initialize];
            
            return cell;
        }
        case MSSetAGameSectionTextField:
        {
            
        }
        case MSSetAGameSectionSizePicker:
        {
            
        }
            
        default:
            return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case MSSetAGameSectionPickSport:
            return @"PICK A SPORT";
            
        default:
            return nil;
    }
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case MSSetAGameSectionPickSport:
            return [MSPickSportCell height];
            
        default:
            return 44;
    }
}



@end
