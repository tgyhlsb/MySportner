//
//  MSProfilePictureCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 04/02/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSProfilePictureCell.h"
#import "MSProfilePictureView.h"
#import "UIView+MSRoundedView.h"
#import "MSColorFactory.h"

#define NIB_NAME @"MSProfilePictureCell"

@interface MSProfilePictureCell()
@property (weak, nonatomic) IBOutlet MSProfilePictureView *pictureView;

@end

@implementation MSProfilePictureCell

+ (NSString *)reusableIdentifier
{
    return NIB_NAME;
}

+ (void)registerToCollectionView:(UICollectionView *)collectionView
{
    UINib *nib = [UINib nibWithNibName:NIB_NAME bundle:Nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:[MSProfilePictureCell reusableIdentifier]];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.pictureView setRounded];
    [self setRounded];
    self.layer.borderWidth = 1.0f;
}

- (void)setSportner:(MSSportner *)sportner
{
    _sportner = sportner;
    
    [self updateUI];
}

- (void)setSportnerType:(MSProfilePictureCellType)sportnerType
{
    _sportnerType = sportnerType;
    
    [self updateUI];
}

- (void)updateUI
{
    self.pictureView.sportner = self.sportner;
    
    switch (self.sportnerType) {
        case MSProfilePictureCellParticipant:
        {
            self.layer.borderColor = [MSColorFactory mainColor].CGColor;
            break;
        }
        case MSProfilePictureCellGuest:
        {
            self.layer.borderColor = [MSColorFactory redSoft].CGColor;
            break;
        }
    }
    
    [self.pictureView setRounded];
    [self setRounded];
}

@end
