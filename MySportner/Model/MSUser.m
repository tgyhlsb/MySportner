//
//  MSUser.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSUser.h"

@implementation MSUser

- (id)initWithFacebookInfo:(id<FBGraphUser>)userInfo
{
    self = [super init];
    if (self) {
        [self setWithFacebookInfo:userInfo];
    }
    return self;
}

- (void)setWithFacebookInfo:(id<FBGraphUser>)userInfo
{
    _facebookID = userInfo.id;
    _firstName = userInfo.first_name;
    _lastName = userInfo.last_name;
}

#pragma mark Shared Instances

+ (MSUser *)sharedUser
{
    static MSUser *SharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!SharedUser) {
            SharedUser = [[MSUser alloc] init];
        } else {
            NSLog(@"/!\\ Did not unarchive user.");
        }
        
    });
    return SharedUser;
}

+ (void)logInWithFacebookInfo:(id<FBGraphUser>)userInfo
{
    [[MSUser sharedUser] setWithFacebookInfo:userInfo];
}

+ (void)logOut
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

@end
