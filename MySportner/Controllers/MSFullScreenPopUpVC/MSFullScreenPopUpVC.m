//
//  MSFullScreenPopUpVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 18/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSFullScreenPopUpVC.h"
#import "QBFlatButton.h"
#import "MSStyleFactory.h"

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
    [self setUpAppearance];
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
}

- (void)setUpAppearance
{
    self.imageView.backgroundColor = [UIColor clearColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.otherButton.backgroundColor = [UIColor clearColor];
    self.mainButton.backgroundColor = [UIColor clearColor];
    
    [MSStyleFactory setQBFlatButton:self.mainButton withStyle:MSFlatButtonStyleGreen];
    
    self.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:26.0];
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    self.textLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0];
    
    [self.otherButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.45] forState:UIControlStateNormal];
    self.otherButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:12.0];
    
}

#pragma mark - Getters & Setters

- (void)setMainButtonTitle:(NSString *)mainButtonTitle
{
    _mainButtonTitle = mainButtonTitle;
    
    [self updateView];
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    [self updateView];
}

- (void)setOtherButonTitle:(NSString *)otherButonTitle
{
    _otherButonTitle = otherButonTitle;
    
    [self updateView];
}

- (void)setTextTitle:(NSString *)textTitle
{
    _textTitle = textTitle;
    
    [self updateView];
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    
    [self updateView];
}

#pragma mark - View

- (void)updateView
{
    self.titleLabel.text = self.textTitle;
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
