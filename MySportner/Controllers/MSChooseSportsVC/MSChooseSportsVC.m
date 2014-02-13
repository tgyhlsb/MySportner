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
#import "MSSport.h"
#import "MBProgressHUD.h"
#import "TKAlertCenter.h"
#import "MSSport.h"

#define DEFAULT_SPORT_LEVEL -1

#define NIB_NAME @"MSChooseSportsVC"

@interface MSChooseSportsVC () <UICollectionViewDataSource, UICollectionViewDelegate, MZFormSheetBackgroundWindowDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet QBFlatButton *nextButton;

@property (strong, nonatomic) MBProgressHUD *loadingView;

@property (strong, nonatomic) NSArray *data;

@property (strong, nonatomic) NSString *validateButtonTitle;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.nextButton setTitle:self.validateButtonTitle forState:UIControlStateNormal];
    
    [[MSSportner currentSportner] fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self.collectionView reloadData];
    }];
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

- (MSSportner *)sportner
{
    if (!_sportner) {
        _sportner = [MSSportner currentSportner];
    }
    return _sportner;
}

+ (MSChooseSportsVC *)newController
{
    return [[MSChooseSportsVC alloc] initWithNibName:NIB_NAME bundle:Nil];
}

@synthesize validateButtonTitle = _validateButtonTitle;

- (void)setValidateButtonTitle:(NSString *)title
{
    _validateButtonTitle = title;
    [self.nextButton setTitle:title forState:UIControlStateNormal];
}

- (NSString *)validateButtonTitle
{
    if (!_validateButtonTitle) _validateButtonTitle = @"NEXT";
    return _validateButtonTitle;
}

- (IBAction)nextButtonPress:(UIButton *)sender
{
    if (self.sportner) {
        [self showLoadingViewInView:self.view];
        [self.sportner saveInBackgroundWithTarget:self selector:@selector(handleSportnerSave:error:)];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Connection lost"];
    }
}


- (void)handleSportnerSave:(NSNumber *)result error:(NSError *)error
{
    [self hideLoadingView];
    if (!error) {
        self.validateBlock();
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[error.userInfo objectForKey:@"error"]];
    }
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
    
    NSString *sport = [self.data objectAtIndex:indexPath.item];
    cell.sportName = sport;
    cell.imageNameNormal = [[sport stringByAppendingString:@".png"] lowercaseString];
    cell.imageNameSelected = [[sport stringByAppendingString:@"(select).png"] lowercaseString];
    
    cell.level = [self.sportner sportLevelForSportIndex:indexPath.row defaultValue:DEFAULT_SPORT_LEVEL];
    
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
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.5;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
//    formSheet.shouldCenterVerticallyWhenKeyboardAppears = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.cornerRadius = 3.0f;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    __weak MSBigSportCell *weakSportCell = (MSBigSportCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    __weak MSSportLevelFormVC *weakFormSheet = vc;
    
    vc.doneBlock = ^{
        
        NSInteger sportKey = [MSSport keyForSportName:weakSportCell.sportName];
        [self.sportner setSport:sportKey withLevel:weakFormSheet.level];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [weakFormSheet dismissFormSheetControllerAnimated:YES completionHandler:nil];
    };
    
    vc.unSelectBlock = ^{
        NSInteger sportKey = [MSSport keyForSportName:weakSportCell.sportName];
        [self.sportner setSport:sportKey withLevel:-1];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [weakFormSheet dismissFormSheetControllerAnimated:YES completionHandler:nil];
    };
    
    vc.level = weakSportCell.level;
    
    [self presentFormSheetController:formSheet animated:YES completionHandler:nil];
}

#pragma mark - MBProgressHUD

- (void)showLoadingViewInView:(UIView*)v
{
    UIView *targetV = (v ? v : self.view);
    
    if (!self.loadingView) {
        self.loadingView = [[MBProgressHUD alloc] initWithView:targetV];
        self.loadingView.minShowTime = 1.0f;
        self.loadingView.mode = MBProgressHUDModeIndeterminate;
        self.loadingView.removeFromSuperViewOnHide = YES;
        self.loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    }
    if(!self.loadingView.superview) {
        self.loadingView.frame = targetV.bounds;
        [targetV addSubview:self.loadingView];
    }
    [self.loadingView show:YES];
}
- (void) hideLoadingView
{
    if (self.loadingView.superview)
        [self.loadingView hide:YES];
}


@end
