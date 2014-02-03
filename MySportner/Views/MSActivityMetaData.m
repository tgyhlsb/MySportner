////
////  MSChat.m
////  MySportner
////
////  Created by Tanguy Hélesbeux on 26/01/2014.
////  Copyright (c) 2014 MySportner. All rights reserved.
////
//
//#import "MSActivityMetaData.h"
//#import <Parse/PFObject+Subclass.h>
//
//#define PARSE_CLASSNAME_ACTIVITY_METADATA @"MSActivityMetaData"
//
//@interface MSActivityMetaData()
//
//@property (strong, nonatomic) id tempTarget;
//@property (nonatomic) SEL tempCallBack;
//
//@property (strong, nonatomic) NSArray *messages;
//
//@end
//
//@implementation MSActivityMetaData
//
//@dynamic messages;
//
//@synthesize tempCallBack = _tempCallBack;
//@synthesize tempTarget = _tempTarget;
//
//+ (NSString *)parseClassName
//{
//    return PARSE_CLASSNAME_ACTIVITY_METADATA;
//}
//
//
//- (void)requestMessagesWithTarget:(id)target callBack:(SEL)callback
//{
//    self.tempCallBack = callback;
//    self.tempTarget = target;
//    [PFObject fetchAllInBackground:self.messages target:self selector:@selector(messagesCallBack:error:)];
//}
//
//
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
////        ((void (*)(id, SEL))[self.tempTarget methodForSelector:self.tempCallBack])(self.tempTarget, self.tempCallBack);
//        [self.tempTarget performSelector:self.tempCallBack withObject:Nil withObject:Nil];
//    } else {
//        NSLog(@"Error: %@ %@", error, [error userInfo]);
//    }
//}
//
//- (void)addMessage:(MSComment *)message
//{
//    if (!self.messages) self.messages = [[NSArray alloc] init];
//    
//    NSMutableArray *tempMessages = [self.messages mutableCopy];
//    [tempMessages addObject:message];
//    self.messages = [tempMessages sortedArrayUsingSelector:@selector(compareWithCreationDate:)];
//    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        
//    }];
//}
//
//- (NSArray *)getMessages
//{
//    return self.messages;
//}
//
//@end
