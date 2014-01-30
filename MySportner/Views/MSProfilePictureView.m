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
    [self.fbView removeFromSuperview];
    [self.imageView removeFromSuperview];
    if (!self.user.image) {
        if (self.user.imageFile) {
            [self.user requestImageWithTarget:self CallBack:@selector(imageDidLoad)];
        } else  {
            self.fbView = [[FBProfilePictureView alloc] initWithProfileID:self.user.facebookID pictureCropping:FBProfilePictureCroppingSquare];
            self.fbView.frame = self.bounds;
            [self addSubview:self.fbView];
        }
    } else {
        self.imageView = [[UIImageView alloc] initWithImage:self.user.image];
        self.imageView.frame = self.bounds;
        [self addSubview:self.imageView];
    }
}

- (void)imageDidLoad
{
    [self updateUI];
}

@end
