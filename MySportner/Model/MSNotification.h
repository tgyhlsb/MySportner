//
//  MSNotification.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Parse/Parse.h>

#import "MSSportner.h"
#import "MSActivity.h"

#define PARSE_CLASSNAME_NOTIFICATION @"MSNotification"

static NSString *MSNotificationTypeInvitation = @"MSNotificationTypeInvitation";
static NSString *MSNotificationTypeAcceptedAwaiting = @"MSNotificationTypeAcceptedAwaiting";
static NSString *MSNotificationTypeJoined = @"MSNotificationTypeJoined";
static NSString *MSNotificationTypeAwaiting = @"MSNotificationTypeAwaiting";
static NSString *MSNotificationTypeAcceptedInvitation = @"MSNotificationTypeAcceptedInvitation";
static NSString *MSNotificationTypeLeft = @"MSNotificationTypeLeft";
static NSString *MSNotificationTypeComment = @"MSNotificationTypeComment";
static NSString *MSNotificationTypeDeclinedAwaiting = @"MSNotificationTypeDeclinedAwaiting";
static NSString *MSNotificationTypeDeclinedInvitation = @"MSNotificationTypeDeclinedInvitation";

@interface MSNotification : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) MSSportner *target;
@property (strong, nonatomic) MSSportner *sportner;
@property (strong, nonatomic) MSActivity *activity;
@property (strong, nonatomic) NSNumber *expired;

+ (NSString *)parseClassName;

- (NSComparisonResult)compareWithCreationDate:(MSNotification *)otherNotification;


- (BOOL)isExpired;
- (void)setExpired;


- (void)acceptWithBlock:(PFObjectResultBlock)block;
- (void)declineWithBlock:(PFObjectResultBlock)block;

@end
