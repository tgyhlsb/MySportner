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


@interface MSSmallSportCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

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

- (void)updateImage
{
    NSString *format = self.selected ? @"%@2.png" : @"%@.png";
    NSString *name = [NSString stringWithFormat:format, self.sport.slug];
    UIImage *img = [UIImage imageNamed:name];
    self.imageView.image = img;
}

- (void)setSport:(MSSport *)sport
{
    _sport = sport;
    
    self.titleLabel.text = sport.name;
    [self updateImage];
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
    [self updateImage];
}

- (void)awakeFromNib
{
    [self setCornerRadius:3.0f];
    self.titleLabel.font = [MSFontFactory fontForCellInfo];
    self.titleLabel.textColor = [MSColorFactory grayDark];
    self.backgroundColor = [MSColorFactory whiteLight];
}

@end
