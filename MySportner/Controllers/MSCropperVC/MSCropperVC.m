//
//  MSCropperVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 15/02/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSCropperVC.h"
#import "BJImageCropper.h"

#define NIB_NAME @"MSCropperVC"

@interface MSCropperVC ()
@property (nonatomic, strong) BJImageCropper *imageCropper;

@property (nonatomic, strong) UIImageView *preview;

@end

@implementation MSCropperVC

+ (MSCropperVC *)newControllerWithImage:(UIImage *)image
{
    MSCropperVC *viewController = [[MSCropperVC alloc] initWithNibName:NIB_NAME bundle:Nil];
    viewController.hasDirectAccessToDrawer = NO;
    viewController.image = image;
    return viewController;
}

#pragma mark - View lifecycle


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.imageCropper] && [keyPath isEqualToString:@"crop"]) {
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iOS_blur.png"]];
    self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:241.0/255.0 blue:243.0/255.0 alpha:1.0];
    
    self.imageCropper = [[BJImageCropper alloc] initWithImage:self.image andMaxSize:self.view.bounds.size];
    [self.view addSubview:self.imageCropper];
    self.imageCropper.center = self.view.center;
    self.imageCropper.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.imageCropper.imageView.layer.shadowRadius = 3.0f;
    self.imageCropper.imageView.layer.shadowOpacity = 0.8f;
    self.imageCropper.imageView.layer.shadowOffset = CGSizeMake(1, 1);
    
    [self setUpDoneButton];
}

- (void)setUpDoneButton
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Done"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(doneButtonHandler)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)doneButtonHandler
{
    if ([self.delegate respondsToSelector:@selector(cropper:didCropImage:)]) {
        [self.delegate cropper:self didCropImage:[self.imageCropper getCroppedImage]];
    }
}

@end
