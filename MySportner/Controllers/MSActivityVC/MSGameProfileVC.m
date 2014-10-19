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
#import "MSStyleFactory.h"

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

@property (weak, nonatomic) IBOutlet UILabel *dateLabel1;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel2;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel3;


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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateInformationView];
    [self layoutBasedOnFrames];
}

#pragma mark - Appearance

- (void)setUpAppearance
{
    self.title = @"GAME PROFILE";
    
    self.roundedView.backgroundColor = [MSColorFactory redLight];
    
    [MSStyleFactory setQBFlatButton:self.mainButton withStyle:MSFlatButtonStyleGreen];
    
    self.sportLabel.textColor = [MSColorFactory redLight];
    self.sportLabel.font = [UIFont fontWithName:@"ProximaNova-SemiBold" size:23.0];
    
    self.placeLabel.textColor = [MSColorFactory grayDark];
    self.placeLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:16.0];
    
    self.descriptionLabel.textColor = [MSColorFactory grayDark];
    self.descriptionLabel.font = [UIFont fontWithName:@"ProximaNova-SemiBold" size:16.0];
    
    self.ownerLabel.textColor = [MSColorFactory redLight];
    self.ownerLabel.font = [UIFont fontWithName:@"ProximaNova-SemiBold" size:14.0];
}

- (void)layoutBasedOnFrames
{
    [self.roundedView setRounded];
}

- (void)updateInformationView
{
    self.sportLabel.text = @"Basket";
    self.placeLabel.text = @"Tououse, France";
    self.descriptionLabel.text = @"Gymnase sud Gymnase sud Gymnase sud Gymnase sud Gymnase sud";
    self.ownerLabel.text = [@"Paul" uppercaseString];
    self.levelLabel.attributedText = [self attributedStringForLevel:0];
    self.playerSizeView.numberOfPlayer = 3;
}

- (NSAttributedString *)attributedStringForLevel:(NSInteger)level
{
    NSString *levelName = @"Intermediate";
    
    NSDictionary *grayParams = @{
                                 NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Regular" size:16.0],
                                 NSForegroundColorAttributeName: [MSColorFactory grayDark]
                                 };
    
    NSDictionary *redParams = @{
                                NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-SemiBold" size:16.0],
                                NSForegroundColorAttributeName: [MSColorFactory redLight]
                                };
    
    NSMutableAttributedString *fixedString = [[NSMutableAttributedString alloc] initWithString:@"Level - " attributes:grayParams];
    NSMutableAttributedString *levelString = [[NSMutableAttributedString alloc] initWithString:[levelName uppercaseString] attributes:redParams];
    
    [fixedString appendAttributedString:levelString];
    return fixedString;
}

@end
