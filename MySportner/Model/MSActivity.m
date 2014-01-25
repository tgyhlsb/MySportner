//
//  MSActivity.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSActivity.h"
#import <Parse/PFObject+Subclass.h>


@implementation MSActivity

@dynamic date;
@dynamic day;
@dynamic time;
@dynamic place;
@dynamic sport;

@dynamic owner;
@dynamic guests;
@dynamic participants;
@dynamic comments;

+ (NSString *)parseClassName
{
    return PARSE_CLASSNAME_ACTIVITY;
}

- (NSComparisonResult)compareWithCreationDate:(MSActivity *)otherActivity
{
    return [otherActivity.createdAt compare:self.createdAt];
}

- (void)addComment:(MSComment *)comment
{
    if (!self.comments) self.comments = [[NSArray alloc] init];
    
    NSMutableArray *tempComments = [self.comments mutableCopy];
    [tempComments addObject:comment];
    
    self.comments = [tempComments sortedArrayUsingSelector:@selector(compareWithCreationDate:)];
    [comment saveInBackground];
    [self saveInBackground];
}

@end
