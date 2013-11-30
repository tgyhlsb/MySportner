//
//  MSTextField.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSTextField.h"
#import "UITextField+MSTextFieldAppearance.h"

#define DEFAULT_BORDER_WIDTH 1.0
#define DEFAULT_CORNER_RADIUS 5.0

@implementation MSTextField

@synthesize focusBorderColor = _focusBorderColor;
@synthesize normalBorderColor = _normalBorderColor;

- (UIColor *)focusBorderColor
{
    if (!_focusBorderColor) _focusBorderColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    
    return _focusBorderColor;
}

- (UIColor *)normalBorderColor
{
    if (!_normalBorderColor) _normalBorderColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];;
    
    return _normalBorderColor;
}

- (void)setFocusBorderColor:(UIColor *)focusBorderColor
{
    _focusBorderColor = focusBorderColor;
    [self initializeAppearance];
}

- (void)setNormalBorderColor:(UIColor *)normalBorderColor
{
    _normalBorderColor = normalBorderColor;
    [self initializeAppearance];
}

- (void)initializeAppearance
{
    [self setBorderColor:self.normalBorderColor];
    [self setBorderWidth:DEFAULT_BORDER_WIDTH];
    [self setCornerRadius:DEFAULT_CORNER_RADIUS];
}

- (BOOL)canBecomeFirstResponder
{
    [self setBorderColor:self.focusBorderColor];
    
    return [super canBecomeFirstResponder];
}

- (BOOL)canResignFirstResponder
{
    [self setBorderColor:self.normalBorderColor];
    
    return [super canResignFirstResponder];
}

@end
