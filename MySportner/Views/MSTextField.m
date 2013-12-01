//
//  MSTextField.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSTextField.h"
#import "UITextField+MSTextFieldAppearance.h"

#import "MSColorFactory.h"

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
    if (!_normalBorderColor) _normalBorderColor = [MSColorFactory whiteLight];
    
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

- (void)setFocused:(BOOL)focused
{
    [self setBorderColor:focused ? self.focusBorderColor : self.normalBorderColor];
}

- (void)initializeAppearance
{
    [self setBorderColor:self.normalBorderColor];
    [self setBorderWidth:DEFAULT_BORDER_WIDTH];
    [self setCornerRadius:DEFAULT_CORNER_RADIUS];
}

- (void)initializeAppearanceWithShadow:(BOOL)shadow
{
    [self setBorderColor:self.normalBorderColor];
    [self setBorderWidth:DEFAULT_BORDER_WIDTH];
    [self setCornerRadius:DEFAULT_CORNER_RADIUS];
    
    if (shadow) {
        self.clipsToBounds = NO;
        [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self.layer setShadowRadius:3.0f];
        [self.layer setShadowOffset:CGSizeMake(0, 0)];
        [self.layer setShadowOpacity:0.1f];
    }
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
