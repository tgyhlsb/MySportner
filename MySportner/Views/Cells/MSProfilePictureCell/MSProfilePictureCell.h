//
//  MSProfilePictureCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 04/02/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSportner.h"

typedef NS_ENUM(NSUInteger, MSProfilePictureCellType) {
    MSProfilePictureCellParticipant,
    MSProfilePictureCellGuest
};

@interface MSProfilePictureCell : UICollectionViewCell

@property (strong, nonatomic) MSSportner *sportner;
@property (nonatomic) MSProfilePictureCellType sportnerType;

+ (NSString *)reusableIdentifier;
+ (void)registerToCollectionView:(UICollectionView *)collectionView;

@end
