//
//  MSChooseSportsVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSChooseSportsVC.h"
#import "MSBigSportCell.h"
#import "MSFindFriendsVC.h"
#import "MZFormSheetController.h"
#import "MSSportLevelFormVC.h"

#define SAMPLE_SPORTS @[@"Basket", @"Swimming", @"Running", @"Tennis", @"Soccer", @"FootBall", @"Nap"]

#define DEFAULT_SPORT_LEVEL 2

#define NIB_NAME @"MSChooseSportsVC"

@interface MSChooseSportsVC () <UICollectionViewDataSource, UICollectionViewDelegate, MZFormSheetBackgroundWindowDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) NSArray *data;

@end

@implementation MSChooseSportsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [MSBigSportCell registerToCollectionView:self.collectionView];
    
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = YES;
    
    self.data = SAMPLE_SPORTS;
    
    self.title = @"CHOOSE YOUR SPORTS";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iOS_blur.png"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

+ (MSChooseSportsVC *)newController
{
    return [[MSChooseSportsVC alloc] initWithNibName:NIB_NAME bundle:Nil];
}

- (IBAction)nextButtonPress:(UIButton *)sender
{
    MSFindFriendsVC *destinationVC = [MSFindFriendsVC newController];
    
    destinationVC.user = self.user;
    
    [self.navigationController pushViewController:destinationVC animated:YES];
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
    MSBigSportCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MSBigSportCell reusableIdentifier] forIndexPath:indexPath];
    
    cell.level = DEFAULT_SPORT_LEVEL;
    cell.titleLabel.text = [self.data objectAtIndex:indexPath.item];
    
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showSportLevelPickerControllerForIndexPath:indexPath];
}

#pragma mark MZFormSheetBackgroundWindowDelegate

- (void)showSportLevelPickerControllerForIndexPath:(NSIndexPath *)indexPath
{
    MSSportLevelFormVC *vc = [MSSportLevelFormVC new];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.5;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVerticallyWhenKeyboardAppears = YES;
    formSheet.shouldCenterVertically = YES;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    __weak MSBigSportCell *weakSportCell = (MSBigSportCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    __weak MSSportLevelFormVC *weakFormSheet = vc;
    vc.closeBlock = ^{
        weakSportCell.level = weakFormSheet.level;
        [weakFormSheet dismissFormSheetControllerAnimated:YES completionHandler:nil];
    };
    
    vc.level = weakSportCell.level;
    
    [self presentFormSheetController:formSheet animated:YES completionHandler:nil];
}


@end
