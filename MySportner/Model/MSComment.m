//
//  MSComment.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSComment.h"
#import <Parse/PFObject+Subclass.h>

@implementation MSComment

@dynamic author;
@dynamic content;

+ (NSString *)parseClassName
{
    return PARSE_CLASSNAME_COMMENT;
}

- (NSComparisonResult)compareWithCreationDate:(MSComment *)otherComment
{
    return [self.createdAt compare:otherComment.createdAt];
}


@end
