//
//  MSRangeCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSRangeCell.h"
#import "NMRangeSlider.h"

#define NIB_NAME @"MSRangeCell"
#define HEIGHT 70

@interface MSRangeCell()

@property (weak, nonatomic) IBOutlet NMRangeSlider *rangeSlider;
@property (weak, nonatomic) IBOutlet UILabel *lowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLabel;


@end

@implementation MSRangeCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // do nothing
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.rangeSlider.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
//    self.rangeSlider.stepValueContinuously = YES;
    
    [self updateSliderLabels];
}

+ (NSString *)reusableIdentifier
{
    return NIB_NAME;
}

+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:NIB_NAME bundle:Nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSRangeCell reusableIdentifier]];
}

+ (CGFloat)height;
{
    return HEIGHT;
}

#pragma mark - Setters

- (void)setMaximumValue:(float)maximumValue
{
    self.rangeSlider.maximumValue = maximumValue;
    _maximumValue = maximumValue;
}

- (void)setMinimumValue:(float)minimumValue
{
    _minimumValue = minimumValue;
    self.rangeSlider.minimumValue = minimumValue;
}

- (void)setLowerValue:(float)lowerValue
{
    _lowerValue = lowerValue;
    self.rangeSlider.lowerValue = lowerValue;
}

- (void)setUpperValue:(float)upperValue
{
    _upperValue = upperValue;
    self.rangeSlider.upperValue = upperValue;
}

- (void)setStepValue:(float)stepValue
{
    _stepValue = stepValue;
    self.rangeSlider.stepValue = stepValue;
}

#pragma mark - Value Label update

- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.rangeSlider.lowerCenter.x + self.rangeSlider.frame.origin.x);
    lowerCenter.y = (self.rangeSlider.center.y - 30.0f);
    self.lowerLabel.center = lowerCenter;
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.rangeSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.rangeSlider.upperCenter.x + self.rangeSlider.frame.origin.x);
    upperCenter.y = (self.rangeSlider.center.y - 30.0f);
    self.upperLabel.center = upperCenter;
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.rangeSlider.upperValue];
}

// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    [self updateSliderLabels];
}

@end