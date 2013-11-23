//
//  MSSetAGameVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSSetAGameVC.h"
#import "MSPickSportCell.h"
#import "MSTextFieldPickerCell.h"
#import "MSLocationPickerCell.h"

#define NIB_NAME @"MSSetAGameVC"

typedef NS_ENUM(int, MSSetAGameSection) {
    MSSetAGameSectionPickSport,
    MSSetAGameSectionTextField,
    MSSetAGameSectionSizePicker
};

typedef NS_ENUM(int, MSSetAGameTextFieldType) {
    MSSetAGameTextFieldTypeDay,
    MSSetAGameTextFieldTypeTime,
    MSSetAGameTextFieldTypeRepeat,
    MSSetAGameTextFieldTypeLocation
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
	
    [MSLocationPickerCell registerToTableView:self.tableView];
    [MSPickSportCell registerToTableView:self.tableView];
    [MSTextFieldPickerCell registerToTableView:self.tableView];
}

+ (MSSetAGameVC *)newController
{
    return [[MSSetAGameVC alloc] initWithNibName:NIB_NAME bundle:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case MSSetAGameSectionPickSport:
            return 1;
        case MSSetAGameSectionTextField:
            return 4;
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
            switch (indexPath.row) {
                case MSSetAGameTextFieldTypeDay:
                {
                    MSTextFieldPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSTextFieldPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"Day";
                    
                    return cell;
                }
                    
                case MSSetAGameTextFieldTypeTime:
                {
                    MSTextFieldPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSTextFieldPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"Time";
                    
                    return cell;
                }
                    
                case MSSetAGameTextFieldTypeRepeat:
                {
                    MSTextFieldPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSTextFieldPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"Repeat";
                    
                    return cell;
                }
                    
                case MSSetAGameTextFieldTypeLocation:
                {
                    MSLocationPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSLocationPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"Location";
                    
                    return cell;
                }
                    
                default:
                    return nil;
            }
        }
        case MSSetAGameSectionSizePicker:
        {
            
        }
            
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
            
        case MSSetAGameSectionTextField:
            return [MSTextFieldPickerCell height];
            
        default:
            return 44;
    }
}



@end
