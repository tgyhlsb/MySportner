//
//  MSFacebookFriendCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 26/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSFacebookFriendCell.h"

#define HEIGHT 44.0
#define NIB_NAME @"MSFacebookFriendCell"

@interface MSFacebookFriendCell()

@end

@implementation MSFacebookFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reusableIdentifier
{
    return NIB_NAME;
}

+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:NIB_NAME bundle:Nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSFacebookFriendCell reusableIdentifier]];
}

+ (CGFloat)height
{
    return HEIGHT;
}

@end
