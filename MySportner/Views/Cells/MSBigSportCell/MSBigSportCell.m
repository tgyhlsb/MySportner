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
@property (weak, nonatomic) IBOutlet UIView *tempRatingView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

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
    
    UIImage *tropheeIMG = [UIImage imageNamed:@"Trophee3.png"];
    [self.tempRatingView.layer setOpaque:NO];
    [self.tempRatingView setOpaque:NO];
    self.tempRatingView.backgroundColor = [UIColor colorWithPatternImage:tropheeIMG];
}

- (void)setSportName:(NSString *)sportName
{
    _sportName = sportName;
    self.titleLabel.text = [sportName uppercaseString];
}

- (void)setTropheeFromLevel:(NSInteger)level
{    
    level = level + 1;
    int width = level * 10.0;
    int height = 10;
    int x = 120 - width;
    int y = 5;
    
    self.tempRatingView.hidden = !level;
    self.tempRatingView.frame = CGRectMake(x, y, width, height);
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    [self setTropheeFromLevel:level];
    
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
