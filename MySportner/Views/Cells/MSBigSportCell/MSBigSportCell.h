//
//  MSBigSportCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSBigSportCell : UICollectionViewCell


@property (nonatomic) int level;

@property (strong, nonatomic) NSString *imageNameNormal;
@property (strong, nonatomic) NSString *imageNameSelected;
@property (strong, nonatomic) NSString *sportName;

+ (void)registerToCollectionView:(UICollectionView *)collectionView;
+ (NSString *)reusableIdentifier;
+ (CGSize)size;

@end
