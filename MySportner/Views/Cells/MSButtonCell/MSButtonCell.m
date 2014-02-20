//
//  MSButtonCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 29/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSButtonCell.h"
#import "MSStyleFactory.h"

#define NIB_NAME @"MSButtonCell"
#define HEIGHT 60

@interface MSButtonCell()

@end

@implementation MSButtonCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [MSStyleFactory setQBFlatButton:self.button withStyle:MSFlatButtonStyleGreen];
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // do nothing
}

+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:NIB_NAME bundle:Nil];
    
    [tableView registerNib:nib forCellReuseIdentifier:[MSButtonCell reusableIdentifier]];
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
