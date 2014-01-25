//
//  MSActivityCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MSActivity.h"

@interface MSActivityCell : UITableViewCell

@property (strong, nonatomic) MSActivity *activity;

- (void)setAppearanceWithOddIndex:(BOOL)oddIndex;


+ (void)registerToTableview:(UITableView *)tableView;
+ (NSString *)reusableIdentifier;
+ (CGFloat)height;

@end
