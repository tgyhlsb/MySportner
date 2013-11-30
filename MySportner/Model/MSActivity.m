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

@dynamic day;
@dynamic time;
@dynamic place;
@dynamic sport;

@dynamic owner;
@dynamic guests;
@dynamic participants;

+ (NSString *)parseClassName
{
    return PARSE_CLASSNAME_ACTIVITY;
}

@end
