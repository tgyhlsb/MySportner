//
//  MSActivityCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSActivityCell.h"
#import "UIView+MSRoundedView.h"
#import "QBFlatButton.h"
#import "MSColorFactory.h"
#import "MSFontFactory.h"
#import "MSStyleFactory.h"
#import "MSProfilePictureView.h"


#define IDENTIFIER @"MSActivityCell"
#define HEIGHT 100.0

@interface MSActivityCell()

@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet QBFlatButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic) BOOL oddIndex;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet MSProfilePictureView *ownerProfilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;


@end

@implementation MSActivityCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self registerGestureRecognizers];
}

- (void)registerGestureRecognizers
{
    UITapGestureRecognizer *pictureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sportnerProfileTapHandler)];
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sportnerProfileTapHandler)];
    
    self.ownerProfilePictureView.userInteractionEnabled = YES;
    self.ownerNameLabel.userInteractionEnabled = YES;
    
    [self.ownerProfilePictureView addGestureRecognizer:pictureTap];
    [self.ownerNameLabel addGestureRecognizer:nameTap];
}

- (void)sportnerProfileTapHandler
{
    if ([self.delegate respondsToSelector:@selector(activityCell:didSelectSportner:)]) {
        [self.delegate activityCell:self didSelectSportner:self.activity.owner];
    }
}

- (void)setActivity:(MSActivity *)activity
{
    _activity = activity;
    [self setViewWithDate:activity.date];
    
    self.titleLabel.text = activity.sport;
    self.placeLabel.text = activity.place;
    self.ownerNameLabel.text = [activity.owner fullName];
    self.ownerProfilePictureView.sportner = activity.owner;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // do nothing
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.backgroundColor = [MSColorFactory redDark];
        self.roundView.backgroundColor = [MSColorFactory whiteLight];
        self.titleLabel.textColor = [MSColorFactory whiteLight];
        self.ownerNameLabel.textColor = [MSColorFactory whiteLight];
        self.placeLabel.textColor = [MSColorFactory whiteLight];
    } else {
        if (self.oddIndex) {
            self.backgroundColor = [MSColorFactory backgroundColorGrayLight];
        } else {
            self.backgroundColor = [MSColorFactory whiteLight];
        }
        self.roundView.backgroundColor = [MSColorFactory redLight];
        self.titleLabel.textColor = [MSColorFactory redLight];
        self.ownerNameLabel.textColor = [MSColorFactory grayDark];
        self.placeLabel.textColor = [MSColorFactory grayDark];
    }
    
}

- (void)setAppearanceWithOddIndex:(BOOL)oddIndex
{
    [self.roundView setRounded];
    [self.ownerProfilePictureView setRounded];
    
    self.roundView.backgroundColor = [MSColorFactory redLight];
    
    self.titleLabel.textColor = [MSColorFactory redLight];
    
    self.ownerNameLabel.font = [MSFontFactory fontForCellInfo];
    self.placeLabel.font = [MSFontFactory fontForCellInfo];
    self.titleLabel.font = [MSFontFactory fontForCellAcivityTitle];
    
    self.actionButton.faceColor = [MSColorFactory redLight];
    self.actionButton.margin = 0.0f;
    self.actionButton.depth = 0.0f;
    self.actionButton.radius = 3.0f;
    
    [MSStyleFactory setUILabel:self.dayLabel withStyle:MSLabelStyleActivityDateSmall];
    [MSStyleFactory setUILabel:self.monthLabel withStyle:MSLabelStyleActivityDateSmall];
    [MSStyleFactory setUILabel:self.timeLabel withStyle:MSLabelStyleActivityDateSmall];
    [self.timeLabel setFont:[MSFontFactory fontForActivityCellTime]];
    
    self.oddIndex = oddIndex;
    [self setHighlighted:NO animated:NO];

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

+ (void)registerToTableview:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSActivityCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

+ (CGFloat)height
{
    return HEIGHT;
}

- (IBAction)joinButtonPress:(UIButton *)sender
{
    
}


@end
