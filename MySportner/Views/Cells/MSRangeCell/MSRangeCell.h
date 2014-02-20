//
//  MSRangeCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSRangeCell : UITableViewCell

@property (nonatomic) float maximumValue;
@property (nonatomic) float minimumValue;
@property (nonatomic) float lowerValue;
@property (nonatomic) float upperValue;
@property (nonatomic) float stepValue;

+ (NSString *)reusableIdentifier;
+ (void)registerToTableView:(UITableView *)tableView;
+ (CGFloat)height;


- (void)updateSliderLabels;

@end
