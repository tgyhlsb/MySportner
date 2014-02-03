//
//  MSActivity.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSActivity.h"
#import <Parse/PFObject+Subclass.h>

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

@dynamic owner;


@synthesize guests = _guests;
@synthesize participants = _participants;

@synthesize tempMessageQueryCallBack = _tempMessageQueryCallBack;
@synthesize tempMessageQueryTarget = _tempMessageQueryTarget;

@synthesize tempSportnersQueryTarget = _tempSportnersQueryTarget;
@synthesize tempSportnersQueryCallBack = _tempSportnersQueryCallBack;

@synthesize tempOthersQueryTarget = _tempOthersQueryTarget;
@synthesize tempOthersQueryCallBack = _tempOthersQueryCallBack;

@synthesize tempQueryMessagesCallBack = _tempQueryMessagesCallBack;
@synthesize tempQueryMessagesTarget = _tempQueryMessagesTarget;

@synthesize messages = _messages;


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
    return [self relationforKey:@"guest"];
}

- (PFRelation *)participantRelation
{
    return [self relationforKey:@"participant"];
}

#pragma mark - PARSE Backend

- (void)querySportnersWithTarget:(id)target callBack:(SEL)callBack
{
    self.tempSportnersQueryTarget = target;
    self.tempSportnersQueryCallBack = callBack;
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
        [self.tempSportnersQueryTarget performSelector:self.tempSportnersQueryCallBack withObject:error];
    }
}

- (void)guestsCallback:(NSArray *)objects error:(NSError *)error
{
    if (!error) {
        self.guests = objects;
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
    
    [self.tempSportnersQueryTarget performSelector:self.tempSportnersQueryCallBack withObject:error];
}

- (void)queryOtherSportnersWithTarger:(id)target callBack:(SEL)callback
{
    if (self.guests && self.guests) {
        self.tempOthersQueryTarget = target;
        self.tempOthersQueryCallBack = callback;
        
        NSMutableArray *userNames = [[NSMutableArray alloc] initWithCapacity:([self.guests count] + [self.participants count])];
        for (MSSportner *guest in self.guests) {
            [userNames addObject:guest.username];
        }
        for (MSSportner *participant in self.participants) {
            [userNames addObject:participant.username];
        }
        [userNames addObject:[MSSportner currentSportner].username];
        
        PFQuery *otherSportnersQuery = [MSSportner query];
        [otherSportnersQuery whereKey:@"username" notContainedIn:userNames];
        [otherSportnersQuery findObjectsInBackgroundWithTarget:self
                                                      selector:@selector(sportnersCallback:error:)];
    } else {
//        [self querySportners];
        NSLog(@"Query sportners before");
    }
}

- (void)sportnersCallback:(NSArray *)objects error:(NSError *)error
{
    if (!error) {
        [self.tempOthersQueryTarget performSelector:self.tempOthersQueryCallBack withObject:objects withObject:error];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

#pragma mark - Participants & Guests

- (void)addGuest:(MSSportner *)guest WithTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self guestRelation];
    [relation addObject:guest];
    [self saveInBackgroundWithTarget:target selector:callBack];
}

- (void)removeGuest:(MSSportner *)guest WithTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self guestRelation];
    [relation removeObject:guest];
    [self saveInBackgroundWithTarget:target selector:callBack];
}

- (void)addParticipant:(MSSportner *)participant WithTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self participantRelation];
    [relation addObject:participant];
    [self saveInBackgroundWithTarget:target selector:callBack];
}

- (void)removeParticipant:(MSSportner *)participant WithTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self participantRelation];
    [relation removeObject:participant];
    [self saveInBackgroundWithTarget:target selector:callBack];
}

#pragma mark - Messages

- (void)requestMessagesWithTarget:(id)target callBack:(SEL)callback
{
    self.tempQueryMessagesCallBack = callback;
    self.tempQueryMessagesTarget = target;
    [PFObject fetchAllInBackground:self.messages target:self selector:@selector(messagesCallBack:error:)];
}


- (void)messagesCallBack:(NSArray *)objects error:(NSError *)error
{
    if (!error) {
        NSMutableArray *objectsToFetch = [[NSMutableArray alloc] initWithCapacity:[objects count]];
        for (MSComment *comment in objects)
        {
            [objectsToFetch addObject:comment.author];
        }
        [PFObject fetchAllInBackground:objectsToFetch target:self selector:@selector(messagesAuthorsCallBack:error:)];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

- (void)messagesAuthorsCallBack:(NSArray *)objects error:(NSError *)error
{
    if (!error) {
        // Same as : [target performSelector:@selector(callback)]
        // Explanations : http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
        // In order not to get warning
        //        ((void (*)(id, SEL))[self.tempTarget methodForSelector:self.tempCallBack])(self.tempTarget, self.tempCallBack);
        [self.tempQueryMessagesTarget performSelector:self.tempQueryMessagesCallBack withObject:Nil withObject:Nil];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

- (void)addMessage:(MSComment *)message
{
    if (!self.messages) self.messages = [[NSArray alloc] init];
    
    NSMutableArray *tempMessages = [self.messages mutableCopy];
    [tempMessages addObject:message];
    self.messages = [tempMessages sortedArrayUsingSelector:@selector(compareWithCreationDate:)];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    }];
}


@end
