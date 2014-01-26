//
//  MSChat.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 26/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSChat.h"
#import <Parse/PFObject+Subclass.h>

#define PARSE_CLASSNAME_CHAT @"MSChat"

@interface MSChat()


@property (strong, nonatomic) NSArray *messages;

@end

@implementation MSChat

@dynamic messages;


+ (NSString *)parseClassName
{
    return PARSE_CLASSNAME_CHAT;
}


- (void)requestMessagesWithTarget:(id)target callBack:(SEL)callback
{
    [PFObject fetchAllInBackground:self.messages target:target selector:callback];
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

- (NSArray *)getMessages
{
    return self.messages;
}

@end
