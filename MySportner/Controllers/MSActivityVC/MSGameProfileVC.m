//
//  MSGameProfileVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSGameProfileVC.h"

#import "MSProfilePictureView.h"
#import "QBFlatButton.h"
#import "MSPlayerSizeView.h"
#import "UIView+MSRoundedView.h"

#import "MSColorFactory.h"

#define NIB_NAME @"MSGameProfileVC"

@interface MSGameProfileVC ()
@property (weak, nonatomic) IBOutlet UIView *roundedView;
@property (weak, nonatomic) IBOutlet UILabel *sportLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet MSProfilePictureView *ownerPictureView;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet MSPlayerSizeView *playerSizeView;
@property (weak, nonatomic) IBOutlet QBFlatButton *mainButton;

@end

@implementation MSGameProfileVC


+ (instancetype)newController
{
    MSGameProfileVC *controller = [[MSGameProfileVC alloc] initWithNibName:NIB_NAME bundle:nil];
    controller.hasDirectAccessToDrawer = NO;
    return controller;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpAppearance];
    
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - Appearance

- (void)setUpAppearance
{
    [self.roundedView setRounded];
    self.roundedView.backgroundColor = [MSColorFactory redLight];
}

@end
