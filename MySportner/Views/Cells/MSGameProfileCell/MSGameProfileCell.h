//
//  MSGameProfileCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 07/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSActivity.h"

@interface MSGameProfileCell : UITableViewCell

@property (strong, nonatomic) MSActivity *activity;

+ (void)registerToTableView:(UITableView *)tableView;
+ (NSString *)reusableIdentifier;
+ (CGFloat)height;

@end
