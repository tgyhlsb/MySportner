//
//  MSNotificationCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSNotificationCell.h"

#define IDENTIFIER @"MSNotificationCell"

@interface MSNotificationCell()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation MSNotificationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNotification:(MSNotification *)notification
{
    _notification = notification;
    
    self.messageLabel.text = notification.title;
}


#pragma - Overrides 

+ (void)registerToTableview:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSNotificationCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

@end
