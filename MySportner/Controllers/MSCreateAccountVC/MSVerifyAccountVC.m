//
//  MSCreateAccountVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSVerifyAccountVC.h"
#import "MSChooseSportsVC.h"
#import "MSUser.h"
#import "MSTextField.h"
#import "MSColorFactory.h"
#import "MSFontFactory.h"
#import "QBFlatButton.h"
#import "NKColorSwitch.h"
#import "MBProgressHUD.h"
#import "TKAlertCenter.h"
#import "UIView+MSRoundedView.h"
#import "MSFindFriendsVC.h"
#import "MSCropperVC.h"
#import "MSStyleFactory.h"
#import "MSLocationPickerVC.h"
#import "MSFullScreenPopUpVC.h"

#define NIB_NAME @"MSVerifyAccountVC"

#define DATEPICKER_HEIGHT 162


@interface MSVerifyAccountVC () <UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MSCropperVCDelegate, MSLocationPickerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet QBFlatButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *firstNameView;
@property (weak, nonatomic) IBOutlet UIView *lastNameView;
@property (weak, nonatomic) IBOutlet UIView *genderView;
@property (weak, nonatomic) IBOutlet UIView *birthdateView;
@property (weak, nonatomic) IBOutlet UIView *genderSubviewContainer;
@property (weak, nonatomic) IBOutlet UIView *birthdateSubviewContainer;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet UIPickerView *genderPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdatePicker;
@property (weak, nonatomic) IBOutlet UILabel *firstNameTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *lastNameTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *genderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *cityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityValueLabel;

@property (nonatomic) BOOL hiddenGenderPicker;
@property (nonatomic) BOOL hiddenBirthdatePicker;

@property (strong, nonatomic) UIImagePickerController *imagePickerVC;

@property (weak, nonatomic) UITextField *activeTextField;

@property (strong,nonatomic) MSUser *user;
@property (strong, nonatomic) UIImage *profilePicture;

@property (strong, nonatomic) MBProgressHUD *loadingView;

@property (nonatomic) BOOL hasAlreadySignUp;

@end

@implementation MSVerifyAccountVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [@"Verify your profile" uppercaseString];
    
    [self setUpGestureRecognizers];
    [self registerForKeyboardNotifications];
    [self setUpAppearance];
    
    [self setBackButton];
    [self setUpImagePicker];
    self.hasAlreadySignUp = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    self.genderPicker.delegate = self;
    self.genderPicker.dataSource = self;
    
    self.hiddenBirthdatePicker = YES;
    self.hiddenGenderPicker = YES;
}

- (void)setUpImagePicker
{
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.imagePickerVC = [[UIImagePickerController alloc] init];
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerVC.delegate = self;
    });
}

