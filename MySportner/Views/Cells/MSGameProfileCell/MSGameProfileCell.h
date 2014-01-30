//
//  MSGameProfileCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 07/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSActivity.h"
#import "MSCell.h"

typedef NS_ENUM(int, MSGameProfileMode) {
    MSGameProfileModeOwner,
    MSGameProfileModeParticipant,
    MSGameProfileModeOther,
    MSGameProfileModeLoading
};

@protocol MSGameProfileCellDelegate;

@interface MSGameProfileCell : MSCell

@property (strong, nonatomic) id<MSGameProfileCellDelegate> delegate;
@property (strong, nonatomic) MSActivity *activity;
@property (nonatomic) MSGameProfileMode userMode;

+ (void)registerToTableView:(UITableView *)tableView;
+ (NSString *)reusableIdentifier;

@end

@protocol MSGameProfileCellDelegate <NSObject>

- (void)gameProfileCell:(MSGameProfileCell *)cell didSelectUser:(MSUser *)user;

- (void)gameProfileCellDidTrigerActionHandler:(MSGameProfileCell *)cell;


@end
