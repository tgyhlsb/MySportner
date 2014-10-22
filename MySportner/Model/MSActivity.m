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
@dynamic day;
@dynamic time;
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

- (void)addGuests:(NSArray *)sportners
{
    NSMutableArray *tempGuests = [self.guests mutableCopy];
    [tempGuests addObjectsFromArray:sportners];
    self.guests = tempGuests;
}

- (void)removeInvited:(MSSportner *)invited
{
    NSMutableArray *tempInvited = [self.guests mutableCopy];
    [tempInvited removeObject:invited];
    self.guests = tempInvited;
}

- (void)addGuests:(NSArray *)guests withBlock:(PFObjectResultBlock)block
{
    NSMutableArray *tempIDs = [[NSMutableArray alloc] init];
    for (MSSportner *sportner in guests) {
        [tempIDs addObject:sportner.objectId];
    }
    
    [PFCloud callFunctionInBackground:@"inviteManySportner"
                       withParameters:@{@"activity": self.objectId, @"sportners": tempIDs}
                                block:^(MSActivity *activity, NSError *error) {
                                    if (!error) {
                                        [self addGuests:guests];
                                        self.playerNeeded = activity.playerNeeded;
                                        
                                        [self notifyActivityStateChanged];
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

- (void)addParticipant:(MSSportner *)sportner
{
    NSMutableArray *tempParticipants = [self.participants mutableCopy];
    [tempParticipants addObject:sportner];
    self.participants = tempParticipants;
}

- (void)addParticipant:(MSSportner *)participant withBlock:(PFObjectResultBlock)block
{
    [PFCloud callFunctionInBackground:@"addConfirmed"
                       withParameters:@{@"activity": self.objectId, @"sportner": participant.objectId}
                                block:^(MSActivity *activity, NSError *error) {
                                    if (!error) {
                                        [self removeAwaiting:participant];
                                        [self removeInvited:participant];
                                        [self addParticipant:participant];
                                        self.playerNeeded = activity.playerNeeded;
                                        
                                        [self notifyActivityStateChanged];
                                    }
                                    
                                    if (block) {
                                        block(self, error);
                                    }
                                }];
}
- (void)removeParticipant:(MSSportner *)participant
{
    NSMutableArray *tempParticipants = [self.participants mutableCopy];
    [tempParticipants removeObject:participant];
    self.participants = tempParticipants;
}

- (void)removeParticipant:(MSSportner *)participant withBlock:(PFObjectResultBlock)block
{
    [PFCloud callFunctionInBackground:@"removeConfirmed"
                       withParameters:@{@"activity": self.objectId, @"sportner": participant.objectId}
                                block:^(MSActivity *activity, NSError *error) {
                                    if (!error) {
                                        [self removeParticipant:participant];
                                        self.playerNeeded = activity.playerNeeded;
                                        
                                        [self notifyActivityStateChanged];
                                    }
                                    
                                    if (block) {
                                        block(self, error);
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

- (void)addAwaiting:(MSSportner *)awaiting
{
    NSMutableArray *tempAwaitings = [self.awaitings mutableCopy];
    [tempAwaitings addObject:awaiting];
    self.awaitings = tempAwaitings;
}

- (void)removeAwaiting:(MSSportner *)awaiting
{
    NSMutableArray *tempAwaitings = [self.awaitings mutableCopy];
    [tempAwaitings removeObject:awaiting];
    self.awaitings = tempAwaitings;
}

- (void)addAwaiting:(MSSportner *)awaiting withBlock:(PFObjectResultBlock)block
{
    [PFCloud callFunctionInBackground:@"addAwaiting"
                       withParameters:@{@"activity": self.objectId, @"sportner": awaiting.objectId}
                                block:^(MSActivity *activity, NSError *error) {
                                    if (!error) {
                                        [self addAwaiting:awaiting];
                                        self.playerNeeded = activity.playerNeeded;
                                        
                                        [self notifyActivityStateChanged];
                                    }
                                    
                                    if (block) {
                                        block(self, error);
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
