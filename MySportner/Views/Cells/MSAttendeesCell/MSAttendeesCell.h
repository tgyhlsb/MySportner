//
//  MSAttendeesCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSAttendeesCell : UITableViewCell


+ (NSString *)reusableIdentifier;
+ (void)registerToTableView:(UITableView *)tableView;
+ (CGFloat)height;

@end
