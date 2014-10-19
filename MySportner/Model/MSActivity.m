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

@interface MSActivity()

@property (weak, nonatomic) id tempMessageQueryTarget;
@property (nonatomic) SEL tempMessageQueryCallBack;

@property (weak, nonatomic) id tempSportnersQueryTarget;
@property (nonatomic) SEL tempSportnersQueryCallBack;

@property (weak, nonatomic) id tempOthersQueryTarget;
@property (nonatomic) SEL tempOthersQueryCallBack;

@property (strong, nonatomic) id tempQueryMessagesTarget;
@property (nonatomic) SEL tempQueryMessagesCallBack;

@end


@implementation MSActivity

@dynamic date;
@dynamic day;
@dynamic time;
@dynamic place;
@dynamic sport;
@dynamic level;

@dynamic owner;


@synthesize guests = _guests;
@synthesize participants = _participants;
@synthesize awaitings = _awaitings;
@synthesize comments = _comments;

@synthesize tempMessageQueryCallBack = _tempMessageQueryCallBack;
@synthesize tempMessageQueryTarget = _tempMessageQueryTarget;

@synthesize tempSportnersQueryTarget = _tempSportnersQueryTarget;
@synthesize tempSportnersQueryCallBack = _tempSportnersQueryCallBack;

@synthesize tempOthersQueryTarget = _tempOthersQueryTarget;
@synthesize tempOthersQueryCallBack = _tempOthersQueryCallBack;

@synthesize tempQueryMessagesCallBack = _tempQueryMessagesCallBack;
@synthesize tempQueryMessagesTarget = _tempQueryMessagesTarget;


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

#pragma mark - PARSE Backend

- (void)querySportnersWithTarget:(id)target callBack:(SEL)callBack
{
    self.tempSportnersQueryTarget = target;
    self.tempSportnersQueryCallBack = callBack;
    if (!self.participants) {
        self.participants = [[NSArray alloc] init];
    }
    if (!self.guests) {
        self.guests = [[NSArray alloc] init];
    }
    if (!self.awaitings) {
        self.awaitings = [[NSArray alloc] init];
    }
    PFQuery *participantQuery = [[self participantRelation] query];
    [participantQuery findObjectsInBackgroundWithTarget:self
                                               selector:@selector(participantsCallback:error:)];
}

- (void)participantsCallback:(NSArray *)objects error:(NSError *)error
{
    if (!error) {
        self.participants = objects;
        
        PFQuery *guestQuery = [[self guestRelation] query];
        [guestQuery findObjectsInBackgroundWithTarget:self
                                             selector:@selector(guestsCallback:error:)];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.tempSportnersQueryTarget performSelector:self.tempSportnersQueryCallBack withObject:error];
#pragma clang diagnostic pop
    }
}

- (void)guestsCallback:(NSArray *)objects error:(NSError *)error
{
    if (!error) {
        self.guests = objects;
        
        PFQuery *awaitingQuery = [[self awaitingRelation] query];
        [awaitingQuery findObjectsInBackgroundWithTarget:self
                                             selector:@selector(awaitingCallback:error:)];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.tempSportnersQueryTarget performSelector:self.tempSportnersQueryCallBack withObject:error];
#pragma clang diagnostic pop
    }
}

- (void)awaitingCallback:(NSArray *)objects error:(NSError *)error
{
    if (!error) {
        self.awaitings = objects;
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.tempSportnersQueryTarget performSelector:self.tempSportnersQueryCallBack withObject:error];
#pragma clang diagnostic pop
}

//- (void)queryOtherSportnersWithTarger:(id)target callBack:(SEL)callback
//{
//    if (self.guests && self.guests) {
//        self.tempOthersQueryTarget = target;
//        self.tempOthersQueryCallBack = callback;
//        
//        NSMutableArray *userNames = [[NSMutableArray alloc] initWithCapacity:([self.guests count] + [self.participants count])];
//        for (MSSportner *guest in self.guests) {
//            [userNames addObject:guest.username];
//        }
//        for (MSSportner *participant in self.participants) {
//            [userNames addObject:participant.username];
//        }
//        [userNames addObject:[MSSportner currentSportner].username];
//        
//        PFQuery *otherSportnersQuery = [MSSportner query];
//        [otherSportnersQuery whereKey:@"username" notContainedIn:userNames];
//        [otherSportnersQuery findObjectsInBackgroundWithTarget:self
//                                                      selector:@selector(sportnersCallback:error:)];
//    } else {
////        [self querySportners];
//        NSLog(@"Query sportners before");
//    }
//}

- (void)sportnersCallback:(NSArray *)objects error:(NSError *)error
{
    if (!error) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.tempOthersQueryTarget performSelector:self.tempOthersQueryCallBack withObject:objects withObject:error];
#pragma clang diagnostic pop
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

#pragma mark - Guests

