//
//  MSCropperVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 15/02/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSCenterController.h"

@protocol MSCropperVCDelegate;

@interface MSCropperVC : MSCenterController

@property (weak, nonatomic) id<MSCropperVCDelegate> delegate;

@property (strong, nonatomic) UIImage *image;

+ (MSCropperVC *)newControllerWithImage:(UIImage *)image;

@end

@protocol MSCropperVCDelegate <NSObject>

- (void)cropper:(MSCropperVC *)cropper didCropImage:(UIImage *)image;

@end
