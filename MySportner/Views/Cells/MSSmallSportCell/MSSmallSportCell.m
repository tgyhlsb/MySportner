//
//  MSSmallSportCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSSmallSportCell.h"

#define IDENTIFIER @"MSSmallSportCell"
#define HEIGHT 80
#define WIDTH 80


@implementation MSSmallSportCell

+ (void)registerToCollectionView:(UICollectionView *)collectionView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:[MSSmallSportCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

+ (CGSize)size
{
    return CGSizeMake(WIDTH, HEIGHT);
}

@end
