//
//  MSBigSportCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSport.h"

@interface MSBigSportCell : UICollectionViewCell


@property (nonatomic) int level;

@property (strong, nonatomic) MSSport *sport;

+ (void)registerToCollectionView:(UICollectionView *)collectionView;
+ (NSString *)reusableIdentifier;
+ (CGSize)size;

@end
