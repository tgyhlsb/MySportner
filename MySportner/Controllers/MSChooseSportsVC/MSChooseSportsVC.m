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
#import "QBFlatButton.h"
#import "MSColorFactory.h"
#import "MSFontFactory.h"
#import "MSStyleFactory.h"

#define SAMPLE_SPORTS @[@"foot", @"basketball", @"football", @"tennis", @"swimming", @"cycle", @"gym", @"rugby"]

#define DEFAULT_SPORT_LEVEL -1

#define NIB_NAME @"MSChooseSportsVC"

@interface MSChooseSportsVC () <UICollectionViewDataSource, UICollectionViewDelegate, MZFormSheetBackgroundWindowDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet QBFlatButton *nextButton;

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
    
    [self setAppearance];
    [self setBackButton];
}

- (void)setBackButton
{
    // removes title from pushed VC
    UIBarButtonItem *emptyBackButton = [[UIBarButtonItem alloc] initWithTitle: @"" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: emptyBackButton];
}

- (void)setAppearance
{
    self.title = @"CHOOSE YOUR SPORTS";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_blur_light.png"]];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [MSStyleFactory setQBFlatButton:self.nextButton withStyle:MSFlatButtonStyleGreen];
}

- (MSUser *)user
{
    if (!_user) {
        _user = [MSUser currentUser];
    }
    return _user;
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
    NSString *sport = [self.data objectAtIndex:indexPath.item];
    cell.titleLabel.text = [sport uppercaseString];
    cell.imageNameNormal = [sport stringByAppendingString:@".png"];
    cell.imageNameSelected = [sport stringByAppendingString:@"(select).png"];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showSportLevelPickerControllerForIndexPath:indexPath withUnSelectButton:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showSportLevelPickerControllerForIndexPath:indexPath withUnSelectButton:YES];
}

#pragma mark MZFormSheetBackgroundWindowDelegate

- (void)showSportLevelPickerControllerForIndexPath:(NSIndexPath *)indexPath withUnSelectButton:(BOOL)showUnSelectButton
{
    MSSportLevelFormVC *vc = [MSSportLevelFormVC new];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:CGSizeMake(280, 350) viewController:vc];
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.5;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVerticallyWhenKeyboardAppears = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.cornerRadius = 3.0f;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    __weak MSBigSportCell *weakSportCell = (MSBigSportCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    __weak MSSportLevelFormVC *weakFormSheet = vc;
    
    vc.doneBlock = ^{
        weakSportCell.level = weakFormSheet.level;
        [weakFormSheet dismissFormSheetControllerAnimated:YES completionHandler:nil];
    };
    
    vc.unSelectBlock = ^{
        weakSportCell.level = -1;
        [weakFormSheet dismissFormSheetControllerAnimated:YES completionHandler:nil];
    };
    
    vc.level = weakSportCell.level;
    
    [self presentFormSheetController:formSheet animated:YES completionHandler:nil];
}


@end
