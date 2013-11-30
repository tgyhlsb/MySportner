//
//  MSActivitiesFilterCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSActivitiesFilterCell.h"
#import "MSColorFactory.h"

#define IDENTIFIER @"MSActivitiesFilterCell"
#define HEIGHT 44;

@implementation MSActivitiesFilterCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // do nothing
}

+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSActivitiesFilterCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

+ (CGFloat)height
{
    return HEIGHT;
}

- (void)setAppearance
{
    self.segmentedControl.tintColor = [MSColorFactory redLight];
}

@end
