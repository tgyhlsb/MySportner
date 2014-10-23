//
//  MSNotification.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSNotification.h"
#import <Parse/PFObject+Subclass.h>
#import "MSColorFactory.h"

static NSString *MSNotificationTypeInvitation = @"MSNotificationTypeInvitation";
static NSString *MSNotificationTypeAcceptedAwaiting = @"MSNotificationTypeAcceptedAwaiting";
static NSString *MSNotificationTypeJoined = @"MSNotificationTypeJoined";
static NSString *MSNotificationTypeAwaiting = @"MSNotificationTypeAwaiting";
static NSString *MSNotificationTypeAcceptedInvitation = @"MSNotificationTypeAcceptedInvitation";
static NSString *MSNotificationTypeLeft = @"MSNotificationTypeLeft";
static NSString *MSNotificationTypeComment = @"MSNotificationTypeComment";

@implementation MSNotification

@dynamic type;
@dynamic target;
@dynamic sportner;
@dynamic activity;

+ (NSString *)parseClassName
{
    return PARSE_CLASSNAME_NOTIFICATION;
}

- (NSComparisonResult)compareWithCreationDate:(MSNotification *)otherNotification
{
    return [otherNotification.createdAt compare:self.createdAt];
}

#pragma mark - Getters & Setters

- (NSAttributedString *)title
{
    UIFont *redFont = [UIFont fontWithName:@"ProximaNova-SemiBold" size:16.0];
    UIFont *grayFont = [UIFont fontWithName:@"ProximaNova-Light" size:16.0];
    NSDictionary *sportnerAttributes = @{
                                         NSFontAttributeName: redFont,
                                         NSForegroundColorAttributeName: [MSColorFactory redLight]
                                         };
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: grayFont,
                                     NSForegroundColorAttributeName: [MSColorFactory grayDark]
                                     };
    
    NSMutableAttributedString *sportnerName = [[NSMutableAttributedString alloc] initWithString:self.sportner.firstName
                                                                       attributes:sportnerAttributes];
    NSAttributedString *sportName = [[NSAttributedString alloc] initWithString:self.activity.sport.name
                                                                    attributes:sportnerAttributes];
    
    NSString *textString = nil;
    if ([self.type isEqualToString:MSNotificationTypeAcceptedAwaiting]) {
        textString = @" added you to ";
    } else if ([self.type isEqualToString:MSNotificationTypeAcceptedInvitation]) {
        textString = @" accepted to join ";
    } else if ([self.type isEqualToString:MSNotificationTypeAwaiting]) {
        textString = @" wants to join ";
    } else if ([self.type isEqualToString:MSNotificationTypeInvitation]) {
        textString = @" invited you to ";
    } else if ([self.type isEqualToString:MSNotificationTypeJoined]) {
        textString = @" joined ";
    } else if ([self.type isEqualToString:MSNotificationTypeLeft]) {
        textString = @" left ";
    } else if ([self.type isEqualToString:MSNotificationTypeComment]) {
        textString = @" commented ";
    }
    NSAttributedString *textAttributedString = [[NSAttributedString alloc] initWithString:textString
                                                                               attributes:textAttributes];
    [sportnerName appendAttributedString:textAttributedString];
    [sportnerName appendAttributedString:sportName];
    return sportnerName;
}

- (NSAttributedString *)subtitle
{
    return nil;
}

@end
