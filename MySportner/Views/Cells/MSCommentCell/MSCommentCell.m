//
//  MSCommentCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 25/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSCommentCell.h"

#define NIB_NAME @"MSCommentCell"
#define HEIGHT 44

@interface MSCommentCell()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end;

@implementation MSCommentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (NSString *)reusableIdentifier
{
    return NIB_NAME;
}

+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:NIB_NAME bundle:Nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSCommentCell reusableIdentifier]];
}


// Override
+ (CGFloat)height
{
    return HEIGHT;
}

- (void)setComment:(MSComment *)comment
{
    _comment = comment;
    self.textLabel.text = comment.content;
}

@end
