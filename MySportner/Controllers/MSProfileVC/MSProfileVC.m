//
//  MSProfileVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 22/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSProfileVC.h"
#import "UIView+MSRoundedView.h"
#import "UIImage+BlurredFrame.h"
#import "MSColorFactory.h"
#import "MSActivityCell.h"
#import "MSActivityVC.h"
#import "MSChooseSportsVC.h"
#import "MSProfilePictureView.h"
#import "TKAlertCenter.h"
#import "QBFlatButton.h"
#import "MSFontFactory.h"
#import "MSStyleFactory.h"
#import "MSCropperVC.h"
#import "MSCreateAccountVC.h"
#import "MSSportnerCell.h"


#define NIB_NAME @"MSProfileVC"

#define COVER_BLUR_HEIGHT 110

typedef NS_ENUM(int, MSProfileTableViewMode) {
    MSProfileTableViewModeActivities,
    MSProfileTableViewModeSportners
};

@interface MSProfileVC () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MSCropperVCDelegate, MSSportnerCellDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *coverPictureView;
@property (weak, nonatomic) IBOutlet MSProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *sportnerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet QBFlatButton *activitiesButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *sportnersButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *actionbutton;
@property (weak, nonatomic) IBOutlet UIImageView *sportImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *sportImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *sportImageView3;

@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (strong, nonatomic) UIImagePickerController *imageTakerVC;

@property (nonatomic) MSProfileTableViewMode tableViewMode;

@end

@implementation MSProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [MSActivityCell registerToTableview:self.tableView];
    [MSSportnerCell registerToTableview:self.tableView];
    
    [self setAppearance];
    [self reloadCoverPictureView];
    
    self.tableViewMode = MSProfileTableViewModeActivities;
    
    [self setUpImagePicker];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self queryActivities];
    [self querySportners];
    
    [self setNormalNavigationBar];
    self.navigationItem.title = [[self.sportner fullName] uppercaseString];
    //[self setTranslucentNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self setNormalNavigationBar];
}

- (void)setUpImagePicker
{
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.imagePickerVC = [[UIImagePickerController alloc] init];
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerVC.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            // Has camera
            self.imageTakerVC = [[UIImagePickerController alloc] init];
            self.imageTakerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imageTakerVC.delegate = self;
        }
    });
}

- (void)reloadData
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (void)queryActivities
{
    [self.sportner queryActivitiesWithTarget:self callBack:@selector(didFetchUserActivities:error:)];
}

- (void)querySportners
{
    [self.sportner querySportnersWithTarget:self callBack:@selector(didFetchUserSportners:error:)];
}

- (void)setTableViewMode:(MSProfileTableViewMode)tableViewMode
{
    switch (tableViewMode) {
        case MSProfileTableViewModeActivities:
        {
            self.activitiesButton.sideColor = [MSColorFactory mainColor];
            [self.activitiesButton setTitleColor:[MSColorFactory mainColor] forState:UIControlStateNormal];
            self.sportnersButton.sideColor = [UIColor whiteColor];
            [self.sportnersButton setTitleColor:[MSColorFactory grayDark] forState:UIControlStateNormal];
            break;
        }
        case MSProfileTableViewModeSportners:
        {
            self.activitiesButton.sideColor = [UIColor whiteColor];
            [self.activitiesButton setTitleColor:[MSColorFactory grayDark] forState:UIControlStateNormal];
            self.sportnersButton.sideColor = [MSColorFactory mainColor];
            [self.sportnersButton setTitleColor:[MSColorFactory mainColor] forState:UIControlStateNormal];
            break;
        }
    }
    [self.activitiesButton setNeedsDisplay];
    [self.sportnersButton setNeedsDisplay];
    
    if (_tableViewMode != tableViewMode) {
        _tableViewMode = tableViewMode;
        [self reloadData];
    } else {
        _tableViewMode = tableViewMode;
    }
}

