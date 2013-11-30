//
//  MSActivityCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MSActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *ownerProfilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;

- (void)setAppearance;


+ (void)registerToTableview:(UITableView *)tableView;
+ (NSString *)reusableIdentifier;
+ (CGFloat)height;

@end
