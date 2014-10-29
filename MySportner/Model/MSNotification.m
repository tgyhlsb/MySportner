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


@end
