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

#define HEIGHT 230

#define NIB_NAME @"MSGameProfileCell"

@interface MSGameProfileCell()

@property (weak, nonatomic) IBOutlet UIView *roundedView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet QBFlatButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *fbProfilePictureView;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


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
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
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
    
    [self.actionButton setTitle:@"INVITE" forState:UIControlStateNormal];
    [MSStyleFactory setQBFlatButton:self.actionButton withStyle:MSFlatButtonStyleGreen];
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
        self.titleLabel.text = activity.sport;
        self.locationLabel.text = activity.place;
        self.addressLabel.text = activity.place;
        self.fbProfilePictureView.profileID = activity.owner.facebookID;
        self.ownerLabel.text = [activity.owner fullName];
        [self setViewWithDate:activity.date];
    }
}

@end
