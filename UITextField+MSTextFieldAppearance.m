//
//  UITextField+MSTextFieldAppearance.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "UITextField+MSTextFieldAppearance.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITextField (MSTextFieldAppearance)

- (void)setBorderColor:(UIColor *)color
{
    self.layer.borderColor = [color CGColor];
}

- (void)setBorderWidth:(CGFloat)width
{
    self.layer.borderWidth = width;
}

- (void)setCornerRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
}

@end
