//
//  MSFlatButtonWhite.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/03/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSFlatButtonWhite.h"

@implementation MSFlatButtonWhite

- (void)_QBFlatButton_init
{
    self.faceColor = [UIColor whiteColor];
    self.sideColor = [UIColor colorWithRed:0.310 green:0.498 blue:0.702 alpha:1.0];
    
    self.radius = 1.0;
    self.margin = 0.0;
    self.depth = 0.0;
    
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:10];
    
    [self setTitleColor:[UIColor colorWithRed:0.31f green:0.36f blue:0.40f alpha:1.00f] forState:UIControlStateNormal];
}

@end
