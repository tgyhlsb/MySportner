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
#import "MSComment.h"
#import "MSChat.h"

#define PARSE_CLASSNAME_ACTIVITY @"MSActivity"

@interface MSActivity : PFObject <PFSubclassing>

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) NSString *sport;

@property (strong, nonatomic) MSUser *owner;
@property (strong, nonatomic) NSArray *guests; // of MSUser
@property (strong, nonatomic) NSArray *participants;  // of MSUser

@property (strong, nonatomic) MSChat *chat;


- (PFRelation *)guestRelation;
- (PFRelation *)participantRelation;

- (void)querySportnersWithTarget:(id)target callBack:(SEL)callBack;
- (void)queryOtherParticipantsWithTarger:(id)target callBack:(SEL)callback;

+ (NSString *)parseClassName;

- (NSComparisonResult)compareWithCreationDate:(MSActivity *)otherActivity;

- (void)requestMessagesWithTarget:(id)target callBack:(SEL)callback;
- (void)addComment:(MSComment *)comment;
- (NSArray *)getComments;

@end
