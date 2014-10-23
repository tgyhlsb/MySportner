//
//  MSNotificationCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSNotification.h"

@interface MSNotificationCell : UITableViewCell

@property (strong, nonatomic) MSNotification *notification;


+ (void)registerToTableview:(UITableView *)tableView;

+ (NSString *)reusableIdentifier;

@end
