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

- (void)addGuest:(MSSportner *)sportner
{
    PFRelation *relation = [self guestRelation];
    [relation addObject:sportner];
    NSMutableArray *tempGuests = [self.guests mutableCopy];
    [tempGuests addObject:sportner];
    self.participants = tempGuests;
}

- (void)addGuests:(NSArray *)sportners
{
    PFRelation *relation = [self guestRelation];
    NSMutableArray *tempGuests = [self.guests mutableCopy];
    
    for (MSSportner *sportner in sportners) {
        [relation addObject:sportner];
        [tempGuests addObject:sportner];
    }
    
    self.participants = tempGuests;
}

- (void)addGuest:(MSSportner *)guest withBlock:(PFBooleanResultBlock)block
{
    [self addGuest:guest];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded && !error) {
            [self notifyActivityStateChanged];
        }
        if (block) {
            block(succeeded, error);
        }
    }];
}

- (void)addGuests:(NSArray *)guests withBlock:(PFBooleanResultBlock)block
{
    [self addGuests:guests];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded && !error) {
            [self notifyActivityStateChanged];
        }
        if (block) {
            block(succeeded, error);
        }
    }];
}

- (void)removeGuest:(MSSportner *)guest
{
    PFRelation *relation = [self guestRelation];
    [relation removeObject:guest];
    NSMutableArray *tempGuests = [self.guests mutableCopy];
    [tempGuests removeObject:guest];
    self.guests = tempGuests;
}

- (void)removeGuest:(MSSportner *)guest withBlock:(PFBooleanResultBlock)block
{
    [self removeGuest:guest];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded && !error) {
            [self notifyActivityStateChanged];
        }
        if (block) {
            block(succeeded, error);
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
    PFRelation *relation = [self participantRelation];
    [relation addObject:sportner];
    NSMutableArray *tempParticipants = [self.participants mutableCopy];
    [tempParticipants addObject:sportner];
    self.participants = tempParticipants;
    [self incrementKey:@"playerNeeded" byAmount:@(-1)];
}

- (void)addParticipants:(NSArray *)sportners
{
    PFRelation *relation = [self participantRelation];
    NSMutableArray *tempParticipants = [self.participants mutableCopy];
    
    for (MSSportner *sportner in sportners) {
        [relation addObject:sportner];
        [tempParticipants addObject:sportner];
    }
    
    self.participants = tempParticipants;
    [self incrementKey:@"playerNeeded" byAmount:@(-1*[sportners count])];
}

- (void)addParticipant:(MSSportner *)participant withBlock:(PFBooleanResultBlock)block
{
    [self addParticipant:participant];
    if ([self.guests containsObject:participant]) {
        [self removeGuest:participant];
    }
    if ([self.awaitings containsObject:participant]) {
        [self removeAwaiting:participant];
    }
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded && !error) {
            [self notifyActivityStateChanged];
        }
        if (block) {
            block(succeeded, error);
        }
    }];
}

- (void)addParticipants:(NSArray *)participants withBlock:(PFBooleanResultBlock)block
{
    [self addParticipants:participants];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded && !error) {
            [self notifyActivityStateChanged];
        }
        if (block) {
            block(succeeded, error);
        }
    }];
}

- (void)removeParticipant:(MSSportner *)participant
{
    PFRelation *relation = [self participantRelation];
    [relation removeObject:participant];
    NSMutableArray *tempParticipants = [self.participants mutableCopy];
    [tempParticipants removeObject:participant];
    self.participants = tempParticipants;
    [self incrementKey:@"playerNeeded"];
    self.playerNeeded = [NSNumber numberWithInt:([self.playerNeeded intValue] + 1)];
}

- (void)removeParticipant:(MSSportner *)participant withBlock:(PFBooleanResultBlock)block
{
    [self removeParticipant:participant];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded && !error) {
            [self notifyActivityStateChanged];
        }
        if (block) {
            block(succeeded, error);
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
    PFRelation *relation = [self awaitingRelation];
    [relation addObject:awaiting];
    NSMutableArray *tempAwaitings = [self.awaitings mutableCopy];
    [tempAwaitings addObject:awaiting];
    self.awaitings = tempAwaitings;
}

- (void)addAwaiting:(MSSportner *)awaiting withBlock:(PFBooleanResultBlock)block
{
    [self addAwaiting:awaiting];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded && !error) {
            [self notifyActivityStateChanged];
        }
        if (block) {
            block(succeeded, error);
        }
    }];
}

- (void)removeAwaiting:(MSSportner *)awaiting
{
    PFRelation *relation = [self awaitingRelation];
    [relation removeObject:awaiting];
    NSMutableArray *tempAwaitings = [self.awaitings mutableCopy];
    [tempAwaitings removeObject:awaiting];
    self.awaitings = tempAwaitings;
}

- (void)removeAwaiting:(MSSportner *)awaiting withBlock:(PFBooleanResultBlock)block
{
    [self removeAwaiting:awaiting];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded && !error) {
            [self notifyActivityStateChanged];
        }
        if (block) {
            block(succeeded, error);
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
