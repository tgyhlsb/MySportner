//
//  MSCommentCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 25/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSComment.h"
#import "MSCell.h"

@interface MSCommentCell : MSCell

@property (strong, nonatomic) MSComment *comment;

+ (NSString *)reusableIdentifier;
+ (void)registerToTableView:(UITableView *)tableView;

@end