- (void)setAppearance
{
    [self.profilePictureView setRounded];
    self.profilePictureView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self setUpActionButton];
    
    self.profilePictureView.layer.borderWidth = 1.0f;
    self.profilePictureView.layer.borderColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.8] CGColor];
    self.profilePictureView.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    self.profilePictureView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:1.0] CGColor];
    
    self.locationLabel.textColor = [MSColorFactory whiteLight];
    
    int x = 0;
    int y = self.coverPictureView.frame.size.height - COVER_BLUR_HEIGHT;
    int height = 1;
    int width = 320;
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    borderView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.60];
    [self.topView insertSubview:borderView belowSubview:self.profilePictureView];
    
    
    [MSStyleFactory setQBFlatButton:self.activitiesButton withStyle:MSFlatButtonStyleAndroidWhite];
    [self.activitiesButton setTitle:@"ACTIVITES" forState:UIControlStateNormal];
    [MSStyleFactory setQBFlatButton:self.sportnersButton withStyle:MSFlatButtonStyleAndroidWhite];
    [self.sportnersButton setTitle:@"SPORTNERS" forState:UIControlStateNormal];
    
    
    [MSStyleFactory setUILabel:self.sportnerNameLabel withStyle:MSLabelStyleUserName];
    self.sportnerNameLabel.font = [MSFontFactory fontForSportnerNameProfile];
    self.locationLabel.font = [MSFontFactory fontForSportnerLocationProfile];
    self.sportnerNameLabel.textColor = [MSColorFactory whiteLight];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSportChooser)];
    [self.sportnerNameLabel addGestureRecognizer:tapGesture];
    self.sportnerNameLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *profilePictureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureTapHandler)];
    [self.profilePictureView addGestureRecognizer:profilePictureTap];
    self.profilePictureView.userInteractionEnabled = YES;
}

- (void)setUpActionButton
{
    self.actionbutton.titleLabel.font = [MSFontFactory fontForCellInfo];
    
    if ([[MSSportner currentSportner] isEqualToSportner:self.sportner]) {
        self.actionbutton.hidden = YES;
    } else if ([[MSSportner currentSportner].sportners containsObject:self.sportner]) {
        [self.actionbutton setTitle:@"REMOVE" forState:UIControlStateNormal];
        self.actionbutton.hidden = NO;
    } else {
        [self.actionbutton setTitle:@"ADD" forState:UIControlStateNormal];
        self.actionbutton.hidden = NO;
    }
}

- (void)pictureTapHandler
{
	UIActionSheet *pictureSheet = [[UIActionSheet alloc] initWithTitle:@"Profile picture"
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:Nil
                                                     otherButtonTitles:@"Take a picture", @"Use an existing picture", @"Resize picture", nil];
	pictureSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    pictureSheet.delegate = self;
	[pictureSheet showInView:self.view];
}

