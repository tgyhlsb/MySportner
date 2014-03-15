//
//  MSSportLevel.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 15/03/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSSportLevel.h"
#import <Parse/PFObject+Subclass.h>

@implementation MSSportLevel

@dynamic sport;
@dynamic level;
@dynamic sportner;

+ (NSString *)parseClassName
{
    return PARSE_CLASSNAME_SPORTLEVEL;
}

- (id)initWithSport:(MSSport *)sport sportner:(MSSportner *)sportner
{
    self = [super init];
    if (self) {
        self.sport = sport;
        self.level = nil;
        self.sportner = sportner;
    }
    return self;
}

@end
