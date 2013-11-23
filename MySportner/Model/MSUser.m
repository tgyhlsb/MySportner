//
//  MSUser.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSUser.h"

@implementation MSUser

#pragma mark Shared Instances

+ (AFIUser *)sharedUser
{
    static AFIUser *SharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!SharedUser) {
            SharedUser = [AFIUser unArchive];
            SharedUser.isCalling = NO;
            SharedUser.isAuthentified = NO;
        } else {
            NSLog(@"/!\\ Did not unarchive user.");
        }
        
    });
    return SharedUser;
}

@end
