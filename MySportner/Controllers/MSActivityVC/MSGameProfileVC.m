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

#import "MSAttendeesVC.h"

#define NIB_NAME @"MSGameProfileVC"

@interface MSGameProfileVC ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

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
    
    [self registerToActivityNotifications];
    [self tryToUpdateInformationView];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self layoutBasedOnFrames];
}

- (BOOL)allInformationsAreFetched
{
    return self.activity.comments && self.activity.participants && self.activity.guests && self.activity.awaitings;
}

#pragma mark - Appearance

- (void)setUpAppearance
{
    self.title = @"GAME PROFILE";
    
    self.loadingIndicator.color = [MSColorFactory mainColor];
    
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

- (void)tryToUpdateInformationView
{
    [self startLoading];
    if ([self allInformationsAreFetched]) {
        [self updateInformationView];
        [self stopLoading];
    } else {
        [self.activity fetchComments];
        [self.activity fetchGuests];
        [self.activity fetchParticipants];
        [self.activity fetchAwaitings];
    }
}

- (void)updateInformationView
{
    self.sportLabel.text = self.activity.sport.name;
    self.placeLabel.text = self.activity.place;
    self.descriptionLabel.text = @"Soon";
    self.ownerLabel.text = self.activity.owner.firstName;
    self.ownerPictureView.sportner = self.activity.owner;
    self.levelLabel.attributedText = [self attributedStringForLevel:[self.activity.level integerValue]];
    self.playerSizeView.numberOfPlayer = 3;
    
    self.dateLabel1.text = @"Mon.";
    self.dateLabel2.text = @"25 Aug.";
    self.dateLabel3.text = @"11:00 am";
    
    NSInteger nbPlayers = [self.activity.participants count];
    NSInteger nbComments = [self.activity.comments count];
    
    self.attendeesValueLabel.text = [NSString stringWithFormat:@"%ld", (long)nbPlayers];
    self.commentsValueLabel.text = [NSString stringWithFormat:@"%ld", (long)nbComments];
}

#define LEVEL_NAMES @[@"Novice", @"Rookie", @"Intermediate", @"Expert", @"Legend"]

- (NSAttributedString *)attributedStringForLevel:(NSInteger)level
{
    NSString *levelName = [[LEVEL_NAMES objectAtIndex:level] uppercaseString];
    
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

- (void)startLoading
{
    self.containerView.hidden = YES;
}

- (void)stopLoading
{
    self.containerView.hidden = NO;
}

#pragma mark - Activity notification

- (void)registerToActivityNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activityNotificationReceived)
                                                 name:MSNotificationActivityStateChanged
                                               object:self.activity];
}

- (void)activityNotificationReceived
{
    if ([self allInformationsAreFetched]) {
        [self updateInformationView];
        [self stopLoading];
    }
}

#pragma mark - Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    [self setView:touch.view highLighted:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] firstObject];
    [self setView:touch.view highLighted:NO];
    
    if ([touch.view isEqual:self.attendeesView]) {
        [self pushToAttendees];
    } else if ([touch.view isEqual:self.commentsView]) {
        [self pushToComments];
    }
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

#pragma mark - Navigation

- (void)pushToAttendees
{
    MSAttendeesVC *destination = [MSAttendeesVC newController];
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)pushToComments
{
    
}

@end
