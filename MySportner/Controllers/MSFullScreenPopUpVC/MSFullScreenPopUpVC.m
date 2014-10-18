//
//  MSFullScreenPopUpVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 18/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSFullScreenPopUpVC.h"
#import "QBFlatButton.h"

#define NIB_NAME @"MSFullScreenPopUpVC"

@interface MSFullScreenPopUpVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet QBFlatButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@end

@implementation MSFullScreenPopUpVC

+ (MSFullScreenPopUpVC *)newController
{
    return [[MSFullScreenPopUpVC alloc] initWithNibName:NIB_NAME bundle:Nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateView];
    [self setUpGestureRecognizers];
}

#pragma mark - View

- (void)updateView
{
    self.titleLabel.text = self.title;
    self.textLabel.text = self.text;
    [self.mainButton setTitle:self.mainButtonTitle forState:UIControlStateNormal];
    [self.otherButton setTitle:self.otherButonTitle forState:UIControlStateNormal];
    
    UIImage *image = [UIImage imageNamed:self.imageName];
    self.imageView.image = image;
}

#pragma mark - Set up

- (void)setUpGestureRecognizers
{
    UITapGestureRecognizer *textTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapHandler)];
    [self.textLabel addGestureRecognizer:textTapRecognizer];
    self.textLabel.userInteractionEnabled = YES;
}

#pragma mark - Handlers

- (void)textTapHandler
{
    
}

- (IBAction)otherButtonHandler {
    if ([self.delegate respondsToSelector:@selector(fullScreenPopUpDidTapOtherButton)]) {
        [self.delegate fullScreenPopUpDidTapOtherButton];
    }
}

- (IBAction)mainButtonHandler {
    if ([self.delegate respondsToSelector:@selector(fullScreenPopUpDidTapMainButton)]) {
        [self.delegate fullScreenPopUpDidTapMainButton];
    }
}

@end
