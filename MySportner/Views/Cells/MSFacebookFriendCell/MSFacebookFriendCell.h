//
//  MSFacebookFriendCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 26/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFacebookFriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (NSString *)reusableIdentifier;
+ (CGFloat)height;
+ (void)registerToTableView:(UITableView *)tableView;

@end
