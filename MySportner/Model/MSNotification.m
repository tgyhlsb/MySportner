//
//  MSNotification.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSNotification.h"
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "MSColorFactory.h"

@implementation MSNotification

@dynamic type;
@dynamic target;
@dynamic sportner;
@dynamic activity;
@dynamic expired;

+ (NSString *)parseClassName
{
    return PARSE_CLASSNAME_NOTIFICATION;
}

- (NSComparisonResult)compareWithCreationDate:(MSNotification *)otherNotification
{
    return [otherNotification.createdAt compare:self.createdAt];
}

#pragma mark - Getters & Setters

- (BOOL)isExpired
{
    return [self.expired boolValue];
}

- (void)setExpired
{
    self.expired = [NSNumber numberWithBool:YES];
}

- (void)copyFromNotification:(MSNotification *)notification
{
    self.expired = notification.expired;
}

#pragma mark - Request

- (void)acceptWithBlock:(PFObjectResultBlock)block
{
    [self respondToRequestWithBlock:block accepted:YES];
}

- (void)declineWithBlock:(PFObjectResultBlock)block
{
    [self respondToRequestWithBlock:block accepted:NO];
}

- (void)respondToRequestWithBlock:(PFObjectResultBlock)block accepted:(BOOL)accepted
{
    [PFCloud callFunctionInBackground:@"respondToNotificationRequest"
                       withParameters:@{@"notification": self.objectId, @"accepted": [NSNumber numberWithBool:accepted]}
                                block:^(MSNotification *result, NSError *error) {
                                    if (!error) {
                                        [self copyFromNotification:result];
                                    }
                                    
                                    if (block) {
                                        block(self, error);
                                    }
                                }];
}

@end