- (void)setBackButton
{
    
    // removes title from pushed VC
    UIBarButtonItem *emptyBackButton = [[UIBarButtonItem alloc] initWithTitle: @"" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: emptyBackButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)nextButtonHandler
{
//    NSString *message = nil;
//    NSString *title = @"Profile incomplete";
//
//    if (![self.firstnameTextField.text length])
//    {
//        message = @"Please fill in your first name";
//    }
//    else if (![self.lastnameTextField.text length])
//    {
//        message = @"Please fill in your last name";
//    }
//    else if (![self.emailTextField.text length])
//    {
//        message = @"Please fill in your email";
//    }
//    else if (![self NSStringIsValidEmail:self.emailTextField.text])
//    {
//        title = @"Error";
//        message = @"Your email address is invalid";
//    }
//    else if (![self.passwordTextField.text length])
//    {
//        message = @"Please fill in your password";
//    }
//    else if (![self.birthdayTextField.text length])
//    {
//        message = @"Please fill in your birthday";
//    } else if (!self.profilePicture) {
////        message = @"Please pick a picture";
//    }
//    
//    
//    if (message && title)
//    {
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
//        [self SetFocusOnFailedField];
//    } else {
//        [self showLoadingViewInView:self.view];
//        
//        if (self.hasAlreadySignUp) {
//            self.user = [MSUser currentUser];
//        } else {
//            self.user = [[MSUser alloc] init];
//        }
//        
//        if (!self.user.sportner) {
//            self.user.sportner = [[MSSportner alloc] init];
//        }
//        
//        self.user.sportner.firstName = self.firstnameTextField.text;
//        self.user.sportner.lastName = self.lastnameTextField.text;
//        self.user.email = self.emailTextField.text;
//        self.user.password = self.passwordTextField.text;
//        self.user.sportner.birthday = self.datePicker.date;
//        self.user.sportner.lastPlace = @"Unknown";
//        self.user.sportner.gender = self.genderControl.isOn ? MSUserGenderFemale : MSUserGenderMale;
//        self.user.username = self.user.email;
//        self.user.sportner.username = self.user.email;
//        self.user.sportner.facebookID = FACEBOOK_DEFAULT_ID[self.user.sportner.gender]; // default IDs to get a fb picture according to your gender
//        self.user.sportner.image = self.imageView.image;
//        if (self.hasAlreadySignUp) {
//            [self.user saveInBackgroundWithTarget:self selector:@selector(handleSignUp:error:)];
//        } else {
//            [self.user signUpInBackgroundWithTarget:self selector:@selector(handleSignUp:error:)];
//        }
//    }
    
    [self showTermPopUp];
}

- (void)showDonePopUp
{
    MSFullScreenPopUpVC *vc = [MSFullScreenPopUpVC newController];
    CGSize formSheetSize = self.navigationController.view.frame.size;
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:formSheetSize viewController:vc];
    //    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    formSheet.shadowRadius = 0.0;
    formSheet.shadowOpacity = 0.94;
    formSheet.cornerRadius = 3.0;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVerticallyWhenKeyboardAppears = YES;
    formSheet.shouldCenterVertically = YES;
    
    vc.textTitle = @"Congratulations";
    vc.text = @"You can now train like an Athlete, Win like a Champion and Sleep like a Baby !";
    vc.otherButonTitle = @"or skip this step";
    vc.mainButtonTitle = @"SHARE";
    vc.imageName = @"m.png";
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
    };
    
    //    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

- (void)showTermPopUp
{
    MSFullScreenPopUpVC *vc = [MSFullScreenPopUpVC newController];
    CGSize formSheetSize = self.navigationController.view.frame.size;
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:formSheetSize viewController:vc];
    //    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    formSheet.shadowRadius = 0.0;
    formSheet.shadowOpacity = 0.94;
    formSheet.cornerRadius = 3.0;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVerticallyWhenKeyboardAppears = YES;
    formSheet.shouldCenterVertically = YES;
    
    vc.textTitle = nil;
    vc.text = @"By clicking next, you hereby agree to the terms and confitions of use.";
    vc.otherButonTitle = nil;
    vc.mainButtonTitle = @"NEXT";
    vc.imageName = @"check.png";
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
    };
    
    //    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

#pragma mark - Set Up

- (void)setUpGestureRecognizers
{
    UITapGestureRecognizer *pictureTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureTapHandler)];
    [self.imageView addGestureRecognizer:pictureTapRecognizer];
    self.imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *genderTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(genderTapHandler)];
    [self.genderView addGestureRecognizer:genderTapRecognizer];
    
    UITapGestureRecognizer *birthdateTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(birthdateTapHandler)];
    [self.birthdateView addGestureRecognizer:birthdateTapRecognizer];
    
    UITapGestureRecognizer *cityTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cityTapHandler)];
    [self.cityView addGestureRecognizer:cityTapRecognizer];
}

- (void)setUpAppearance
{
    self.genderPicker.alpha = 0.0;
    self.birthdatePicker.alpha = 0.0;
    
    self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:241.0/255.0 blue:243.0/255.0 alpha:1.0];
    
    self.genderSubviewContainer.backgroundColor = [UIColor clearColor];
    self.birthdateSubviewContainer.backgroundColor = [UIColor clearColor];
    
    [self.birthdatePicker addTarget:self action:@selector(birthdatePickerValueDidChange) forControlEvents:UIControlEventValueChanged];
    self.birthdatePicker.date = [NSDate dateWithTimeIntervalSince1970:0];
    self.birthdatePicker.maximumDate = [NSDate date];
    self.birthdatePicker.datePickerMode = UIDatePickerModeDate;
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.emailTextField.delegate = self;
    
    self.firstNameTitleLabel.text = @"First name";
    self.lastNameTitleLabel.text = @"Last name";
    self.genderTitleLabel.text = @"Gender";
    self.birthdateTitleLabel.text = @"Birthdate";
    self.emailTitleLabel.text = @"Mail";
    self.cityTitleLabel.text = @"Current city";
    
