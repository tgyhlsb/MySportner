//
//  MSAttendeesCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSActivity.h"

@protocol MSAttendeesCellDelegate;

@interface MSAttendeesCell : UITableViewCell

@property (weak, nonatomic) id<MSAttendeesCellDelegate> delegate;
@property (strong, nonatomic) MSActivity *activity;


+ (NSString *)reusableIdentifier;
+ (void)registerToTableView:(UITableView *)tableView;
+ (CGFloat)height;

- (void)updateUI;

@end


@protocol MSAttendeesCellDelegate <NSObject>

- (void)attendeesCell:(MSAttendeesCell *)cell didSelectSportner:(MSSportner *)sportner;

@end