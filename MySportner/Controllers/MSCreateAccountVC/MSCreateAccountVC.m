//
//  MSCreateAccountVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSCreateAccountVC.h"
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

#define NIB_NAME @"MSCreateAccountVC"

#define CONTROL_HEIGHT 40
#define CONTROL_WIDTH_BIG 270
#define CONTROL_WIDTH_SMALL 150

#define CONTROL_WIDTH_GENDER 85
#define CONTROL_WITH_PASSWORD 170

#define IMAGE_SIZE 105
#define IMAGE_MARGIN_LEFT 15

#define PADDING 25

#define DATEPICKER_HEIGHT 100

#define PLACEHOLDER_FIRSTNAME @"First Name"
#define PLACEHOLDER_LASTNAME @"Last Name"
#define PLACEHOLDER_EMAIL @" E-mail"
#define PLACEHOLDER_PASSWORD @"Password"
#define PLACEHOLDER_BIRTHDAY @"Birthdate"


@interface MSCreateAccountVC () <UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MSCropperVCDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) MSTextField *firstnameTextField;
@property (strong, nonatomic) MSTextField *lastnameTextField;
@property (strong, nonatomic) MSTextField *emailTextField;
@property (strong, nonatomic) MSTextField *passwordTextField;
@property (strong, nonatomic) MSTextField *birthdayTextField;
@property (strong, nonatomic) NKColorSwitch *genderControl;
@property (strong, nonatomic) UILabel *commentLabel;
@property (strong, nonatomic) QBFlatButton *nextButton;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (weak, nonatomic) UIImagePickerController *imagePickerController;

@property (weak, nonatomic) UITextField *activeTextField;

@property (strong,nonatomic) MSUser *user;
@property (strong, nonatomic) UIImage *profilePicture;

@property (strong, nonatomic) MBProgressHUD *loadingView;

@property (nonatomic) BOOL hasAlreadySignUp;

@end

@implementation MSCreateAccountVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"BASIC INFORMATIONS";
    
    [self setFormViews];
    
    [self registerForKeyboardNotifications];
    
    [self setBackButton];
    self.hasAlreadySignUp = NO;
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

