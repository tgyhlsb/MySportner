//
//  MSGameProfileCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 07/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSGameProfileCell.h"
#import "MSColorFactory.h"
#import "UIView+MSRoundedView.h"
#import "QBFlatButton.h"
#import "MSStyleFactory.h"
#import "MSFontFactory.h"
#import "MSProfilePictureView.h"
#import "TKAlertCenter.h"

#define HEIGHT 230

#define NIB_NAME @"MSGameProfileCell"


@interface MSGameProfileCell()

@property (weak, nonatomic) IBOutlet UIView *roundedView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet QBFlatButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet MSProfilePictureView *fbProfilePictureView;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;


@end

@implementation MSGameProfileCell

+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:NIB_NAME bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSGameProfileCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return NIB_NAME;
}


+ (CGFloat)height
{
    return HEIGHT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // do nothing
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    // do nothing
}

- (void)awakeFromNib
{
    self.backgroundColor = [MSColorFactory backgroundColorGrayLight];
    
    self.roundedView.backgroundColor = [MSColorFactory redLight];
    [self.roundedView setRounded];
    
    [self.addressLabel setNumberOfLines:0];
    [self.addressLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    [self.titleLabel setFont:[MSFontFactory fontForGameProfileSportTitle]];
    [self.titleLabel setTextColor:[MSColorFactory redLight]];
    
    [self.locationLabel setFont:[MSFontFactory fontForGameProfileSportInfo]];
    [self.locationLabel setTextColor:[MSColorFactory grayDark]];
    
    [self.addressLabel setFont:[MSFontFactory fontForGameProfileSportInfo]];
    [self.addressLabel setTextColor:[MSColorFactory grayDark]];
    
    [self.fbProfilePictureView setRounded];
    [self.ownerLabel setFont:[MSFontFactory fontForGameProfileSportInfo]];
    [self.ownerLabel setTextColor:[MSColorFactory grayDark]];
    [self.fbProfilePictureView setBackgroundColor:[UIColor clearColor]];
    
    [MSStyleFactory setUILabel:self.dayLabel withStyle:MSLabelStyleActivityDateBig];
    [MSStyleFactory setUILabel:self.monthLabel withStyle:MSLabelStyleActivityDateBig];
    [MSStyleFactory setUILabel:self.timeLabel withStyle:MSLabelStyleActivityDateBig];
    [self.timeLabel setFont:[MSFontFactory fontForGameProfileTime]];
    
    [MSStyleFactory setQBFlatButton:self.actionButton withStyle:MSFlatButtonStyleGreen];
    
    [self registerTapGestures];
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.color = [UIColor whiteColor];
        _activityIndicatorView.frame = self.actionButton.frame;
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    
    return _activityIndicatorView;
}

- (void)queryInfoToSetButtonTitle
{
    [self.actionButton setTitle:@"" forState:UIControlStateNormal];
    if ([self.activity.owner.username  isEqualToString:[MSUser currentUser].username]) {
        self.userMode = MSGameProfileModeOwner;
    } else {
        if (self.activity.guests && self.activity.participants) {
            [self updateButtonTitle];
        } else {
            [self.activityIndicatorView startAnimating];
            [self queryParticipantsAndGuests];
        }
    }    
}

- (void)updateButtonTitle
{
    if (self.activity.guests && self.activity.participants) {
        [self.activityIndicatorView stopAnimating];
        
        MSUser *currentUser = [MSUser currentUser];
        BOOL canJoin = YES;
        for (MSUser *user in self.activity.participants) {
            if ([user.username isEqualToString:currentUser.username]) {
                canJoin = NO;
            }
        }
        
        self.userMode = canJoin ? MSGameProfileModeOther : MSGameProfileModeParticipant;
    }
}

- (void)setUserMode:(MSGameProfileMode)userMode
{
    _userMode = userMode;
    switch (userMode) {
        case MSGameProfileModeOwner:
        {
            [self.activityIndicatorView stopAnimating];
            [self.actionButton setTitle:@"INVITE" forState:UIControlStateNormal];
            break;
        }
        case MSGameProfileModeParticipant:
        {
            [self.activityIndicatorView stopAnimating];
            [self.actionButton setTitle:@"LEAVE" forState:UIControlStateNormal];
            break;
        }
        case MSGameProfileModeOther:
        {
            [self.activityIndicatorView stopAnimating];
            [self.actionButton setTitle:@"JOIN" forState:UIControlStateNormal];
            break;
        }
        case MSGameProfileModeLoading:
        {
            [self.activityIndicatorView startAnimating];
            [self.actionButton setTitle:@"" forState:UIControlStateNormal];
            break;
        }
    }
}


- (void)queryParticipantsAndGuests
{
    [self.activity querySportnersWithTarget:self callBack:@selector(didLoadGuestsAndParticipantsWithError:)];
}

- (void)didLoadGuestsAndParticipantsWithError:(NSError *)error
{
    if (!error) {
        [self updateButtonTitle];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Connection failed"];
    }
}

- (void)registerTapGestures
{
    UITapGestureRecognizer *pictureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerProfileTapHandler)];
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerProfileTapHandler)];
    
    self.ownerLabel.userInteractionEnabled = YES;
    self.fbProfilePictureView.userInteractionEnabled = YES;
    
    [self.ownerLabel addGestureRecognizer:nameTap];
    [self.fbProfilePictureView addGestureRecognizer:pictureTap];
}

- (void)ownerProfileTapHandler
{
    if ([self.delegate respondsToSelector:@selector(gameProfileCell:didSelectUser:)]) {
        [self.delegate gameProfileCell:self didSelectUser:self.activity.owner];
    }
}
- (IBAction)actionButtonHandler
{
    if ([self.delegate respondsToSelector:@selector(gameProfileCellDidTrigerActionHandler:)]) {
        [self.delegate gameProfileCellDidTrigerActionHandler:self];
    }
}

- (void)setViewWithDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    self.dayLabel.text = [NSString stringWithFormat:@"%ld", (long)[components day]];
    
    [dateFormat setDateFormat:@"MMM"];
    self.monthLabel.text = [dateFormat stringFromDate:date];
    [dateFormat setDateFormat:@"hh:mm"];
    self.timeLabel.text = [dateFormat stringFromDate:date];
}

- (void)setActivity:(MSActivity *)activity
{
    _activity = activity;
    
    if (activity) {
        [self queryInfoToSetButtonTitle];
        self.titleLabel.text = activity.sport;
        self.locationLabel.text = activity.place;
        self.addressLabel.text = activity.place;
        self.fbProfilePictureView.user = activity.owner;
        self.ownerLabel.text = [activity.owner fullName];
        [self setViewWithDate:activity.date];
    }
}

@end
