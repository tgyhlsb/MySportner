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
#import "TKAlertCenter.h"

#import "MSAttendeesVC.h"
#import "MSCommentsVC.h"
#import "MSInviteSportnersVC.h"
#import "MSProfileVC.h"
#import "MSMessageVC.h"

#define NIB_NAME @"MSGameProfileVC"

typedef NS_ENUM(int, MSUserStatusForActivity) {
    MSUserStatusForActivityOwner,
    MSUserStatusForActivityOwnerFull,
    MSUserStatusForActivityConfirmed,
    MSUserStatusForActivityInvited,
    MSUserStatusForActivityInvitedFull,
    MSUserStatusForActivityAwaiting,
    MSUserStatusForActivityOther,
    MSUserStatusForActivityOtherFull
};

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

@property (nonatomic) MSUserStatusForActivity sportnerStatus;

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
    
    [self startLoading];
    [self registerToActivityNotifications];
    [self registerGestureRecognizers];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self layoutBasedOnFrames];
    [self tryToUpdateInformationView];
}

- (BOOL)allInformationsAreFetched
{
    return YES;
    return self.activity.comments && self.activity.participants && self.activity.guests && self.activity.awaitings;
}

#pragma mark - Appearance

- (void)setUpAppearance
{
    self.title = @"GAME PROFILE";
    
    self.loadingIndicator.color = [MSColorFactory mainColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.roundedView.backgroundColor = [MSColorFactory redLight];
    
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
    self.descriptionLabel.text = self.activity.whereExactly;
    self.ownerLabel.text = self.activity.owner.firstName;
    self.ownerPictureView.sportner = self.activity.owner;
    self.levelLabel.attributedText = [self attributedStringForLevel:[self.activity.level integerValue]];
    self.playerSizeView.numberOfPlayer = [self.activity.playerNeeded integerValue];
    
    [self setViewWithDate:self.activity.date];
    
    NSInteger nbPlayers = [self.activity.maxPlayer integerValue] - [self.activity.playerNeeded integerValue];
    NSInteger nbComments = [self.activity.nbComment integerValue];
    
    self.attendeesValueLabel.text = [NSString stringWithFormat:@"%ld", (long)nbPlayers];
    self.commentsValueLabel.text = [NSString stringWithFormat:@"%ld", (long)nbComments];
    
    self.sportnerStatus = [self statusForSportner:[MSSportner currentSportner]];
}

- (MSUserStatusForActivity)statusForSportner:(MSSportner *)sportner
{
    MSUserStatusForActivity status = 0;
    
    if ([self.activity.owner isEqualToSportner:sportner]) {
        
        if ([self.activity.playerNeeded integerValue]) {
            status = MSUserStatusForActivityOwner;
        } else {
            status = MSUserStatusForActivityOwnerFull;
        }
        
    } else if ([self.activity.awaitings containsObject:sportner]) {
        
        status = MSUserStatusForActivityAwaiting;
        
    } else if ([self.activity.participants containsObject:sportner]) {
        
        status = MSUserStatusForActivityConfirmed;
        
    } else if ([self.activity.guests containsObject:sportner]) {
        
        if ([self.activity.playerNeeded integerValue]) {
            status = MSUserStatusForActivityInvited;
        } else {
            status = MSUserStatusForActivityInvitedFull;
        }
    } else {
        
        if ([self.activity.playerNeeded integerValue]) {
            status = MSUserStatusForActivityOther;
        } else {
            status = MSUserStatusForActivityOtherFull;
        }
    }
    
    return status;
}

- (void)setButtonForStatus:(MSUserStatusForActivity)status
{
    if ([self.activity.playerNeeded integerValue]) {
        [self.mainButton setTitle:@"INVITE SPORTNERS" forState:UIControlStateNormal];
        [MSStyleFactory setQBFlatButton:self.mainButton withStyle:MSFlatButtonStyleGreen];
        self.mainButton.userInteractionEnabled = YES;
    } else {
        [self.mainButton setTitle:@"FULL" forState:UIControlStateNormal];
        [MSStyleFactory setQBFlatButton:self.mainButton withStyle:MSFlatButtonStyleGray];
        self.mainButton.userInteractionEnabled = NO;
    }
    
    switch (status) {
        case MSUserStatusForActivityOwner:
        {
            [self setButtonEnabled:YES withTitle:@"INVITE SPORTNER"];
            break;
        }
        case MSUserStatusForActivityOwnerFull:
        {
            [self setButtonEnabled:NO withTitle:@"FULL"];
            break;
        }
        case MSUserStatusForActivityInvited:
        {
            [self setButtonEnabled:YES withTitle:@"JOIN THE GAME"];
            break;
        }
        case MSUserStatusForActivityInvitedFull:
        {
            [self setButtonEnabled:NO withTitle:@"FULL"];
            break;
        }
        case MSUserStatusForActivityOther:
        {
            [self setButtonEnabled:YES withTitle:@"JOIN THE GAME"];
            break;
        }
        case MSUserStatusForActivityOtherFull:
        {
            [self setButtonEnabled:NO withTitle:@"FULL"];
            break;
        }
        case MSUserStatusForActivityAwaiting:
        {
            [self setButtonEnabled:NO withTitle:@"AWAITING REPLY"];
            break;
        }
        case MSUserStatusForActivityConfirmed:
        {
            [self setButtonEnabled:YES withTitle:@"LEAVE THE GAME"];
            break;
        }
    }
}

- (void)setSportnerStatus:(MSUserStatusForActivity)sportnerStatus
{
    _sportnerStatus = sportnerStatus;
    
    [self setButtonForStatus:sportnerStatus];
}

- (void)setButtonEnabled:(BOOL)enabled withTitle:(NSString *)title
{
    [self.mainButton setTitle:title forState:UIControlStateNormal];
    
    if (enabled) {
        [MSStyleFactory setQBFlatButton:self.mainButton withStyle:MSFlatButtonStyleGreen];
    } else {
        [MSStyleFactory setQBFlatButton:self.mainButton withStyle:MSFlatButtonStyleGray];
    }
    self.mainButton.enabled = enabled;
}

- (void)setViewWithDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"EEE"];
    self.dateLabel1.text = [dateFormat stringFromDate:date];
    
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    [dateFormat setDateFormat:@"MMM"];
    NSString *shortMonth = [dateFormat stringFromDate:date];
    self.dateLabel2.text = [NSString stringWithFormat:@"%@ %ld", shortMonth, (long)[components day]];
    
    
    NSDateFormatter* timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setTimeStyle:NSDateFormatterShortStyle];
    self.dateLabel3.text = [timeFormat stringFromDate:date];
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

