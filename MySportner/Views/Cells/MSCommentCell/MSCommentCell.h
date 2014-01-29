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

@protocol MSCommentCellDelegate;

@interface MSCommentCell : MSCell

@property (weak, nonatomic) id<MSCommentCellDelegate> delegate;

@property (strong, nonatomic) MSComment *comment;

+ (NSString *)reusableIdentifierForCommentText:(NSString *)commentText;
+ (CGFloat)heightForCommentText:(NSString *)comment;
+ (void)registerToTableView:(UITableView *)tableView;

@end

@protocol MSCommentCellDelegate <NSObject>

- (void)commentCell:(MSCommentCell *)cell didSelectUser:(MSUser *)user;

@end
