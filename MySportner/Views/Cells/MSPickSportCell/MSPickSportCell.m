//
//  MSPickSportCell.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSPickSportCell.h"
#import "MSSmallSportCell.h"
#import "MSFontFactory.h"
#import "MSColorFactory.h"
#import "MSSportner.h"

#define IDENTIFIER @"MSPickSportCell2"
#define HEIGHT 120

@interface MSPickSportCell() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) NSArray *data;

@end

@implementation MSPickSportCell


- (void)awakeFromNib
{
    [MSSmallSportCell registerToCollectionView:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = NO;
    
    self.data = [[MSSportner currentSportner] getSports];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.headerLabel.font = [MSFontFactory fontForTitle];
    self.headerLabel.textColor = [MSColorFactory gray];
    self.headerLabel.text = @"PICK A SPORT";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // do nothing
}

+ (void)registerToTableView:(UITableView *)tableView
{
    UINib *nib = [UINib nibWithNibName:IDENTIFIER bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[MSPickSportCell reusableIdentifier]];
}

+ (NSString *)reusableIdentifier
{
    return IDENTIFIER;
}

+ (CGFloat)height
{
    return HEIGHT;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [MSSmallSportCell reusableIdentifier];
    MSSmallSportCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.titleLabel.text = [self.data objectAtIndex:indexPath.row];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.sport = [self.data objectAtIndex:indexPath.item];
}


@end
