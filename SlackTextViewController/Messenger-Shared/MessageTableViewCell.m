//
//  MessageTableViewCell.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 9/1/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "MSProfilePictureView.h"

@interface MessageTableViewCell()

@property (strong, nonatomic) MSProfilePictureView *profilePictureView;

@end

@implementation MessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        self.textLabel.numberOfLines = 0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.imageView.layer.cornerRadius = kAvatarSize/2.0;
        self.imageView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.usedForMessage) {
        CGRect avatarFrame = self.imageView.frame;
        avatarFrame.origin = CGPointMake(kAvatarSize/2.0, 10.0);
        self.imageView.frame = avatarFrame;
    }
}

#pragma mark - Getters & Setters

- (MSProfilePictureView *)profilePictureView
{
    if (!_profilePictureView) {
        _profilePictureView = [[MSProfilePictureView alloc] initWithFrame:self.imageView.frame];
        [self addSubview:_profilePictureView];
    }
    return _profilePictureView;
}

- (void)setComment:(MSComment *)comment
{
    _comment = comment;
    
    self.profilePictureView.sportner = comment.author;
    self.textLabel.text = comment.content;
}

#pragma mark - Helpers

UIImage *blankImage(UIColor *color)
{
    CGSize size = CGSizeMake(kAvatarSize, kAvatarSize);
    
    UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
