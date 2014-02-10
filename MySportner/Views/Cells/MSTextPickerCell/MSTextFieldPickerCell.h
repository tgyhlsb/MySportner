//
//  MSDayPickerCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSTextField.h"

typedef NS_ENUM(NSUInteger, MSTextFieldType) {
    MSTextFieldTypeDate,
    MSTextFieldTypeRepeat,
    MSTextFieldTypeLocation
};

@interface MSTextFieldPickerCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) UIViewController *viewController;
@property (nonatomic) MSTextFieldType type;

@property (weak, nonatomic) IBOutlet MSTextField *textField;

- (void)initializeWithViewcontroller:(UIViewController<UITextFieldDelegate> *)viewController;

+ (void)registerToTableView:(UITableView *)tableView;
+ (NSString *)reusableIdentifier;
+ (CGFloat)height;

@end
