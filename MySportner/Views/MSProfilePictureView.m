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
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

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

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.color = [UIColor blackColor];
        _activityIndicatorView.frame = self.bounds;
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }

    return _activityIndicatorView;
}

- (FBProfilePictureView *)fbView
{
    if (!_fbView) {
        _fbView = [[FBProfilePictureView alloc] initWithProfileID:Nil pictureCropping:FBProfilePictureCroppingSquare];
        _fbView.frame = self.bounds;
        [self addSubview:_fbView];
    }
    return _fbView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = self.bounds;
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSportner:(MSSportner *)sportner
{
    _sportner = sportner;
    [self updateUI];
}

- (void)updateUI
{
    [self.fbView setHidden:YES];
    [self.imageView setHidden:YES];
    [self.activityIndicatorView startAnimating];
    if (!self.sportner.image) {
        if (self.sportner.imageFile) {
            [self.sportner requestImageWithTarget:self CallBack:@selector(imageDidLoad)];
        } else  {
            self.fbView.profileID = self.sportner.facebookID;
            self.fbView.hidden = NO;
            [self.activityIndicatorView stopAnimating];
        }
    } else {
        self.imageView.image = self.sportner.image;
        self.imageView.hidden = NO;
        [self.activityIndicatorView stopAnimating];
    }
}

- (void)imageDidLoad
{
    [self updateUI];
}

@end