- (void)registerGestureRecognizers
{
    UITapGestureRecognizer *ownerPictureTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerTapHandler)];
    [self.ownerPictureView addGestureRecognizer:ownerPictureTapRecognizer];
    self.ownerPictureView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *ownerLabelTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerTapHandler)];
    [self.ownerLabel addGestureRecognizer:ownerLabelTapRecognizer];
    self.ownerLabel.userInteractionEnabled = YES;
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

- (IBAction)mainButtonHandler
{
    switch (self.sportnerStatus) {
        case MSUserStatusForActivityOwner:
        {
            [self inviteSportners];
            break;
        }
        case MSUserStatusForActivityInvited:
        {
            [self joinTheGame];
            break;
        }
        case MSUserStatusForActivityOther:
        {
            [self joinTheGame];
            break;
        }
        case MSUserStatusForActivityConfirmed:
        {
            [self leaveTheGame];
            break;
        }
            
        default:
            break;
    }
}

- (void)ownerTapHandler
{
    MSProfileVC *destination = [MSProfileVC newController];
    destination.sportner = self.activity.owner;
    destination.hasDirectAccessToDrawer = NO;
    [self.navigationController pushViewController:destination animated:YES];
}

#pragma mark - Game Actions

- (void)inviteSportners
{
    MSInviteSportnersVC *destination = [MSInviteSportnersVC newController];
    destination.activity = self.activity;
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)joinTheGame
{
    switch (self.sportnerStatus) {
        case MSUserStatusForActivityOther:
        {
            [self.activity addAwaiting:[MSSportner currentSportner] withBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded && !error) {
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"A request has been sent to the owner"];
                }
                if (error) {
                    NSLog(@"%@", error);
                }
            }];
            break;
        }
        case MSUserStatusForActivityInvited:
        {
            [self.activity addParticipant:[MSSportner currentSportner] withBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded && !error) {
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You joined the game !"];
                }
                
                if (error) {
                    NSLog(@"%@", error);
                }
                
            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)leaveTheGame
{
    [self.activity removeParticipant:[MSSportner currentSportner] withBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded && !error) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You left the game"];
        }
        
        if (error) {
            NSLog(@"%@", error);
        }
        
    }];
}


#pragma mark - Navigation

- (void)pushToAttendees
{
    MSAttendeesVC *destination = [MSAttendeesVC newController];
    destination.activity = self.activity;
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)pushToComments
{
//    MSCommentsVC *destination = [MSCommentsVC newController];
//    destination.activity = self.activity;
    
    MSMessageVC *destination = [MSMessageVC new];
    destination.activity = self.activity;
    
    [self.navigationController pushViewController:destination animated:YES];
}

@end
