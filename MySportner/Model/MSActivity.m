//
//  MSActivity.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSActivity.h"
#import <Parse/PFObject+Subclass.h>
#import "TKAlertCenter.h"
#import "MSComment.h"

@interface MSActivity()

@end


@implementation MSActivity

@dynamic date;
@dynamic place;
@dynamic sport;
@dynamic level;
@dynamic maxPlayer;
@dynamic playerNeeded;
@dynamic whereExactly;
@dynamic nbComment;
@dynamic owner;


@synthesize guests = _guests;
@synthesize participants = _participants;
@synthesize awaitings = _awaitings;
@synthesize comments = _comments;


+ (NSString *)parseClassName
{
    return PARSE_CLASSNAME_ACTIVITY;
}

- (NSComparisonResult)compareWithCreationDate:(MSActivity *)otherActivity
{
    return [otherActivity.createdAt compare:self.createdAt];
}

- (void)setWithInfo:(NSDictionary *)activityInfo
{
    MSActivity *activity = [activityInfo objectForKey:@"activity"];
    
    self.date = activity.date;
    self.place = activity.place;
    self.sport = activity.sport;
    self.level = activity.level;
    self.maxPlayer = activity.maxPlayer;
    self.whereExactly = activity.whereExactly;
    self.playerNeeded = activity.playerNeeded;
    self.nbComment = activity.nbComment;
    self.owner = self.owner;
    
    self.awaitings = [activityInfo objectForKey:@"awaitingSportners"];
    self.guests = [activityInfo objectForKey:@"invitedSportners"];
    self.participants = [activityInfo objectForKey:@"confirmedSportners"];
    
    [self notifyActivityStateChanged];
}

- (void)fetchWithRelationAndBlock:(PFObjectResultBlock)block
{
    [PFCloud callFunctionInBackground:@"requestGameProfile"
                       withParameters:@{@"activity": self.objectId}
                                block:^(NSDictionary *result, NSError *error) {
                                    if (!error) {
                                        [self setWithInfo:result];
                                    }
                                    if (block) {
                                        block(self, error);
                                    }
                                }];
}

- (PFRelation *)guestRelation
{
    return [self relationForKey:@"guest"];
}

- (PFRelation *)participantRelation
{
    return [self relationForKey:@"participant"];
}

- (PFRelation *)awaitingRelation
{
    return [self relationForKey:@"awaiting"];
}

- (PFRelation *)commentRelation
{
    return [self relationForKey:@"comment"];
}

#pragma mark - Guests

- (void)fetchGuests
{
    PFQuery *query = [[self guestRelation] query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.guests = objects;
            [self notifyActivityStateChanged];
            [self notifyActivityInvitedChanged];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)addGuests:(NSArray *)guests withBlock:(PFObjectResultBlock)block
{
    NSMutableArray *tempIDs = [[NSMutableArray alloc] init];
    for (MSSportner *sportner in guests) {
        [tempIDs addObject:sportner.objectId];
    }
    
    [PFCloud callFunctionInBackground:@"inviteManySportner"
                       withParameters:@{@"activity": self.objectId, @"sportners": tempIDs}
                                block:^(NSDictionary *result, NSError *error) {
                                    if (!error) {
                                        [self setWithInfo:result];
                                    }
                                    
                                    if (block) {
                                        block(self, error);
                                    }
                                }];
}

#pragma mark - Participants

- (void)fetchParticipants
{
    PFQuery *query = [[self participantRelation] query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.participants = objects;
            [self notifyActivityStateChanged];
            [self notifyActivityConfirmedChanged];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

#pragma mark - Awaitings

- (void)fetchAwaitings
{
    PFQuery *query = [[self awaitingRelation] query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.awaitings = objects;
            [self notifyActivityStateChanged];
            [self notifyActivityAwaitingChanged];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

#pragma mark - Messages

- (void)fetchComments
{
    PFQuery *query = [[self commentRelation] query];
    [query includeKey:@"author"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.comments = objects;
            [self notifyActivityStateChanged];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)addComment:(MSComment *)comment withBlock:(PFBooleanResultBlock)block
{
    comment.activity = self;
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded && !error) {
            PFRelation *relation = [self commentRelation];
            [relation addObject:comment];
            NSMutableArray *tempComments = [self.comments mutableCopy];
            [tempComments addObject:comment];
            self.comments = tempComments;
            [self incrementKey:@"nbComment"];
            [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (block) {
                    block(succeeded, error);
                }
            }];
        } else {
            NSLog(@"Succeeded: %d", succeeded);
            NSLog(@"Error:\n%@", error);
            if (block) {
                block(succeeded, error);
            }            
        }
        
    }];
}

#pragma mark - Notifications


- (void)notifyActivityStateChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MSNotificationActivityStateChanged
                                                        object:self];
}

- (void)notifyActivityConfirmedChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MSNotificationActivityConfirmedChanged
                                                        object:self];
}

- (void)notifyActivityInvitedChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MSNotificationActivityInvitedChanged
                                                        object:self];
}

- (void)notifyActivityAwaitingChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MSNotificationActivityAwaitingChanged
                                                        object:self];
}

#pragma mark - Push notifications


@end
