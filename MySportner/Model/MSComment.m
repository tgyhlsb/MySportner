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

@dynamic content;

+ (NSString *)parseClassName
{
    return PARSE_CLASSNAME_COMMENT;
}

- (void)setAuthor:(MSUser *)author
{
    self[@"author"] = author;
    self.authorFacebookID = author.facebookID;
    self.authorFullName = author.fullName;
}

- (MSUser *)author
{
    return self[@"author"];
}

@synthesize authorFacebookID = _authorFacebookID;
@synthesize authorFullName = _authorFullName;

- (void)setAuthorFacebookID:(NSString *)authorFacebookID
{
    _authorFacebookID = authorFacebookID;
}

- (void)setAuthorFullName:(NSString *)authorFullName
{
    _authorFullName = authorFullName;
}

@end