- (void)setFormViews
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_blur_light.png"]];
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    UIColor *focusBorderColor = [MSColorFactory redLight];
    UIColor *textFieldTextColorFocused = [MSColorFactory redLight];
    UIColor *textFieldTextColorNormal = [MSColorFactory gray];
    
    self.firstnameTextField = [[MSTextField alloc] initWithFrame:CGRectMake(PADDING, PADDING, CONTROL_WIDTH_SMALL, CONTROL_HEIGHT)];
    self.firstnameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.firstnameTextField.delegate = self;
    self.firstnameTextField.placeholder = PLACEHOLDER_FIRSTNAME;
    self.firstnameTextField.focusBorderColor = focusBorderColor;
    self.firstnameTextField.textFocusedColor = textFieldTextColorFocused;
    self.firstnameTextField.textNormalColor = textFieldTextColorNormal;
    [self.firstnameTextField initializeAppearanceWithShadow:YES];
    self.firstnameTextField.returnKeyType = UIReturnKeyNext;
    [self.scrollView addSubview:self.firstnameTextField];
    
    self.lastnameTextField = [[MSTextField alloc] initWithFrame:CGRectMake(PADDING, self.firstnameTextField.frame.origin.y+self.firstnameTextField.frame.size.height+PADDING, CONTROL_WIDTH_SMALL, CONTROL_HEIGHT)];
    self.lastnameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.lastnameTextField.delegate = self;
    self.lastnameTextField.placeholder = PLACEHOLDER_LASTNAME;
    self.lastnameTextField.focusBorderColor = focusBorderColor;
    self.lastnameTextField.textFocusedColor = textFieldTextColorFocused;
    self.lastnameTextField.textNormalColor = textFieldTextColorNormal;
    [self.lastnameTextField initializeAppearanceWithShadow:YES];
    self.lastnameTextField.returnKeyType = UIReturnKeyNext;
    [self.scrollView addSubview:self.lastnameTextField];
    
    self.emailTextField = [[MSTextField alloc] initWithFrame:CGRectMake(PADDING, self.lastnameTextField.frame.origin.y+self.lastnameTextField.frame.size.height+PADDING, CONTROL_WIDTH_BIG, CONTROL_HEIGHT)];
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailTextField.delegate = self;
    self.emailTextField.placeholder = PLACEHOLDER_EMAIL;
    self.emailTextField.focusBorderColor = focusBorderColor;
    self.emailTextField.textFocusedColor = textFieldTextColorFocused;
    self.emailTextField.textNormalColor = textFieldTextColorNormal;
    [self.emailTextField initializeAppearanceWithShadow:YES];
    //    self.emailTextField.font = [UIFont preferredFontForTextStyle:FONT_IDENTIFIER_TEXTFIELD];
    [self.emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    self.emailTextField.returnKeyType = UIReturnKeyNext;
    [self.scrollView addSubview:self.emailTextField];
    
    
    CGRect smallFrame = CGRectMake(PADDING, self.emailTextField.frame.origin.y+self.emailTextField.frame.size.height+PADDING, CONTROL_WITH_PASSWORD, CONTROL_HEIGHT);
    self.passwordTextField = [[MSTextField alloc] initWithFrame:smallFrame];
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.delegate = self;
    self.passwordTextField.placeholder = PLACEHOLDER_PASSWORD;
    self.passwordTextField.focusBorderColor = focusBorderColor;
    self.passwordTextField.textFocusedColor = textFieldTextColorFocused;
    self.passwordTextField.textNormalColor = textFieldTextColorNormal;
    [self.passwordTextField initializeAppearanceWithShadow:YES];
    self.passwordTextField.returnKeyType = UIReturnKeyNext;
    //    self.passwordTextField.font = [UIFont preferredFontForTextStyle:FONT_IDENTIFIER_TEXTFIELD];
    [self.scrollView addSubview:self.passwordTextField];
    
    self.genderControl = [[NKColorSwitch alloc] initWithFrame:CGRectMake(self.passwordTextField.frame.origin.x+self.passwordTextField.frame.size.width+IMAGE_MARGIN_LEFT, self.passwordTextField.frame.origin.y, CONTROL_WIDTH_GENDER, CONTROL_HEIGHT)];
    [self.genderControl setTintColor:[MSColorFactory mainColor]];
    [self.genderControl setOnTintColor:[MSColorFactory redLight]];
    [self.genderControl setThumbTintColor:[MSColorFactory whiteLight]];
    self.genderControl.leftLabel.text = @"F";
    self.genderControl.rightLabel.text = @"M";
    self.genderControl.leftLabel.shadowOffset = CGSizeMake(0.2, 1.8);
    self.genderControl.rightLabel.shadowOffset = CGSizeMake(0.2, 1.8);
    self.genderControl.leftLabel.shadowColor = [MSColorFactory mainColorShadow];
    self.genderControl.rightLabel.shadowColor = [MSColorFactory redShadow];
    self.genderControl.textColor = [MSColorFactory whiteLight];
    self.genderControl.textFont = [MSFontFactory fontForButton];
    [self.scrollView addSubview:self.genderControl];
    
    
    self.birthdayTextField = [[MSTextField alloc] initWithFrame:CGRectMake(PADDING, self.passwordTextField.frame.origin.y+self.passwordTextField.frame.size.height+PADDING, CONTROL_WIDTH_BIG, CONTROL_HEIGHT)];
    self.birthdayTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.birthdayTextField.delegate = self;
    self.birthdayTextField.placeholder = PLACEHOLDER_BIRTHDAY;
    self.birthdayTextField.focusBorderColor = focusBorderColor;
    self.birthdayTextField.textFocusedColor = textFieldTextColorFocused;
    self.birthdayTextField.textNormalColor = textFieldTextColorNormal;
    [self.birthdayTextField initializeAppearanceWithShadow:YES];
    //    self.birthdayTextField.font = [UIFont preferredFontForTextStyle:FONT_IDENTIFIER_TEXTFIELD];
    [self.scrollView addSubview:self.birthdayTextField];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.firstnameTextField.frame.origin.x+self.firstnameTextField.frame.size.width+IMAGE_MARGIN_LEFT, PADDING, IMAGE_SIZE, IMAGE_SIZE)];
    self.imageView.backgroundColor = [UIColor grayColor];
    self.imageView.image = [UIImage imageNamed:@"pick_a_pic.png"];
    self.imageView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *pictureTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureTapHandler)];
    [self.imageView addGestureRecognizer:pictureTapGesture];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView setCornerRadius:3.0];
    self.imageView.clipsToBounds = YES;
    [self.scrollView addSubview:self.imageView];
    
    
    self.nextButton = [[QBFlatButton alloc] initWithFrame:[self nextButtonNormalFrame]];
    [self.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.faceColor = [MSColorFactory mainColor];
    self.nextButton.sideColor = [MSColorFactory mainColorDark];
    self.nextButton.titleLabel.font = [MSFontFactory fontForButton];
    [self.nextButton setTitleShadowColor:[MSColorFactory mainColorShadow] forState:UIControlStateNormal];
    self.nextButton.titleLabel.shadowOffset = CGSizeMake(0.2, 1.8);
    [self.nextButton setTitleColor:[MSColorFactory whiteLight] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.nextButton];
    
    
    self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, self.nextButton.frame.origin.y-80, 280, 80)];
    self.commentLabel.text = @"By clicking in next button, you  accept the general terms and conditions of use.";
    self.commentLabel.textAlignment = NSTextAlignmentCenter;
    [self.commentLabel setFont:[MSFontFactory fontForInfoLabel]];
    self.commentLabel.textColor = [MSColorFactory gray];
    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.commentLabel.numberOfLines = 0;
    //    [self.scrollView addSubview:self.commentLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(closeAllResponders)];
    
    [self.view addGestureRecognizer:tap];
}

