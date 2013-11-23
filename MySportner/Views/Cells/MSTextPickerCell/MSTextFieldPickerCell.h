//
//  MSDayPickerCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTextFieldPickerCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) UIViewController *viewController;

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (void)initializeWithViewcontroller:(UIViewController *)viewController;

+ (void)registerToTableView:(UITableView *)tableView;
+ (NSString *)reusableIdentifier;
+ (CGFloat)height;

@end
