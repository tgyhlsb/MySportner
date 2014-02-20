//
//  MSActivityCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSActivity.h"

@protocol MSActivityCellDelegate;

@interface MSActivityCell : UITableViewCell

@property (strong, nonatomic) id<MSActivityCellDelegate> delegate;

@property (strong, nonatomic) MSActivity *activity;

- (void)setAppearanceWithOddIndex:(BOOL)oddIndex;


+ (void)registerToTableview:(UITableView *)tableView;
+ (NSString *)reusableIdentifier;
+ (CGFloat)height;

@end

@protocol MSActivityCellDelegate <NSObject>

- (void)activityCell:(MSActivityCell *)cell didSelectSportner:(MSSportner *)sportner;

@end
