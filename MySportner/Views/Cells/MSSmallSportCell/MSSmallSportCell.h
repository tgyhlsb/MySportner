//
//  MSSmallSportCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSport.h"

@interface MSSmallSportCell : UICollectionViewCell

@property (strong, nonatomic) MSSport *sport;

+ (void)registerToCollectionView:(UICollectionView *)collectionView;
+ (NSString *)reusableIdentifier;
+ (CGSize)size;

@end
