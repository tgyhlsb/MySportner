//
//  MSDayPickerCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSTextFieldPickerCell.h"
#import "MSColorFactory.h"
#import "UITextField+MSTextFieldAppearance.h"

#define IDENTIFIER @"MSTextFieldPickerCell"
#define HEIGHT 60

@interface MSTextFieldPickerCell()

@end

@implementation MSTextFieldPickerCell

- (void)initializeWithViewcontroller:(UIViewController *)viewController
{
    self.textField.delegate = self;
    self.viewController = viewController;
    
    UIColor *focusBorderColor = [MSColorFactory redLight];
    UIColor *textFieldTextColor = [MSColorFactory redLight];
    
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.delegate = self;
    self.textField.focusBorderColor = focusBorderColor;
    self.textField.textColor = textFieldTextColor;
    [self.textField initializeAppearanceWithShadow:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // no nothing
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    // do nothing
}

+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSTextFieldPickerCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

+ (CGFloat)height
{
    return HEIGHT;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

@end
