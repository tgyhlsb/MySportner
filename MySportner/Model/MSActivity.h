//
//  MSActivity.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "MSUser.h"
#import "MSVenue.h"

@interface MSActivity : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) NSString *sport;

@property (strong, nonatomic) MSUser *owner;
@property (strong, nonatomic) NSArray *guests; // of MSUser
@property (strong, nonatomic) NSArray *participants;  // of MSUser


+ (NSString *)parseClassName;

@end