- (CGRect)nextButtonNormalFrame
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    return CGRectMake(PADDING, screenBound.size.height-PADDING-CONTROL_HEIGHT-64, screenBound.size.width-PADDING*2, CONTROL_HEIGHT+10);
}

- (CGRect)nextButtonDownFrame
{
    CGRect tempFrame = [self nextButtonNormalFrame];
    return CGRectMake(tempFrame.origin.x, tempFrame.origin.y+DATEPICKER_HEIGHT, tempFrame.size.width, tempFrame.size.height);
}

- (MSUser *)user
{
    if (!_user) _user = [[MSUser alloc] init];
    return _user;
}

- (void)nextButtonHandler
{
    NSString *message = nil;
    NSString *title = @"Profile incomplete";
    
    if (![self.firstnameTextField.text length])
    {
        message = @"Please fill in your first name";
    }
    else if (![self.lastnameTextField.text length])
    {
        message = @"Please fill in your last name";
    }
    else if (![self.emailTextField.text length])
    {
        message = @"Please fill in your email";
    }
    else if (![self NSStringIsValidEmail:self.emailTextField.text])
    {
        title = @"Error";
        message = @"Your email address is invalid";
    }
    else if (![self.passwordTextField.text length])
    {
        message = @"Please fill in your password";
    }
    else if (![self.birthdayTextField.text length])
    {
        message = @"Please fill in your birthday";
    } else if (!self.profilePicture) {
//        message = @"Please pick a picture";
    }
    
    
    if (message && title)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
        [self SetFocusOnFailedField];
    } else {
        [self showLoadingViewInView:self.view];
        
        if (self.hasAlreadySignUp) {
            self.user = [MSUser currentUser];
        } else {
            self.user = [[MSUser alloc] init];
        }
        
        if (!self.user.sportner) {
            self.user.sportner = [[MSSportner alloc] init];
        }
        
        self.user.sportner.firstName = self.firstnameTextField.text;
        self.user.sportner.lastName = self.lastnameTextField.text;
        self.user.email = self.emailTextField.text;
        self.user.password = self.passwordTextField.text;
        self.user.sportner.birthday = self.datePicker.date;
        self.user.sportner.gender = self.genderControl.isOn ? MSUserGenderFemale : MSUserGenderMale;
        self.user.username = self.user.email;
        self.user.sportner.username = self.user.email;
        self.user.sportner.facebookID = FACEBOOK_DEFAULT_ID[self.user.sportner.gender]; // default IDs to get a fb picture according to your gender
        self.user.sportner.image = self.imageView.image;
        if (self.hasAlreadySignUp) {
            [self.user saveInBackgroundWithTarget:self selector:@selector(handleSignUp:error:)];
        } else {
            [self.user signUpInBackgroundWithTarget:self selector:@selector(handleSignUp:error:)];
        }
    }
}


