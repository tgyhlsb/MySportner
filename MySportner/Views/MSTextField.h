//
//  MSTextField.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTextField : UITextField

@property (strong, nonatomic) UIColor *focusBorderColor;
@property (strong, nonatomic) UIColor *normalBorderColor;
@property (strong, nonatomic) UIColor *textFocusedColor;
@property (strong, nonatomic) UIColor *textNormalColor;

- (void)setFocused:(BOOL)focused;

- (void)initializeAppearanceWithShadow:(BOOL)shadow;

@end