#define BACKGROUND_COLOR [UIColor whiteColor]
#define CORNER_RADIUS 3.0
#define SHADOW_OFFSET CGSizeMake(0, 1)
#define SHADOW_RADIUS 0.64
#define SHADOW_OPACITY 0.08
#define SHADOW_COLOR [[UIColor blackColor] CGColor]
    
    self.firstNameView.backgroundColor = BACKGROUND_COLOR;
    self.firstNameView.layer.cornerRadius = CORNER_RADIUS;
    self.firstNameView.layer.shadowOffset = SHADOW_OFFSET;
    self.firstNameView.layer.shadowRadius = SHADOW_RADIUS;
    self.firstNameView.layer.shadowOpacity = SHADOW_OPACITY;
    self.firstNameView.layer.shadowColor = SHADOW_COLOR;
    
    self.lastNameView.backgroundColor = BACKGROUND_COLOR;
    self.lastNameView.layer.cornerRadius = CORNER_RADIUS;
    self.lastNameView.layer.shadowOffset = SHADOW_OFFSET;
    self.lastNameView.layer.shadowRadius = SHADOW_RADIUS;
    self.lastNameView.layer.shadowOpacity = SHADOW_OPACITY;
    self.lastNameView.layer.shadowColor = SHADOW_COLOR;
    
    self.genderView.backgroundColor = BACKGROUND_COLOR;
    self.genderView.layer.cornerRadius = CORNER_RADIUS;
    self.genderView.layer.shadowOffset = SHADOW_OFFSET;
    self.genderView.layer.shadowRadius = SHADOW_RADIUS;
    self.genderView.layer.shadowOpacity = SHADOW_OPACITY;
    self.genderView.layer.shadowColor = SHADOW_COLOR;
    
    self.birthdateView.backgroundColor = BACKGROUND_COLOR;
    self.birthdateView.layer.cornerRadius = CORNER_RADIUS;
    self.birthdateView.layer.shadowOffset = SHADOW_OFFSET;
    self.birthdateView.layer.shadowRadius = SHADOW_RADIUS;
    self.birthdateView.layer.shadowOpacity = SHADOW_OPACITY;
    self.birthdateView.layer.shadowColor = SHADOW_COLOR;
    
    self.emailView.backgroundColor = BACKGROUND_COLOR;
    self.emailView.layer.cornerRadius = CORNER_RADIUS;
    self.emailView.layer.shadowOffset = SHADOW_OFFSET;
    self.emailView.layer.shadowRadius = SHADOW_RADIUS;
    self.emailView.layer.shadowOpacity = SHADOW_OPACITY;
    self.emailView.layer.shadowColor = SHADOW_COLOR;
    
    self.cityView.backgroundColor = BACKGROUND_COLOR;
    self.cityView.layer.cornerRadius = CORNER_RADIUS;
    self.cityView.layer.shadowOffset = SHADOW_OFFSET;
    self.cityView.layer.shadowRadius = SHADOW_RADIUS;
    self.cityView.layer.shadowOpacity = SHADOW_OPACITY;
    self.cityView.layer.shadowColor = SHADOW_COLOR;
    
#define BORDER_STYLE UITextBorderStyleNone
#define VALUE_TEXTCOLOR [MSColorFactory redLight]
#define VALUE_FONT [UIFont fontWithName:@"Helvetica-Light" size:13.0]
    
    self.firstNameTextField.borderStyle = BORDER_STYLE;
    self.firstNameTextField.textColor = VALUE_TEXTCOLOR;
    self.firstNameTextField.font = VALUE_FONT;
    
    self.lastNameTextField.borderStyle = BORDER_STYLE;
    self.lastNameTextField.textColor = VALUE_TEXTCOLOR;
    self.lastNameTextField.font = VALUE_FONT;
    
    self.genderValueLabel.textColor = VALUE_TEXTCOLOR;
    self.genderValueLabel.font = VALUE_FONT;
    
    self.birthdateValueLabel.textColor = VALUE_TEXTCOLOR;
    self.birthdateValueLabel.font = VALUE_FONT;
    
    self.emailTextField.borderStyle = BORDER_STYLE;
    self.emailTextField.textColor = VALUE_TEXTCOLOR;
    self.emailTextField.font = VALUE_FONT;
    
    self.cityValueLabel.textColor = VALUE_TEXTCOLOR;
    self.cityValueLabel.font = VALUE_FONT;
    
