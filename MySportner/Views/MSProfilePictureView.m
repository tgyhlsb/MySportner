//
//  MSProfilePicture.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 26/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSProfilePictureView.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIView+MSRoundedView.h"

@interface MSProfilePictureView()

@property (strong, nonatomic) FBProfilePictureView *fbView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation MSProfilePictureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setUser:(MSUser *)user
{
    _user = user;
    [self updateUI];
}

- (void)updateUI
{
    if (!self.user.image && self.user.imageFile) {
        [self.user requestImageWithTarget:self CallBack:@selector(imageDidLoad)];
    } else if (self.user.imageFile) {
        self.imageView = [[UIImageView alloc] initWithImage:self.user.image];
        self.imageView.frame = self.bounds;
        [self addSubview:self.imageView];
        [self.fbView removeFromSuperview];
    } else {
        self.fbView = [[FBProfilePictureView alloc] initWithProfileID:self.user.facebookID pictureCropping:FBProfilePictureCroppingSquare];
        self.fbView.frame = self.bounds;
        [self addSubview:self.fbView];
        [self.imageView removeFromSuperview];
    }
}

- (void)imageDidLoad
{
    [self updateUI];
}

@end
