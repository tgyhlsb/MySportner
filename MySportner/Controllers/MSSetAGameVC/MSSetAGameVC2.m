//
//  MSSetAGameVC2.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 17/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSSetAGameVC2.h"
#import "MSLocationPickerVC.h"
#import "MSSmallSportCell.h"
#import "MSSport.h"

#define NIB_NAME @"MSSetAGameVC2"

#define DATEPICKERS_HEIGHT 200

@interface MSSetAGameVC2 () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *collectionViewTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet UIView *whereView;
@property (weak, nonatomic) IBOutlet UIView *startView;
@property (weak, nonatomic) IBOutlet UIView *endView;
@property (weak, nonatomic) IBOutlet UIView *playersView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *startSubviewContainer;
@property (weak, nonatomic) IBOutlet UIView *endSubviewContainer;
@property (weak, nonatomic) IBOutlet UILabel *cityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityValueLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;

@property (strong, nonatomic) MSSport *selectedSport;
@property (strong, nonatomic) NSArray *sports;

@property (nonatomic) BOOL hiddenStartDatePicker;
@property (nonatomic) BOOL hiddenEndDatePicker;

@end

@implementation MSSetAGameVC2


+ (MSSetAGameVC2 *)newController
{
    MSSetAGameVC2 *setAGameVC = [[MSSetAGameVC2 alloc] initWithNibName:NIB_NAME bundle:nil];
    setAGameVC.hasDirectAccessToDrawer = YES;
    [MSSport fetchAllSports];
    return setAGameVC;
}

- (BOOL)shouldCancelTouch:(UITouch *)touch
{
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self setUpGestureRecognizers];
    [self setUpCollectionView];
    [self setUpAppearance];
    
    self.hiddenEndDatePicker = YES;
    self.hiddenStartDatePicker = YES;
}

- (void)setUpAppearance
{
    self.collectionViewTitleLabel.text = [@"Pick a sport" uppercaseString];
    
    self.startDatePicker.alpha = 0;
}

#pragma mark - Set up

- (void)setUpGestureRecognizers
{
    UITapGestureRecognizer *cityTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cityTapHandler)];
    [self.cityView addGestureRecognizer:cityTapRecognizer];
    
    UITapGestureRecognizer *startTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTapHandler)];
    [self.startView addGestureRecognizer:startTapRecognizer];
    
    UITapGestureRecognizer *endTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTapHandler)];
    [self.endView addGestureRecognizer:endTapRecognizer];
}

#pragma mark - Handlers

- (void)cityTapHandler
{
    MSLocationPickerVC *destination = [MSLocationPickerVC newControler];
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)startTapHandler
{
    if (self.hiddenStartDatePicker) {
        [self openStartDatePicker];
        [self closeEndDatePicker];
    } else {
        [self closeStartDatePicker];
    }
}

- (void)endTapHandler
{
    if (self.hiddenEndDatePicker) {
        [self openEndDatePicker];
        [self closeStartDatePicker];
    } else {
        [self closeEndDatePicker];
    }
}

#pragma mark - View animation

- (void)openStartDatePicker
{
    if (self.hiddenStartDatePicker) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect subviewsFrame = self.startSubviewContainer.frame;
            subviewsFrame.origin.y += DATEPICKERS_HEIGHT;
            self.startSubviewContainer.frame = subviewsFrame;
            
            if (self.hiddenEndDatePicker) {
                [self setScrollViewContentSizeForPickerOpen:YES];
            }
            
            self.startDatePicker.alpha = 1.0;
        }];
        
        self.hiddenStartDatePicker = NO;
    }
}

- (void)closeStartDatePicker
{
    if (!self.hiddenStartDatePicker) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect subviewsFrame = self.startSubviewContainer.frame;
            subviewsFrame.origin.y -= DATEPICKERS_HEIGHT;
            self.startSubviewContainer.frame = subviewsFrame;
            
            if (self.hiddenEndDatePicker) {
                [self setScrollViewContentSizeForPickerOpen:NO];
            }
            
            self.startDatePicker.alpha = 0.0;
        }];
        
        self.hiddenStartDatePicker = YES;
    }
}

- (void)openEndDatePicker
{
    if (self.hiddenEndDatePicker) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect subviewsFrame = self.endSubviewContainer.frame;
            subviewsFrame.origin.y += DATEPICKERS_HEIGHT;
            self.endSubviewContainer.frame = subviewsFrame;
            
            if (self.hiddenStartDatePicker) {
                [self setScrollViewContentSizeForPickerOpen:YES];
            }
        }];
        
        self.hiddenEndDatePicker = NO;
    }
}

- (void)closeEndDatePicker
{
    if (!self.hiddenEndDatePicker) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect subviewsFrame = self.endSubviewContainer.frame;
            subviewsFrame.origin.y -= DATEPICKERS_HEIGHT;
            self.endSubviewContainer.frame = subviewsFrame;
            
            if (self.hiddenStartDatePicker) {
                [self setScrollViewContentSizeForPickerOpen:NO];
            }
        }];
        
        self.hiddenEndDatePicker = YES;
    }
}

- (void)setScrollViewContentSizeForPickerOpen:(BOOL)open
{
    CGFloat diff = open ? 200 : -200;
    [((UIScrollView *)self.view) setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+diff)];
}

#pragma mark - Sport picker -

- (void)setUpCollectionView
{
    [MSSmallSportCell registerToCollectionView:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = NO;
    
    self.collectionView.alwaysBounceHorizontal = YES;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (NSArray *)sports
{
    if (!_sports) {
        _sports = [MSSport allSports];
    }
    return _sports;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return [self.sports count];
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [MSSmallSportCell reusableIdentifier];
    MSSmallSportCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.sport = [self.sports objectAtIndex:indexPath.row];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedSport = [self.sports objectAtIndex:indexPath.item];
}


@end
