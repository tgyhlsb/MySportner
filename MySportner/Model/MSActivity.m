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

@end


@implementation MSActivity

@dynamic date;
@dynamic day;
@dynamic time;
@dynamic place;
@dynamic sport;

@dynamic owner;
@dynamic chat;


@synthesize guests = _guests;
@synthesize participants = _participants;

@synthesize tempMessageQueryCallBack = _tempMessageQueryCallBack;
@synthesize tempMessageQueryTarget = _tempMessageQueryTarget;

@synthesize tempSportnersQueryTarget = _tempSportnersQueryTarget;
@synthesize tempSportnersQueryCallBack = _tempSportnersQueryCallBack;

@synthesize tempOthersQueryTarget = _tempOthersQueryTarget;
@synthesize tempOthersQueryCallBack = _tempOthersQueryCallBack;


+ (NSString *)parseClassName
{
    return PARSE_CLASSNAME_ACTIVITY;
}

- (NSComparisonResult)compareWithCreationDate:(MSActivity *)otherActivity
{
    return [otherActivity.createdAt compare:self.createdAt];
}

- (void)requestMessagesWithTarget:(id)target callBack:(SEL)callback
{
    self.tempMessageQueryCallBack = callback;
    self.tempMessageQueryTarget = target;
    
    [self.chat fetchInBackgroundWithTarget:self selector:@selector(fetchedChat)];
}

- (void)fetchedChat
{
    [self.chat requestMessagesWithTarget:self.tempMessageQueryTarget callBack:self.tempMessageQueryCallBack];
    self.tempMessageQueryTarget = nil;
    self.tempMessageQueryCallBack = nil;
}

- (void)addComment:(MSComment *)comment
{
//    if (!self.chat) self.chat = [[MSChat alloc] init];
    [self.chat addMessage:comment];
}

- (NSArray *)getComments
{
//    if (!self.chat) self.chat = [[MSChat alloc] init];
    return [self.chat getMessages];
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

- (void)queryOtherParticipantsWithTarger:(id)target callBack:(SEL)callback
{
    if (self.guests && self.guests) {
        self.tempOthersQueryTarget = target;
        self.tempOthersQueryCallBack = callback;
        
        NSMutableArray *userNames = [[NSMutableArray alloc] initWithCapacity:([self.guests count] + [self.participants count])];
        for (MSUser *guest in self.guests) {
            [userNames addObject:guest.username];
        }
        for (MSUser *participant in self.participants) {
            [userNames addObject:participant.username];
        }
        
        PFQuery *otherSportnersQuery = [MSUser query];
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

- (void)addGuest:(MSUser *)guest WithTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self guestRelation];
    [relation addObject:guest];
    [self saveInBackgroundWithTarget:target selector:callBack];
}

- (void)removeGuest:(MSUser *)guest WithTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self guestRelation];
    [relation removeObject:guest];
    [self saveInBackgroundWithTarget:target selector:callBack];
}

- (void)addParticipant:(MSUser *)participant WithTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self participantRelation];
    [relation addObject:participant];
    [self saveInBackgroundWithTarget:target selector:callBack];
}

- (void)removeParticipant:(MSUser *)participant WithTarget:(id)target callBack:(SEL)callBack
{
    PFRelation *relation = [self participantRelation];
    [relation removeObject:participant];
    [self saveInBackgroundWithTarget:target selector:callBack];
}

@end
