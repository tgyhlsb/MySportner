//
//  MSBigSportCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSBigSportCell.h"
#import "UIView+MSRoundedView.h"
#import "MSColorFactory.h"
#import "MSFontFactory.h"

#define IDENTIFIER @"MSBigSportCell"
#define HEIGHT 130
#define WIDTH 130

#define BACKGROUND_COLOR_NORMAL [MSColorFactory grayExtraLight]
#define BACKGROUND_COLOR_SELECTED [MSColorFactory redSoft]
#define TEXT_COLOR_NORMAL [MSColorFactory grayLight]
#define TEXT_COLOR_SELECTED [MSColorFactory whiteLight]

@interface MSBigSportCell()

@property (weak, nonatomic) IBOutlet UILabel *sportLevelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation MSBigSportCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setAppearance];
}

+ (void)registerToCollectionView:(UICollectionView *)collectionView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:[MSBigSportCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

- (void)setAppearance
{
    [self setCornerRadius:3.0];
    
    self.clipsToBounds = NO;
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowRadius:0.5f];
    [self.layer setShadowOffset:CGSizeMake(0.1, 1)];
    [self.layer setShadowOpacity:0.07f];
    
    self.titleLabel.font = [MSFontFactory fontForCellSportTitle];
    
    self.backgroundColor = BACKGROUND_COLOR_NORMAL;
    
    self.titleLabel.textColor = TEXT_COLOR_NORMAL;
}

- (void)setImageNameNormal:(NSString *)imageNameNormal
{
    _imageNameNormal = imageNameNormal;
    
    if (!self.selected) {
        self.iconImageView.image = [UIImage imageNamed:_imageNameNormal];
    }
}

- (void)setImageNameSelected:(NSString *)imageNameSelected
{
    _imageNameSelected = imageNameSelected;
    
    if (self.selected) {
        self.iconImageView.image = [UIImage imageNamed:_imageNameSelected];
    }
}

+ (CGSize)size
{
    return CGSizeMake(WIDTH, HEIGHT);
}

- (void)setLevel:(int)level
{
    _level = level;
    
    self.sportLevelLabel.text = [NSString stringWithFormat:@"%d", level];
    
    if (level >= 0)
    {
        self.backgroundColor = BACKGROUND_COLOR_SELECTED;
        self.titleLabel.textColor = TEXT_COLOR_SELECTED;
        self.iconImageView.image = [UIImage imageNamed:self.imageNameSelected];
    }
    else
    {
        self.backgroundColor = BACKGROUND_COLOR_NORMAL;
        self.titleLabel.textColor = TEXT_COLOR_NORMAL;
        self.iconImageView.image = [UIImage imageNamed:self.imageNameNormal];
    }
}

- (void)setSelected:(BOOL)selected
{
    //[super setSelected:selected];
    // do nothing
}



@end
