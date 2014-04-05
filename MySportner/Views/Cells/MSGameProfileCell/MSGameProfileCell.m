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

#define NIB_NAME @"MSGameProfileCell2"


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
@property (weak, nonatomic) IBOutlet UILabel *dayAndMonthLabel;

@property (strong, nonatomic) UIView *separatorView;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet QBFlatButton *backgroundButton;

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

- (UIView *)separatorView
{
    if (_separatorView) {
        CGRect frame = CGRectMake(14, 10, 10, 140);
        _separatorView = [[UIView alloc] initWithFrame:frame];
        _separatorView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_separatorView];
    }
    return _separatorView;
}

- (void)awakeFromNib
{
    self.backgroundColor = [MSColorFactory backgroundColorGrayLight];
    
    self.userMode = MSGameProfileModeLoading;
    
    self.roundedView.backgroundColor = [MSColorFactory redLight];
    [self.roundedView setRounded];
    
    [self.addressLabel setNumberOfLines:0];
    [self.addressLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    [self.titleLabel setFont:[MSFontFactory fontForGameProfileSportTitle]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    
    [self.locationLabel setFont:[MSFontFactory fontForGameProfileSportInfo]];
    [self.locationLabel setTextColor:[UIColor whiteColor]];
    
    [self.addressLabel setFont:[MSFontFactory fontForGameProfileSportInfo]];
    [self.addressLabel setTextColor:[UIColor whiteColor]];
    
    [self.fbProfilePictureView setRounded];
    [self.ownerLabel setFont:[MSFontFactory fontForGameProfileSportInfo]];
    [self.ownerLabel setTextColor:[UIColor whiteColor]];
    [self.fbProfilePictureView setBackgroundColor:[UIColor clearColor]];
    
    [MSStyleFactory setUILabel:self.dayLabel withStyle:MSLabelStyleActivityDateBig];
    [MSStyleFactory setUILabel:self.monthLabel withStyle:MSLabelStyleActivityDateBig];
    [MSStyleFactory setUILabel:self.dayAndMonthLabel withStyle:MSLabelStyleActivityDateBig];
    [MSStyleFactory setUILabel:self.timeLabel withStyle:MSLabelStyleActivityDateBig];
    [self.timeLabel setFont:[MSFontFactory fontForGameProfileTime]];
    
    self.backgroundButton.faceColor = [MSColorFactory redLight];
    self.backgroundButton.sideColor = [MSColorFactory redDark];
    self.backgroundButton.backgroundColor = [UIColor clearColor];
    
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
    if ([self.activity.owner isEqualToSportner:[MSSportner currentSportner]]) {
        self.userMode = MSGameProfileModeOwner;
    } else {
        if (self.activity.guests && self.activity.participants && self.activity.awaitings) {
            [self updateButtonTitle];
        } else {
            NSLog(@"Can't display participants / guests / awaitings");
        }
    }    
}

- (void)updateButtonTitle
{
    MSSportner *currentSportner = [MSSportner currentSportner];
    if ([self.activity.owner isEqualToSportner:currentSportner]) {
        self.userMode = MSGameProfileModeOwner;
    } else if (self.activity.guests && self.activity.participants && self.activity.awaitings) {
        [self.activityIndicatorView stopAnimating];
        
        BOOL isParticipant = NO;
        for (MSSportner *sportner in self.activity.participants) {
            if ([sportner isEqualToSportner:currentSportner]) {
                isParticipant = YES;
            }
        }
        BOOL isAwaiting = NO;
        for (MSSportner *sportner in self.activity.awaitings) {
            if ([sportner isEqualToSportner:currentSportner]) {
                isAwaiting = YES;
            }
        }
        
        self.userMode = (isParticipant ? MSGameProfileModeParticipant : (isAwaiting ? MSGameProfileModeAwaiting : MSGameProfileModeOther));
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
        case MSGameProfileModeAwaiting:
        {
            [self.activityIndicatorView stopAnimating];
            [self.actionButton setTitle:@"WAITING" forState:UIControlStateNormal];
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
    if ([self.delegate respondsToSelector:@selector(gameProfileCell:didSelectSportner:)]) {
        [self.delegate gameProfileCell:self didSelectSportner:self.activity.owner];
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
    NSString *day = [NSString stringWithFormat:@"%ld", (long)[components day]];
    self.dayLabel.text = day;
    
    [dateFormat setDateFormat:@"MMM"];
    NSString *month = [dateFormat stringFromDate:date];
    self.monthLabel.text = month;
    
    self.dayAndMonthLabel.text = [day stringByAppendingFormat:@" %@", month];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale: [NSLocale currentLocale]];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.timeLabel.text = [dateFormatter stringFromDate:date];
}

- (void)setActivity:(MSActivity *)activity
{
    _activity = activity;
    
    if (activity) {
        [self updateButtonTitle];
        self.titleLabel.text = activity.sport.name;
        self.locationLabel.text = activity.place;
        self.addressLabel.text = activity.place;
        self.fbProfilePictureView.sportner = activity.owner;
        self.ownerLabel.text = [activity.owner fullName];
        [self setViewWithDate:activity.date];
    }
}

@end
