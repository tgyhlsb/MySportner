//
//  MSBigSportCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSportLevel.h"

@interface MSBigSportCell : UICollectionViewCell

@property (strong, nonatomic) MSSportLevel *sportLevel;

+ (void)registerToCollectionView:(UICollectionView *)collectionView;
+ (NSString *)reusableIdentifier;
+ (CGSize)size;

@end
