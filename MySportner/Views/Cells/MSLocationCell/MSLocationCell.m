//
//  MSLocationCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 31/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSLocationCell.h"

#define NIB_NAME @"MSLocationCell"
#define HEIGHT 44

@implementation MSLocationCell

+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:NIB_NAME bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSLocationCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return NIB_NAME;
}

+ (CGFloat)height
{
    return HEIGHT;
}

@end
