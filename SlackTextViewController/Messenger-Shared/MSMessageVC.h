//
//  MessageViewController.h
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "SLKTextViewController.h"
#import "MSActivity.h"


@protocol MSMessageVCDelegate;

@interface MSMessageVC : SLKTextViewController

@property (weak, nonatomic) id<MSMessageVCDelegate> delegate;
@property (strong, nonatomic) MSActivity *activity;

@end

@protocol MSMessageVCDelegate <NSObject>

@optional
- (void)messageViewController:(MSMessageVC *)viewController didDissmissWithMessages:(NSArray *)messages;

@end
