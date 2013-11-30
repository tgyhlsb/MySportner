//
//  UIView+MSRoundedView.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "UIView+MSRoundedView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (MSRoundedView)

-(void)setRounded
{
    self.layer.cornerRadius = self.frame.size.width / 2.0;
}

@end
