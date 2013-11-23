//
//  MSDayPickerCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSDayPickerCell : UITableViewCell

- (void)initialize;

+ (void)registerToTableView:(UITableView *)tableView;
+ (NSString *)reusableIdentifier;
+ (CGFloat)height;

@end
