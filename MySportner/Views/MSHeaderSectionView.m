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
@property (strong, nonatomic) UILabel *noCommentLabel;

@end

@implementation MSHeaderSectionView

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setShowNoCommentLabel:(BOOL)showNoCommentLabel
{
    _showNoCommentLabel = showNoCommentLabel;
    self.noCommentLabel.hidden = !showNoCommentLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        self.frame = CGRectMake(0, 0, 320, 300);
        CGRect frame = CGRectMake(20, 10, self.frame.size.width - 40, 25);
        _titleLabel = [[UILabel alloc] initWithFrame:frame];
        [MSStyleFactory setUILabel:_titleLabel withStyle:MSLabelStyleSectionHeader];
        [self addSubview:_titleLabel];
        
    }
    return _titleLabel;
}

- (UILabel *)noCommentLabel
{
    if (!_noCommentLabel) {
        CGRect frame = CGRectMake(0, 100, 320, 20);
        _noCommentLabel = [[UILabel alloc] initWithFrame:frame];
        _noCommentLabel.textAlignment = NSTextAlignmentCenter;
        [MSStyleFactory setUILabel:_noCommentLabel withStyle:MSLabelStyleSectionHeader];
        self.noCommentLabel.text = @"No comment".uppercaseString;
        [self addSubview:_noCommentLabel];
    }
    return _noCommentLabel;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

@end
