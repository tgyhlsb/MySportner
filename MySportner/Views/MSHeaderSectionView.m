//
//  MSHeaderSectionView.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSHeaderSectionView.h"
#import "MSStyleFactory.h"

@interface MSHeaderSectionView()

@property (strong, nonatomic) UILabel *titleLabel;


@end

@implementation MSHeaderSectionView

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        self.frame = CGRectMake(0, 0, 320, 35);
        CGRect frame = CGRectMake(20, 10, self.frame.size.width - 40, 25);
        _titleLabel = [[UILabel alloc] initWithFrame:frame];
        [MSStyleFactory setUILabel:_titleLabel withStyle:MSLabelStyleSectionHeader];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

@end
