//
//  MSSmallSportCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSSmallSportCell : UICollectionViewCell

+ (void)registerToCollectionView:(UICollectionView *)collectionView;
+ (NSString *)reusableIdentifier;
+ (CGSize)size;

@end