#pragma mark - UIActionsheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // Camera
        {
            if (self.imageTakerVC) {
                [self presentViewController:self.imageTakerVC animated:YES completion:nil];
            } else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Your camera is not available"];
            }
            break;
        }
            
        case 1: // Library
        {
            [self presentViewController:self.imagePickerVC animated:YES completion:nil];
            break;
        }
            
        case 2: // Resize
        {
            [self openImageCropperWithSportnerImage];
            break;
        }
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)openImageCropperWithSportnerImage
{
    MSCropperVC *cropperVC = [MSCropperVC newControllerWithImage:self.sportner.image];
    cropperVC.delegate = self;
    UINavigationController *destination = [[UINavigationController alloc] initWithRootViewController:cropperVC];
    [self presentViewController:destination animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    MSCropperVC *destination = [MSCropperVC newControllerWithImage:image];
    destination.delegate = self;
    [picker pushViewController:destination animated:YES];
}

#pragma mark - MSCropperVCDelegate

- (void)cropper:(MSCropperVC *)cropper didCropImage:(UIImage *)image
{
    self.sportner.image = [self imageWithImage:image scaledToSize:CGSizeMake(IMAGE_SIZE_FOR_UPLOAD, IMAGE_SIZE_FOR_UPLOAD)];
    [self.sportner saveInBackground];
    [self reloadCoverPictureView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)showSportChooser
{
    if ([self.sportner isEqual:[MSSportner currentSportner]]) {
        MSChooseSportsVC *destinationVC = [MSChooseSportsVC newController];
        
        destinationVC.sportner = self.sportner;
        
        destinationVC.validateBlock = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        
        [self.navigationController pushViewController:destinationVC animated:YES];
        [destinationVC setValidateButtonTitle:@"DONE"];
    }
}

@synthesize sportner = _sportner;

- (MSSportner *)sportner
{
    if (!_sportner) _sportner = [MSSportner currentSportner];
    return _sportner;
}

- (void)setSportner:(MSSportner *)user
{
    _sportner = user;
    
    [self reloadCoverPictureView];
}

- (void)reloadCoverPictureView
{
    if (self.sportner) {
        [self setCoverPictureWithImage:[UIImage imageNamed:@"Img-Profile.png"]];
        self.profilePictureView.sportner = self.sportner;
        self.sportnerNameLabel.text = [self.sportner fullName];
        self.locationLabel.text = [@"Lyon, France" uppercaseString];
    }
}

- (void)setCoverPictureWithImage:(UIImage *)image
{
    image = [image imageScaledToSize:self.coverPictureView.bounds.size];
    CGRect frame = CGRectMake(0, image.size.height - COVER_BLUR_HEIGHT, image.size.width, COVER_BLUR_HEIGHT);
    
    self.coverPictureView.image = [image applyLightEffectAtFrame:frame];
}

#pragma mark - Handlers

- (IBAction)activitiesButtonHandler:(QBFlatButton *)sender
{
    self.tableViewMode = MSProfileTableViewModeActivities;
}

- (IBAction)sportnersButtonHandler:(QBFlatButton *)sender
{
    self.tableViewMode = MSProfileTableViewModeSportners;
}

- (IBAction)actionButtonHandler:(id)sender
{
    if ([[MSSportner currentSportner].sportners containsObject:self.sportner]) {
        [[MSSportner currentSportner] removeSportner:self.sportner];
    } else {
        [[MSSportner currentSportner] addSportner:self.sportner];
    }
    [self setUpActionButton];
}

#pragma mark - PARSE Backend

- (void)didFetchUserActivities:(NSArray *)activities error:(NSError *)error
{
    if (!error) {
        [self reloadData];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Could not load activities"];
    }
}

- (void)didFetchUserSportners:(NSArray *)sportners error:(NSError *)error
{
    if (!error) {
        [self reloadData];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Could not load sportners"];
    }
}


#pragma mark Class methods

+ (MSProfileVC *)newController
{
    MSProfileVC *profileVC = [[MSProfileVC alloc] initWithNibName:NIB_NAME bundle:nil];
    profileVC.hasDirectAccessToDrawer = YES;
    return profileVC;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.tableViewMode) {
        case MSProfileTableViewModeActivities:
            return [self.sportner.activities count];
        case MSProfileTableViewModeSportners:
            return [self.sportner.sportners count];
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.tableViewMode) {
        case MSProfileTableViewModeActivities:
        {
            NSString *identifier = [MSActivityCell reusableIdentifier];
            MSActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.activity = [self.sportner.activities objectAtIndex:indexPath.row];
            [cell setAppearanceWithOddIndex:(indexPath.row % 2)];
            return cell;
        }
        case MSProfileTableViewModeSportners:
        {
            NSString *identifier = [MSSportnerCell reusableIdentifier];
            MSSportnerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            
            cell.sportner = [self.sportner.sportners objectAtIndex:indexPath.row];
            [cell setAppearanceWithOddIndex:(indexPath.row % 2)];
            
            cell.delegate = self;
            
            if ([self.sportner isEqual:[MSSportner currentSportner]]) {
                [cell setActionButtonTitle:@"REMOVE"];
            } else {
                [cell setActionButtonTitle:nil];
            }
            
            return cell;
        }
            
        default:
            return nil;
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MSActivityCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.tableViewMode) {
        case MSProfileTableViewModeActivities:
        {
            MSActivityVC *destinationVC = [MSActivityVC newController];
            MSActivityCell *cell = (MSActivityCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            destinationVC.activity = cell.activity;
            [self.navigationController pushViewController:destinationVC animated:YES];
            break;
        }
        case MSProfileTableViewModeSportners:
        {
            MSProfileVC *destinationVC = [MSProfileVC newController];
            destinationVC.hasDirectAccessToDrawer = NO;
            MSSportnerCell *cell = (MSSportnerCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            destinationVC.sportner = cell.sportner;
            [self.navigationController pushViewController:destinationVC animated:YES];
            break;
        }
    }
}

#pragma mark - MSSportnerCellDelegate

- (void)sportnerCell:(MSSportnerCell *)cell didTrigerActionWithSportner:(MSSportner *)sportner
{
    [self.sportner removeSportner:cell.sportner];
    [self reloadData];
}

@end