#define TITLE_TEXTCOLOR [MSColorFactory gray]
#define TITLE_FONT [UIFont fontWithName:@"Helvetica-Light" size:9.0]
    
    self.firstNameTitleLabel.textColor = TITLE_TEXTCOLOR;
    self.firstNameTitleLabel.font = TITLE_FONT;
    
    self.lastNameTitleLabel.textColor = TITLE_TEXTCOLOR;
    self.lastNameTitleLabel.font = TITLE_FONT;
    
    self.genderTitleLabel.textColor = TITLE_TEXTCOLOR;
    self.genderTitleLabel.font = TITLE_FONT;
    
    self.birthdateTitleLabel.textColor = TITLE_TEXTCOLOR;
    self.birthdateTitleLabel.font = TITLE_FONT;
    
    self.emailTitleLabel.textColor = TITLE_TEXTCOLOR;
    self.emailTitleLabel.font = TITLE_FONT;
    
    self.cityTitleLabel.textColor = TITLE_TEXTCOLOR;
    self.cityTitleLabel.font = TITLE_FONT;
    
    
    [MSStyleFactory setQBFlatButton:self.nextButton withStyle:MSFlatButtonStyleGreen];
    [self.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2.0;
}

#pragma mark - Handlers

- (void)pictureTapHandler
{
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (void)genderTapHandler
{
    [self.activeTextField resignFirstResponder];
    if (self.hiddenGenderPicker) {
        [self openGenderPicker];
        [self closeBirthdatePicker];
    } else {
        [self closeGenderPicker];
    }
}

- (void)birthdateTapHandler
{
    [self.activeTextField resignFirstResponder];
    if (self.hiddenBirthdatePicker) {
        [self openBirthdatePicker];
        [self closeGenderPicker];
    } else {
        [self closeBirthdatePicker];
    }
}

- (void)cityTapHandler
{
    MSLocationPickerVC *destination = [MSLocationPickerVC newControler];
    destination.delegate = self;
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)genderPickerValueDidChange
{
    
}

- (void)birthdatePickerValueDidChange
{
    
}

#pragma mark - Layout

#define PICKERS_HEIGHT 152

- (void)openGenderPicker
{
    if (self.hiddenGenderPicker) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect subviewsFrame = self.genderSubviewContainer.frame;
            subviewsFrame.origin.y += PICKERS_HEIGHT;
            self.genderSubviewContainer.frame = subviewsFrame;
            
//            if (self.hiddenEndDatePicker) {
//                [self setScrollViewContentSizeForPickerOpen:YES];
//            }
            
            self.genderPicker.alpha = 1.0;
        }];
        
        self.hiddenGenderPicker = NO;
    }
}

- (void)closeGenderPicker
{
    if (!self.hiddenGenderPicker) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect subviewsFrame = self.genderSubviewContainer.frame;
            subviewsFrame.origin.y -= PICKERS_HEIGHT;
            self.genderSubviewContainer.frame = subviewsFrame;
            
//            if (self.hiddenEndDatePicker) {
//                [self setScrollViewContentSizeForPickerOpen:NO];
//            }
            
            self.genderPicker.alpha = 0.0;
        }];
        
        self.hiddenGenderPicker = YES;
    }
}

- (void)openBirthdatePicker
{
    if (self.hiddenBirthdatePicker) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect subviewsFrame = self.birthdateSubviewContainer.frame;
            subviewsFrame.origin.y += PICKERS_HEIGHT;
            self.birthdateSubviewContainer.frame = subviewsFrame;
            
            //            if (self.hiddenEndDatePicker) {
            //                [self setScrollViewContentSizeForPickerOpen:YES];
            //            }
            
            self.birthdatePicker.alpha = 1.0;
        }];
        
        self.hiddenBirthdatePicker = NO;
    }
}

- (void)closeBirthdatePicker
{
    
    if (!self.hiddenBirthdatePicker) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect subviewsFrame = self.birthdateSubviewContainer.frame;
            subviewsFrame.origin.y -= PICKERS_HEIGHT;
            self.birthdateSubviewContainer.frame = subviewsFrame;
            
            //            if (self.hiddenEndDatePicker) {
            //                [self setScrollViewContentSizeForPickerOpen:NO];
            //            }
            
            self.birthdatePicker.alpha = 0.0;
        }];
        
        self.hiddenBirthdatePicker = YES;
    }
}

