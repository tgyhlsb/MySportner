//
//  MSNotificationCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSNotificationCell.h"
#import "MSProfilePictureView.h"
#import "UIView+MSRoundedView.h"
#import "MSColorFactory.h"

#define IDENTIFIER @"MSNotificationCell"
#define HEIGHT 75.0

@interface MSNotificationCell()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet MSProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MSNotificationCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.profilePictureView setRounded];
    
    self.timeLabel.font = [UIFont fontWithName:@"ProximaNova-SemiBold" size:10.0];
    self.timeLabel.textColor = [UIColor colorWithRed:0.31f green:0.36f blue:0.40f alpha:0.40f];
}

- (void)setNotification:(MSNotification *)notification
{
    _notification = notification;
    
    self.messageLabel.attributedText = [self titleForNotification:notification];
    self.profilePictureView.sportner = notification.sportner;
    self.timeLabel.text = [self stringTimeForNotification:notification];
}

#pragma mark - Helpers

- (NSAttributedString *)titleForNotification:(MSNotification *)notification
{
    UIFont *redFont = [UIFont fontWithName:@"ProximaNova-SemiBold" size:14.0];
    UIFont *grayFont = [UIFont fontWithName:@"ProximaNova-SemiBold" size:14.0];
    NSDictionary *sportnerAttributes = @{
                                         NSFontAttributeName: redFont,
                                         NSForegroundColorAttributeName: [MSColorFactory redLight]
                                         };
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: grayFont,
                                     NSForegroundColorAttributeName: [MSColorFactory gray]
                                     };
    NSString *sportnerName = notification.sportner ? notification.sportner.firstName : @"Unknown";
    NSMutableAttributedString *sportnerAttributedName = [[NSMutableAttributedString alloc] initWithString:sportnerName
                                                                                               attributes:sportnerAttributes];
    
    NSString *sportName = notification.activity ? notification.activity.sport ? notification.activity.sport.name : @"unknown" : @"unknown";
    NSAttributedString *sportAttributedName = [[NSAttributedString alloc] initWithString:sportName
                                                                              attributes:sportnerAttributes];
    
    NSString *textString = nil;
    if ([notification.type isEqualToString:MSNotificationTypeAcceptedAwaiting]) {
        textString = @" added you to ";
    } else if ([notification.type isEqualToString:MSNotificationTypeAcceptedInvitation]) {
        textString = @" accepted to join ";
    } else if ([notification.type isEqualToString:MSNotificationTypeAwaiting]) {
        textString = @" wants to join ";
    } else if ([notification.type isEqualToString:MSNotificationTypeInvitation]) {
        textString = @" invited you to ";
    } else if ([notification.type isEqualToString:MSNotificationTypeJoined]) {
        textString = @" joined ";
    } else if ([notification.type isEqualToString:MSNotificationTypeLeft]) {
        textString = @" left ";
    } else if ([notification.type isEqualToString:MSNotificationTypeComment]) {
        textString = @" commented ";
    }
    NSAttributedString *textAttributedString = [[NSAttributedString alloc] initWithString:textString
                                                                               attributes:textAttributes];
    [sportnerAttributedName appendAttributedString:textAttributedString];
    [sportnerAttributedName appendAttributedString:sportAttributedName];
    return sportnerAttributedName;
}

- (NSString *)stringTimeForNotification:(MSNotification *)notification
{
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:notification.createdAt];
    
    NSString *pattern = nil;
    NSTimeInterval value = 0;
    if (time < 60) {
        return @"Less than a minute ago";
    } else if (time < 60*60) {
        value = floor(time/60);
        pattern = value > 1 ? @"%d minutes ago" : @"%d minute ago";
    } else if (time < 60*60*24) {
        value = floor(time/(60*60));
        pattern = value > 1 ? @"%d hours ago" : @"%d hour ago";
    } else if (time < 60*60*24*7) {
        value = floor(time/(60*60*24));
        pattern = value > 1 ? @"%d days ago" : @"%d day ago";
    } else if (time < 60*60*24*7) {
        return @"Last week";
    } else {
        NSDateFormatter* timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setTimeStyle:NSDateFormatterShortStyle];
        return [timeFormat stringFromDate:notification.createdAt];
    }
    
    return [NSString stringWithFormat:pattern, value];
}


#pragma - Overrides 

+ (void)registerToTableview:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSNotificationCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

+ (CGFloat)height
{
    return HEIGHT;
}

@end
