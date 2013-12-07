//
//  MSSmallSportCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSSmallSportCell.h"
#import "UIView+MSRoundedView.h"
#import "MSColorFactory.h"
#import "MSFontFactory.h"

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

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        self.titleLabel.textColor = [MSColorFactory whiteLight];
        self.backgroundColor = [MSColorFactory redLight];
    }
    else
    {
        self.titleLabel.textColor = [MSColorFactory grayDark];
        self.backgroundColor = [MSColorFactory whiteLight];
    }
}

- (void)awakeFromNib
{
    [self setCornerRadius:3.0f];
    self.titleLabel.font = [MSFontFactory fontForCellInfo];
    self.titleLabel.textColor = [MSColorFactory grayDark];
    self.backgroundColor = [MSColorFactory whiteLight];
}

@end
