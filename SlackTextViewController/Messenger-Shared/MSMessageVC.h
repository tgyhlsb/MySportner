//
//  MessageViewController.h
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "SLKTextViewController.h"
#import "MSActivity.h"

@interface MSMessageVC : SLKTextViewController

@property (strong, nonatomic) MSActivity *activity;

@end
