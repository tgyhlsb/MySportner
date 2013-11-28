//
//  MSNavigationBar.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 28/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSNavigationBar.h"

@interface MSNavigationBar()

@property (nonatomic, strong) CALayer *colorLayer;

@end

@implementation MSNavigationBar

static CGFloat const kDefaultColorLayerOpacity = 0.5f;
static CGFloat const kSpaceToCoverStatusBars = 20.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.colorLayer != nil) {
        [self.colorLayer removeFromSuperlayer];
        self.colorLayer.opacity = kDefaultColorLayerOpacity;
        [self.layer insertSublayer:self.colorLayer atIndex:1];
        CGFloat spaceAboveBar = self.frame.origin.y;
        self.colorLayer.frame = CGRectMake(0, 0 - spaceAboveBar, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + spaceAboveBar);
    }
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    [super setBarTintColor:barTintColor];
    if (self.colorLayer == nil) {
        self.colorLayer = [CALayer layer];
        self.colorLayer.opacity = kDefaultColorLayerOpacity;
        [self.layer addSublayer:self.colorLayer];
    }
    self.colorLayer.backgroundColor = barTintColor.CGColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
