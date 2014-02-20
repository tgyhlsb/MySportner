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
#define DEFAULT_CORNER_RADIUS 4.0

@interface MSTextField()

@end

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

- (UIColor *)textFocusedColor
{
    if (!_textFocusedColor) _textFocusedColor = self.textColor;
    return _textFocusedColor;
}

- (UIColor *)textNormalColor
{
    if (!_textNormalColor) _textNormalColor = self.textColor;
    return _textNormalColor;
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
    self.textColor = focused ? self.textFocusedColor : self.textNormalColor;
}

- (void)initializeAppearance
{
    [self setBorderColor:self.normalBorderColor];
    [self setTextColor:self.textNormalColor];
    self.borderStyle = UITextBorderStyleRoundedRect;
    [self setBorderWidth:DEFAULT_BORDER_WIDTH];
    [self setCornerRadius:DEFAULT_CORNER_RADIUS];}

- (void)initializeAppearanceWithShadow:(BOOL)shadow
{
    [self initializeAppearance];
    
    if (shadow) {
        self.clipsToBounds = NO;
        [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self.layer setShadowRadius:0.5f];
        [self.layer setShadowOffset:CGSizeMake(0.1, 1)];
        [self.layer setShadowOpacity:0.07f];
    }
}

- (BOOL)canBecomeFirstResponder
{
    [self setBorderColor:self.focusBorderColor];
    self.textColor = self.textFocusedColor;
    
    return [super canBecomeFirstResponder];
}

- (BOOL)canResignFirstResponder
{
    [self setBorderColor:self.normalBorderColor];
    [self setTextColor:self.textNormalColor];
    
    return [super canResignFirstResponder];
}


@end