#pragma mark - MSLocationPickerDelegate

- (void)didSelectLocation:(NSString *)location
{
    self.cityValueLabel.text = location;
}

#pragma mark - UIPickerViewDatasource

#define GENDERS @[@"Male", @"Female"]

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [GENDERS count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [GENDERS objectAtIndex:row];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.genderValueLabel.text = [GENDERS objectAtIndex:row];
}

#pragma mark UIImagePickerControllerDelegate

- (void)setProfilePicture:(UIImage *)profilePicture
{
    _profilePicture = profilePicture;
    self.imageView.image = profilePicture;
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
    self.profilePicture = [self imageWithImage:image scaledToSize:CGSizeMake(IMAGE_SIZE_FOR_UPLOAD, IMAGE_SIZE_FOR_UPLOAD)];
    [self.imageView setRounded];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


// Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
// Stack overflow http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;     NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)performTransitionToNextScreen
{
    MSChooseSportsVC *destinationVC = [MSChooseSportsVC newController];
    
    destinationVC.sportner = self.user.sportner;
    
    __weak MSChooseSportsVC *weakDestination = destinationVC;
    destinationVC.validateBlock = ^{
        MSFindFriendsVC *destinationVC = [MSFindFriendsVC newController];
        
        destinationVC.sportner = weakDestination.sportner;
        
        [weakDestination.navigationController pushViewController:destinationVC animated:YES];
    };
    
    self.hasAlreadySignUp = YES;
    [self.navigationController pushViewController:destinationVC animated:YES];
}



//- (IBAction)validateButtonPress:(UIButton *)sender
//{
//    if (self.user) {
//        [self showLoadingViewInView:self.view];
//        [self.user signUpInBackgroundWithTarget:self selector:@selector(handleSignUp:error:)];
//    } else {
//        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't sign up" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
//    }
//}


- (void)handleSignUp:(NSNumber *)result error:(NSError *)error
{
    [self hideLoadingView];
    if (!error) {
        [self performTransitionToNextScreen];
    } else {
        NSString *errorMessage = [error.userInfo objectForKey:@"error"];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:errorMessage];
    }
}

+ (MSVerifyAccountVC *)newController
{
    return [[MSVerifyAccountVC alloc] initWithNibName:NIB_NAME bundle:nil];
}

//- (UIDatePicker *)datePicker
//{
//    if (!_datePicker) {
//        CGRect frame = CGRectMake(0, self.birthdayTextField.frame.origin.y, self.scrollView.frame.size.width, DATEPICKER_HEIGHT);
//        self.datePicker = [[UIDatePicker alloc] initWithFrame:frame];
//        
//        self.datePicker.datePickerMode = UIDatePickerModeDate;
//        self.datePicker.hidden = YES;
//        self.datePicker.maximumDate = [NSDate date];
//        [self.scrollView insertSubview:self.datePicker belowSubview:self.birthdayTextField];
//        [self.datePicker addTarget:self action:@selector(datePickerValueDidChange) forControlEvents:UIControlEventValueChanged];
//        self.datePicker.date = [NSDate dateWithTimeIntervalSince1970:0];
//        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerDidTap)];
//        
//        [self.datePicker addGestureRecognizer:tapGesture];
//    }
//    return _datePicker;
//    return nil;
//}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.firstNameTextField])
    {
        [self.lastNameTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.lastNameTextField])
    {
        [self.lastNameTextField resignFirstResponder];
        [self openGenderPicker];
    }
    else if ([textField isEqual:self.emailTextField])
    {
        [self.emailTextField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextField = nil;
    textField.textColor = [MSColorFactory gray];
}

#pragma mark Keyboard

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // -64 is for nav bar
    self.scrollView.contentSize = CGSizeMake(320, self.scrollView.frame.size.height + kbSize.height - 20);
    CGRect destinationFrame = CGRectMake(0, self.activeTextField.frame.origin.y, 320, self.activeTextField.frame.size.height+kbSize.height+25);
    [self.scrollView scrollRectToVisible:destinationFrame animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollView.contentSize = CGSizeMake(320, self.scrollView.frame.size.height - 20);
    }];
}

#pragma mark - MBProgressHUD

- (void) showLoadingViewInView:(UIView*)v
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
