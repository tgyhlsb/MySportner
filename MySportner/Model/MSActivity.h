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
static NSString *MSNotificationActivityConfirmedChanged = @"MSNotificationActivityConfirmedChanged";
static NSString *MSNotificationActivityInvitedChanged = @"MSNotificationActivityInvitedChanged";
static NSString *MSNotificationActivityAwaitingChanged = @"MSNotificationActivityAwaitingChanged";

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
- (void)addGuest:(MSSportner *)guest withBlock:(PFBooleanResultBlock)block;
- (void)addGuests:(NSArray *)guests withBlock:(PFBooleanResultBlock)block;
- (void)removeGuest:(MSSportner *)guest withBlock:(PFBooleanResultBlock)block;

- (void)fetchParticipants;
- (void)addParticipant:(MSSportner *)participant withBlock:(PFBooleanResultBlock)block;
- (void)addParticipants:(NSArray *)participants withBlock:(PFBooleanResultBlock)block;
- (void)removeParticipant:(MSSportner *)participant withBlock:(PFBooleanResultBlock)block;

- (void)fetchAwaitings;
- (void)addAwaiting:(MSSportner *)awaiting withBlock:(PFBooleanResultBlock)block;
- (void)removeAwaiting:(MSSportner *)awaiting withBlock:(PFBooleanResultBlock)block;

+ (NSString *)parseClassName;

- (NSComparisonResult)compareWithCreationDate:(MSActivity *)otherActivity;

- (void)fetchComments;
- (void)addComment:(MSComment *)comment withBlock:(PFBooleanResultBlock)block;

@end