- (void)fetchGuests
{
    PFQuery *query = [[self guestRelation] query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.guests = objects;
            [self notifyActivityStateChanged];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)addGuest:(MSSportner *)guest WithTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self guestRelation];
    [relation addObject:guest];
    NSMutableArray *tempGuests = [self.guests mutableCopy];
    [tempGuests addObject:guest];
    self.guests = tempGuests;
    [self saveInBackgroundWithTarget:target selector:callBack];
}

- (void)removeGuest:(MSSportner *)guest WithTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self guestRelation];
    [relation removeObject:guest];
    NSMutableArray *tempGuests = [self.guests mutableCopy];
    [tempGuests removeObject:guest];
    self.guests = tempGuests;
    [self saveInBackgroundWithTarget:target selector:callBack];
}

#pragma mark - Participants

- (void)fetchParticipants
{
    PFQuery *query = [[self participantRelation] query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.participants = objects;
            [self notifyActivityStateChanged];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)addParticipant:(MSSportner *)participant WithTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self participantRelation];
    [relation addObject:participant];
    NSMutableArray *tempParticipants = [self.participants mutableCopy];
    [tempParticipants addObject:participant];
    self.participants = tempParticipants;
    [self saveInBackgroundWithTarget:target selector:callBack];
}

- (void)removeParticipant:(MSSportner *)participant WithTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self participantRelation];
    [relation removeObject:participant];
    NSMutableArray *tempParticipants = [self.participants mutableCopy];
    [tempParticipants removeObject:participant];
    self.participants = tempParticipants;
    [self saveInBackgroundWithTarget:target selector:callBack];
}

#pragma mark - Awaitings

- (void)fetchAwaitings
{
    PFQuery *query = [[self awaitingRelation] query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.awaitings = objects;
            [self notifyActivityStateChanged];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)addAwaiting:(MSSportner *)awaiting WithTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self awaitingRelation];
    [relation addObject:awaiting];
    NSMutableArray *tempAwaitings = [self.awaitings mutableCopy];
    [tempAwaitings addObject:awaiting];
    self.awaitings = tempAwaitings;
    [self saveInBackgroundWithTarget:target selector:callBack];
}

- (void)removeAwaiting:(MSSportner *)awaiting WithTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self awaitingRelation];
    [relation removeObject:awaiting];
    NSMutableArray *tempAwaitings = [self.awaitings mutableCopy];
    [tempAwaitings removeObject:awaiting];
    self.awaitings = tempAwaitings;
    [self saveInBackgroundWithTarget:target selector:callBack];
}

#pragma mark - Messages

- (void)notifyActivityStateChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MSNotificationActivityStateChanged
                                                        object:self];
}

//- (void)requestMessagesWithTarget:(id)target callBack:(SEL)callback
//{
//    self.tempQueryMessagesCallBack = callback;
//    self.tempQueryMessagesTarget = target;
//    
//    [PFObject fetchAllInBackground:self.messages target:self selector:@selector(messagesCallBack:error:)];
//}

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

//- (void)messagesCallBack:(NSArray *)objects error:(NSError *)error
//{
//    if (!error) {
//        NSMutableArray *objectsToFetch = [[NSMutableArray alloc] initWithCapacity:[objects count]];
//        for (MSComment *comment in objects)
//        {
//            [objectsToFetch addObject:comment.author];
//        }
//        [PFObject fetchAllInBackground:objectsToFetch target:self selector:@selector(messagesAuthorsCallBack:error:)];
//    } else {
//        NSLog(@"Error: %@ %@", error, [error userInfo]);
//    }
//}
//
//- (void)messagesAuthorsCallBack:(NSArray *)objects error:(NSError *)error
//{
//    if (!error) {
//        // Same as : [target performSelector:@selector(callback)]
//        // Explanations : http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
//        // In order not to get warning
//        //        ((void (*)(id, SEL))[self.tempTarget methodForSelector:self.tempCallBack])(self.tempTarget, self.tempCallBack);
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        [self.tempQueryMessagesTarget performSelector:self.tempQueryMessagesCallBack withObject:Nil withObject:Nil];
//#pragma clang diagnostic pop
//    } else {
//        NSLog(@"Error: %@ %@", error, [error userInfo]);
//    }
//}

//- (void)addMessage:(MSComment *)message inBackgroundWithBlock:(PFBooleanResultBlock)block
//{
//    
//    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            
//            if (!self.messages) self.messages = [[NSArray alloc] init];
//            NSMutableArray *tempMessages = [self.messages mutableCopy];
//            [tempMessages addObject:message];
//            self.messages = [tempMessages sortedArrayUsingSelector:@selector(compareWithCreationDate:)];
//            
//            [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                block(succeeded, error);
//            }];
//            
//        } else {
//            block(succeeded, error);
//        }
//    }];
//    
//}

- (void)addComment:(MSComment *)comment withTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self commentRelation];
    [relation addObject:comment];
    NSMutableArray *tempComments = [self.comments mutableCopy];
    [tempComments addObject:comment];
    self.comments = tempComments;
    [self saveInBackgroundWithTarget:target selector:callBack];
}


@end
