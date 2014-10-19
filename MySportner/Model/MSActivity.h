//
//  MSActivity.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "MSSportner.h"
#import "MSVenue.h"
#import "MSComment.h"
#import "MSSport.h"

#define PARSE_CLASSNAME_ACTIVITY @"MSActivity"

static NSString *MSNotificationActivityStateChanged = @"MSNotificationActivityStateChanged";

@interface MSActivity : PFObject <PFSubclassing>

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) MSSport *sport;
@property (strong, nonatomic) NSNumber *level;
@property (strong, nonatomic) NSNumber *maxPlayer;
@property (strong, nonatomic) NSString *whereExactly;
@property (strong, nonatomic) NSNumber *playerNeeded;
@property (strong, nonatomic) NSNumber *nbComment;

@property (strong, nonatomic) MSSportner *owner;
@property (strong, nonatomic) NSArray *guests;
@property (strong, nonatomic) NSArray *participants;
@property (strong, nonatomic) NSArray *awaitings;

@property (strong, nonatomic) NSArray *comments;


- (PFRelation *)guestRelation;
- (PFRelation *)participantRelation;
- (PFRelation *)awaitingRelation;
- (PFRelation *)commentRelation;

- (void)fetchGuests;
- (void)addGuest:(MSSportner *)guest WithTarget:(id)target callBack:(SEL)callBack;
- (void)removeGuest:(MSSportner *)guest WithTarget:(id)target callBack:(SEL)callBack;

- (void)fetchParticipants;
- (void)addParticipant:(MSSportner *)participant WithTarget:(id)target callBack:(SEL)callBack;
- (void)removeParticipant:(MSSportner *)participant WithTarget:(id)target callBack:(SEL)callBack;

- (void)fetchAwaitings;
- (void)addAwaiting:(MSSportner *)awaiting WithTarget:(id)target callBack:(SEL)callBack;
- (void)removeAwaiting:(MSSportner *)awaiting WithTarget:(id)target callBack:(SEL)callBack;

//- (void)querySportnersWithTarget:(id)target callBack:(SEL)callBack;
//- (void)queryOtherSportnersWithTarger:(id)target callBack:(SEL)callback;

+ (NSString *)parseClassName;

- (NSComparisonResult)compareWithCreationDate:(MSActivity *)otherActivity;

- (void)fetchComments;
- (void)addComment:(MSComment *)comment withTarget:(id)target callBack:(SEL)callBack;

@end
