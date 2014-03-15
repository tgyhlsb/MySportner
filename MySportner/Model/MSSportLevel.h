//
//  MSSportLevel.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 15/03/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Parse/Parse.h>
#import "MSSportner.h"
#import "MSSport.h"

#define PARSE_CLASSNAME_SPORTLEVEL @"MSSportLevel"

@class MSSportner;

@interface MSSportLevel : PFObject <PFSubclassing>

@property (strong, nonatomic) MSSport *sport;
@property (strong, nonatomic) NSNumber *level;
@property (strong, nonatomic) MSSportner *sportner;

- (id)initWithSport:(MSSport *)sport sportner:(MSSportner *)sportner;

@end
