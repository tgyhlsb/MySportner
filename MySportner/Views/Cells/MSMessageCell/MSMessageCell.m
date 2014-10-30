//
//  MSMessageCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 25/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSMessageCell.h"

#import "MSProfilePictureView.h"

#define NIB_NAME @"MSMessageCell"

@interface MSMessageCell()

@property (weak, nonatomic) IBOutlet MSProfilePictureView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation MSMessageCell


#pragma mark - Getters & Setters

- (void)setComment:(MSComment *)comment
{
    _comment = comment;
    
    self.contentLabel.text = comment.content;
    self.profilePicture.sportner = comment.author;
    self.timeLabel.text = [self stringTimeForNotification:comment.createdAt];
    
}

#pragma mark - Helpers

- (NSString *)stringTimeForNotification:(NSDate *)date
{
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:date];
    
    NSString *pattern = nil;
    NSTimeInterval value = 0;
    if (time < 60) {
        return @"Less than a minute ago";
    } else if (time < 60*60) {
        value = floor(time/60);
        pattern = value > 1 ? @"%.0f minutes ago" : @"%.0f minute ago";
    } else if (time < 60*60*24) {
        value = floor(time/(60*60));
        pattern = value > 1 ? @"%.0f hours ago" : @"%.0f hour ago";
    } else if (time < 60*60*24*7) {
        value = floor(time/(60*60*24));
        pattern = value > 1 ? @"%.0f days ago" : @"%.0f day ago";
    } else if (time < 60*60*24*7*2) {
        return @"Last week";
    } else {
        NSDateFormatter* timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setTimeStyle:NSDateFormatterShortStyle];
        return [timeFormat stringFromDate:date];
    }
    
    return [NSString stringWithFormat:pattern, value];
}

#pragma mark - Overrides

+ (NSString *)reusableIdentifier
{
    return NIB_NAME;
}

+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:NIB_NAME bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSMessageCell reusableIdentifier]];
}

+ (CGFloat)heightForComment:(MSComment *)comment
{
    return 44.0;
}

@end
