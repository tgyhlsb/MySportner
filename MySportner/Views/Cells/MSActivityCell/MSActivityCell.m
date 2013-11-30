//
//  MSActivityCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSActivityCell.h"
#import "UIView+MSRoundedView.h"
#import "QBFlatButton.h"
#import "MSColorFactory.h"


#define IDENTIFIER @"MSActivityCell"
#define HEIGHT 100.0

@interface MSActivityCell()

@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet QBFlatButton *actionButton;


@end

@implementation MSActivityCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAppearanceWithOddIndex:(BOOL)oddIndex
{
    [self.roundView setRounded];
    [self.ownerProfilePictureView setRounded];
    
    self.roundView.backgroundColor = [MSColorFactory redLight];
    self.ownerProfilePictureView.backgroundColor = [UIColor clearColor];
    
    self.actionButton.faceColor = [MSColorFactory redLight];
    self.actionButton.margin = 0.0f;
    self.actionButton.depth = 0.0f;
    self.actionButton.radius = 3.0f;
    
    if (oddIndex) {
        self.backgroundColor = [MSColorFactory backgroundColorGrayLight];
    } else {
        self.backgroundColor = [MSColorFactory whiteLight];
    }
}

+ (void)registerToTableview:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSActivityCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

+ (CGFloat)height
{
    return HEIGHT;
}

- (IBAction)joinButtonPress:(UIButton *)sender
{
    
}


@end
