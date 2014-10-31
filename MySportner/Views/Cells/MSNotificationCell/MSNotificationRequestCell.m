//
//  MSNotificationRequestCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSNotificationRequestCell.h"

#define IDENTIFIER @"MSNotificationRequestCell"

@implementation MSNotificationRequestCell


#pragma - Handlers

- (IBAction)acceptButtonHandler:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(notificationRequestCellDidTapAccept:)]) {
        [self.delegate notificationRequestCellDidTapAccept:self];
    }
}

- (IBAction)declineButtonHandler:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(notificationRequestCellDidTapDecline:)]) {
        [self.delegate notificationRequestCellDidTapDecline:self];
    }
}


#pragma - Overrides

+ (void)registerToTableview:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSNotificationRequestCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

@end
