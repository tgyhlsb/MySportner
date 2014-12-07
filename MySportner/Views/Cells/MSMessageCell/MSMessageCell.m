//
//  MSMessageCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 25/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSMessageCell.h"
#import "UIView+MSRoundedView.h"

#import "MSProfilePictureView.h"

#import "MSColorFactory.h"

#define NIB_NAME @"MSMessageCell"

@interface MSMessageCell()

@property (weak, nonatomic) IBOutlet MSProfilePictureView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation MSMessageCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.profilePicture setRounded];
    
    self.timeLabel.font = [UIFont fontWithName:@"ProximaNova-SemiBold" size:13.0];
    self.timeLabel.textColor = [UIColor colorWithRed:0.31f green:0.36f blue:0.40f alpha:0.40f];
}


#pragma mark - Getters & Setters

- (void)setComment:(MSComment *)comment
{
    _comment = comment;
    
    self.contentLabel.attributedText = [self contentForComment:comment];
    self.profilePicture.sportner = comment.author;
    self.timeLabel.text = [self stringTimeForNotification:comment.createdAt ? comment.createdAt : [NSDate date]];
    
}

#pragma mark - Helpers

- (NSAttributedString *)contentForComment:(MSComment *)comment
{
    UIFont *redFont = [UIFont fontWithName:@"ProximaNova-SemiBold" size:16.0];
    UIFont *grayFont = [UIFont fontWithName:@"ProximaNova-Regular" size:16.0];
    NSDictionary *authorAttributes = @{
                                         NSFontAttributeName: redFont,
                                         NSForegroundColorAttributeName: [MSColorFactory redLight]
                                         };
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: grayFont,
                                     NSForegroundColorAttributeName: [MSColorFactory gray]
                                     };
    NSString *sportnerName = comment.author ? comment.author.firstName : @"Unknown";
    NSMutableAttributedString *authorAttributedName = [[NSMutableAttributedString alloc] initWithString:sportnerName
                                                                                               attributes:authorAttributes];

    NSString *textSring = [NSString stringWithFormat:@" %@", comment.content];
    NSAttributedString *textAttributedString = [[NSAttributedString alloc] initWithString:textSring
                                                                               attributes:textAttributes];
    [authorAttributedName appendAttributedString:textAttributedString];
    return authorAttributedName;
}

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

@end