- (void)pictureTapHandler
{
    UIImagePickerController *destinationVC = [[UIImagePickerController alloc] init];
    destinationVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    destinationVC.delegate = self;
    [self presentViewController:destinationVC animated:YES completion:nil];
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

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self SetFocusOnFailedField];
}

- (void)SetFocusOnFailedField
{
    if (![self.firstnameTextField.text length])
    {
        [self.firstnameTextField becomeFirstResponder];
    }
    else if (![self.lastnameTextField.text length])
    {
        [self.lastnameTextField becomeFirstResponder];
    }
    else if (![self.emailTextField.text length])
    {
        [self.emailTextField becomeFirstResponder];
    }
    else if (![self NSStringIsValidEmail:self.emailTextField.text])
    {
        [self.emailTextField becomeFirstResponder];
    }
    else if (![self.passwordTextField.text length])
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (![self.birthdayTextField.text length])
    {
        if (self.datePicker.hidden) {
            [self openDatePicker];
        }
    }
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

+ (MSCreateAccountVC *)newController
{
    return [[MSCreateAccountVC alloc] initWithNibName:NIB_NAME bundle:nil];
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        CGRect frame = CGRectMake(0, self.birthdayTextField.frame.origin.y, self.scrollView.frame.size.width, DATEPICKER_HEIGHT);
        self.datePicker = [[UIDatePicker alloc] initWithFrame:frame];
        
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.hidden = YES;
        self.datePicker.maximumDate = [NSDate date];
        [self.scrollView insertSubview:self.datePicker belowSubview:self.birthdayTextField];
        [self.datePicker addTarget:self action:@selector(datePickerValueDidChange) forControlEvents:UIControlEventValueChanged];
        self.datePicker.date = [NSDate dateWithTimeIntervalSince1970:0];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerDidTap)];
        
        [self.datePicker addGestureRecognizer:tapGesture];
    }
    return _datePicker;
}

#pragma mark UITextFieldDelegate


- (void)closeAllResponders
{
    [self.activeTextField resignFirstResponder];
    if (!self.datePicker.hidden)
    {
        [self closeDatePicker];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.birthdayTextField])
    {
        [self toogleDatePicker];
        
        return NO;
    }
    else
    {
        if (!self.datePicker.hidden) {
            [self closeDatePicker];
        }
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.firstnameTextField])
    {
        [self.lastnameTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.lastnameTextField])
    {
        [self.emailTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.emailTextField])
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.passwordTextField])
    {
        [textField resignFirstResponder];
        [self openDatePicker];
    }
    
    return YES;
}

- (void)toogleDatePicker
{
    self.datePicker.hidden ? [self openDatePicker] : [self closeDatePicker];
}

- (void)openDatePicker
{
    [self.activeTextField resignFirstResponder];
    [self.birthdayTextField setFocused:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.hidden = NO;
        self.nextButton.frame = [self nextButtonDownFrame];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.frame.size.height+DATEPICKER_HEIGHT-64);
    }];
}

- (void)closeDatePicker
{
    [self.birthdayTextField setFocused:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.hidden = YES;
        self.nextButton.frame = [self nextButtonNormalFrame];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.frame.size.height-DATEPICKER_HEIGHT);
    }];
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

#pragma mark DatePicker Handler


- (void)datePickerValueDidChange
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd - MM - yyyy"];
    self.birthdayTextField.text = [dateFormat stringFromDate:self.datePicker.date];
}

- (void)datePickerDidTap
{
    [self datePickerValueDidChange];
    [self closeDatePicker];
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
    self.scrollView.contentSize = CGSizeMake(320, self.scrollView.frame.size.height + kbSize.height - 64);
    CGRect destinationFrame = CGRectMake(0, self.activeTextField.frame.origin.y, 320, self.activeTextField.frame.size.height+kbSize.height+PADDING);
    [self.scrollView scrollRectToVisible:destinationFrame animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollView.contentSize = CGSizeMake(320, self.scrollView.frame.size.height - 64);
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
