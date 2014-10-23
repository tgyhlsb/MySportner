//
//  MSNotification.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Parse/Parse.h>

#import "MSSportner.h"
#import "MSActivity.h"

#define PARSE_CLASSNAME_NOTIFICATION @"MSNotification"

@interface MSNotification : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) MSSportner *target;
@property (strong, nonatomic) MSActivity *activity;

+ (NSString *)parseClassName;

- (NSComparisonResult)compareWithCreationDate:(MSNotification *)otherNotification;

@end
