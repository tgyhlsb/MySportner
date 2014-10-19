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

@property (weak, nonatomic) IBOutlet UIView *informationView;

@property (weak, nonatomic) IBOutlet UIView *commentsView;
@property (weak, nonatomic) IBOutlet UILabel *commentsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsValueLabel;

@property (weak, nonatomic) IBOutlet UIView *attendeesView;
@property (weak, nonatomic) IBOutlet UILabel *attendeesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendeesValueLabel;
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    self.dateLabel1.textColor = [UIColor whiteColor];
    self.dateLabel1.font = [UIFont fontWithName:@"ProximaNova-Light" size:22.0];
    
    self.dateLabel2.textColor = [UIColor whiteColor];
    self.dateLabel2.font = [UIFont fontWithName:@"ProximaNova-SemiBold" size:22.0];
    
    self.dateLabel3.textColor = [UIColor whiteColor];
    self.dateLabel3.font = [UIFont fontWithName:@"ProximaNova-Light" size:20.0];
    
    self.informationView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.informationView.layer.shadowOpacity = 0.08;
    self.informationView.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.informationView.layer.shadowRadius = 0;
    self.informationView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:246.0/255.0 blue:249.0/255.0 alpha:1.0];
    
    self.commentsTitleLabel.text = @"Comments";
    self.commentsView.backgroundColor = [UIColor whiteColor];
    self.commentsTitleLabel.textColor = [MSColorFactory redLight];
    self.commentsTitleLabel.font = [UIFont fontWithName:@"ProximaNova-SemiBold" size:18.0];
    self.commentsValueLabel.textColor = [MSColorFactory redLight];
    self.commentsValueLabel.font = [UIFont fontWithName:@"ProximaNova-SemiBold" size:18.0];
    
    self.attendeesTitleLabel.text = @"Attendees";
    self.attendeesView.backgroundColor = [UIColor whiteColor];
    self.attendeesTitleLabel.textColor = [MSColorFactory redLight];
    self.attendeesTitleLabel.font = [UIFont fontWithName:@"ProximaNova-SemiBold" size:18.0];
    self.attendeesValueLabel.textColor = [MSColorFactory redLight];
    self.attendeesValueLabel.font = [UIFont fontWithName:@"ProximaNova-SemiBold" size:18.0];
    
    self.commentsView.layer.borderColor = [[UIColor colorWithWhite:0.0 alpha:0.08] CGColor];
    self.commentsView.layer.borderWidth = 1.0;
}

- (void)layoutBasedOnFrames
{
    [self.roundedView setRounded];
    [self.ownerPictureView setRounded];
}

- (void)updateInformationView
{
    self.sportLabel.text = @"Basket";
    self.placeLabel.text = @"ToulouseToulouse, FranceFranceFrance";
    self.descriptionLabel.text = @"Gymnase sud Gymnase sud Gymnase sud Gymnase sud Gymnase sud";
    self.ownerLabel.text = [@"Paul" uppercaseString];
    self.ownerPictureView.sportner = [MSSportner currentSportner];
    self.levelLabel.attributedText = [self attributedStringForLevel:0];
    self.playerSizeView.numberOfPlayer = 3;
    
    self.dateLabel1.text = @"Mon.";
    self.dateLabel2.text = @"25 Aug.";
    self.dateLabel3.text = @"11:00 am";
    
    self.attendeesValueLabel.text = @"3";
    self.commentsValueLabel.text = @"3";
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    [self setView:touch.view highLighted:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    [self setView:touch.view highLighted:NO];
}

- (void)setView:(UIView *)view highLighted:(BOOL)highlighted
{
    if ([view isEqual:self.commentsView]) {
        self.commentsView.backgroundColor = highlighted ? [MSColorFactory redLight] : [UIColor whiteColor];
        self.commentsTitleLabel.textColor = highlighted ? [UIColor whiteColor] : [MSColorFactory redLight];
        self.commentsValueLabel.textColor = highlighted ? [UIColor whiteColor] : [MSColorFactory redLight];
    } else if ([view isEqual:self.attendeesView]) {
        self.attendeesView.backgroundColor = highlighted ? [MSColorFactory redLight] : [UIColor whiteColor];
        self.attendeesTitleLabel.textColor = highlighted ? [UIColor whiteColor] : [MSColorFactory redLight];
        self.attendeesValueLabel.textColor = highlighted ? [UIColor whiteColor] : [MSColorFactory redLight];
    }
}

@end
