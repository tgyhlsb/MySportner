//
//  MSBigSportCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSBigSportCell.h"

#define IDENTIFIER @"MSBigSportCell"
#define HEIGHT 130
#define WIDTH 130

@interface MSBigSportCell()


@end

@implementation MSBigSportCell

+ (void)registerToCollectionView:(UICollectionView *)collectionView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:[MSBigSportCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

+ (CGSize)size
{
    return CGSizeMake(WIDTH, HEIGHT);
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        self.backgroundColor = [UIColor yellowColor];
    }
    else
    {
        self.backgroundColor = [UIColor grayColor];
    }
}



@end
