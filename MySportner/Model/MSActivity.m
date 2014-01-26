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

@property (strong, nonatomic) id tempTarget;
@property (nonatomic) SEL tempCallBack;

@end


@implementation MSActivity

@dynamic date;
@dynamic day;
@dynamic time;
@dynamic place;
@dynamic sport;

@dynamic owner;
@dynamic guests;
@dynamic participants;
@dynamic chat;


@synthesize tempCallBack = _tempCallBack;
@synthesize tempTarget = _tempTarget;


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
    self.tempCallBack = callback;
    self.tempTarget = target;
    
    [self.chat fetchIfNeededInBackgroundWithTarget:self selector:@selector(fetchedChat)];
}

- (void)fetchedChat
{
    [self.chat requestMessagesWithTarget:self.tempTarget callBack:self.tempCallBack];
    self.tempTarget = nil;
    self.tempCallBack = nil;
}

- (void)addComment:(MSComment *)comment
{
    if (!self.chat) self.chat = [[MSChat alloc] init];
    [self.chat addMessage:comment];
}

- (NSArray *)getComments
{
    if (!self.chat) self.chat = [[MSChat alloc] init];
    return [self.chat getMessages];
}

@end
