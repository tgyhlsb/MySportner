//
//  MSDayPickerCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTextFieldPickerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (void)initialize;

+ (void)registerToTableView:(UITableView *)tableView;
+ (NSString *)reusableIdentifier;
+ (CGFloat)height;

@end
