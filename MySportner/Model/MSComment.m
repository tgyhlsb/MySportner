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

- (void)setAuthorForParse:(MSUser *)author
{
    self.author = author;
    self.authorFacebookID = author.facebookID;
    self.authorFullName = author.fullName;
}

@synthesize authorFullName = _authorFullName;
@synthesize authorFacebookID = _authorFacebookID;

- (void)setAuthorFullName:(NSString *)authorFullName
{
    _authorFullName = authorFullName;
}

- (NSString *)authorFullName
{
    return _authorFullName;
}

- (void)setAuthorFacebookID:(NSString *)authorFacebookID
{
    _authorFacebookID = authorFacebookID;
}

- (NSString *)authorFacebookID
{
    return _authorFacebookID;
}

- (NSComparisonResult)compareWithCreationDate:(MSComment *)otherComment
{
    return [self.createdAt compare:otherComment.createdAt];
}


@end
