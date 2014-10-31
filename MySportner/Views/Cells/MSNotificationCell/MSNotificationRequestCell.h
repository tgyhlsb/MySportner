//
//  MSNotificationRequestCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSNotificationCell.h"

@protocol MSNotificationRequestCellDelegate;

@interface MSNotificationRequestCell : MSNotificationCell

@property (weak, nonatomic) id<MSNotificationRequestCellDelegate> delegate;

@end

@protocol MSNotificationRequestCellDelegate <NSObject>

- (void)notificationRequestCellDidTapAccept:(MSNotificationRequestCell *)cell;
- (void)notificationRequestCellDidTapDecline:(MSNotificationRequestCell *)cell;

@end
