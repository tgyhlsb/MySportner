//
//  MSComment.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "MSSportner.h"
#import "MSActivity.h"

#define PARSE_CLASSNAME_COMMENT @"MSComment"

@interface MSComment : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) MSSportner *author;
@property (strong, nonatomic) MSActivity *activity;


//// Remove when not using Parse.com
//@property (strong, nonatomic) NSString *authorFacebookID;
//@property (strong, nonatomic) NSString *authorFullName;


- (NSComparisonResult)compareWithCreationDate:(MSComment *)otherComment;
//- (void)setAuthorForParse:(MSUser *)author;

+ (NSString *)parseClassName;

@end
