//
//  MSMessageCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 25/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSComment.h"

@interface MSMessageCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (strong, nonatomic) MSComment *comment;


+ (NSString *)reusableIdentifier;
+ (void)registerToTableView:(UITableView *)tableView;
+ (CGFloat)heightForComment:(MSComment *)comment;

@end
