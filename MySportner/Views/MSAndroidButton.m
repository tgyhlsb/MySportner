//
//  MSAndroidButton.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSAndroidButton.h"

@interface MSAndroidButton()

@property (strong, nonatomic) UIView *bottomBar;

@property (strong, nonatomic) UIColor *normalBackgroundColor;
@property (strong, nonatomic) UIColor *selectedBackgroundColor;

@end

@implementation MSAndroidButton

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] init];
        [self addSubview:_bottomBar];
        self.tintColor = [UIColor clearColor];
    }
    return _bottomBar;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self updateBottomBorder];
}

- (void)updateBottomBorder
{
    self.bottomBar.frame = CGRectMake(0, self.bounds.size.height - self.borderWidth, self.bounds.size.width, self.borderWidth);
    
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 0, self.borderWidth, 0);
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    
    self.bottomBar.backgroundColor = borderColor;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.bottomBar.hidden = !selected;
    self.backgroundColor = selected ? self.selectedBackgroundColor : self.normalBackgroundColor;
    
    [self updateBottomBorder];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:
        {
            self.normalBackgroundColor = backgroundColor;
            break;
        }
        case UIControlStateSelected:
        {
            self.selectedBackgroundColor = backgroundColor;
            break;
        }
            
        default:
            break;
    }
}

@end
