//
//  MSLocationPickerCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSLocationPickerCell.h"
#import "MSLocationPickerVC.h"

#define IDENTIFIER @"MSLocationPickerCell"

@interface MSLocationPickerCell()

@end

@implementation MSLocationPickerCell

+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSLocationPickerCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [MSLocationPickerVC presentFromViewController:self.viewController];
    return NO;
}

@end
