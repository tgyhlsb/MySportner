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

@property (nonatomic) BOOL oddIndex;


@end

@implementation MSActivityCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // do nothing
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.backgroundColor = [MSColorFactory redDark];
    } else {
        if (self.oddIndex) {
            self.backgroundColor = [MSColorFactory backgroundColorGrayLight];
        } else {
            self.backgroundColor = [MSColorFactory whiteLight];
        }
    }
    
}

- (void)setAppearanceWithOddIndex:(BOOL)oddIndex
{
    [self.roundView setRounded];
    [self.ownerProfilePictureView setRounded];
    
    self.roundView.backgroundColor = [MSColorFactory redLight];
    self.ownerProfilePictureView.backgroundColor = [UIColor clearColor];
    
    self.titleLabel.textColor = [MSColorFactory redLight];
    
    self.actionButton.faceColor = [MSColorFactory redLight];
    self.actionButton.margin = 0.0f;
    self.actionButton.depth = 0.0f;
    self.actionButton.radius = 3.0f;
    
    self.oddIndex = oddIndex;
    [self setHighlighted:NO animated:NO];

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
