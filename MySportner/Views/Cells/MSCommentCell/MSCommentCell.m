//
//  MSCommentCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 25/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSCommentCell.h"
#import "MSColorFactory.h"
#import "MSProfilePictureView.h"
#import "UIView+MSRoundedView.h"
#import "MSStyleFactory.h"

#define NIB_NAME @"MSCommentCell"
#define HEIGHT 80

@interface MSCommentCell()

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet MSProfilePictureView *profilePictureView;

@end;

@implementation MSCommentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [MSColorFactory backgroundColorGrayLight];
    [self.profilePictureView setRounded];
    
    [MSStyleFactory setUILabel:self.authorLabel withStyle:MSLabelStyleCommentAuthor];
    [MSStyleFactory setUILabel:self.contentLabel withStyle:MSLabelStyleCommentText];
    [MSStyleFactory setUILabel:self.timeLabel withStyle:MSLabelStyleCommentTime];
    
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 0;
    
    [self registerTapGestures];
}

- (void)registerTapGestures
{
    UITapGestureRecognizer *pictureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorProfileTapHandler)];
    self.profilePictureView.userInteractionEnabled = YES;
    [self.profilePictureView addGestureRecognizer:pictureTap];
}

- (void)authorProfileTapHandler
{
    if ([self.delegate respondsToSelector:@selector(commentCell:didSelectUser:)]) {
        [self.delegate commentCell:self didSelectUser:self.comment.author];
    }
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
    self.authorLabel.text = [comment.author fullName];
    self.contentLabel.text = comment.content;
    self.timeLabel.text = [self timeTextForCommentTime:comment.createdAt];
    self.profilePictureView.user = comment.author;
}

- (NSString *)timeTextForCommentTime:(NSDate *)commentDate
{
    NSTimeInterval diffSecond =  - [commentDate timeIntervalSinceNow];
    if (diffSecond < 60) {
        return [NSString stringWithFormat:@"%ld sec ago", (long)diffSecond];
    } else if (diffSecond < 3600) {
        NSInteger minutes = floor(diffSecond/60);
        return [NSString stringWithFormat:@"%ld min ago", (long)minutes];
    } else if (diffSecond < 3600 * 24) {
        NSInteger hours = floor(diffSecond/3600);
        return [NSString stringWithFormat:(hours > 1) ? @"%ld hours ago" : @"%ld hour ago", (long)hours];
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        [dateFormat setDateFormat:@"MMMM dd"];
        return [dateFormat stringFromDate:commentDate];
    }
}

@end
