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
#define PLACEHOLDER_BIRTHDAY @"Birthday"

@interface MSCreateAccountVC () <UITextFieldDelegate>

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

@property (weak, nonatomic) UITextField *activeTextField;

@end

@implementation MSCreateAccountVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"BASIC INFORMATIONS";
    
    [self setFormViews];
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setFormViews
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iOS_blur.png"]];
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    UIColor *focusBorderColor = [MSColorFactory redLight];
    UIColor *textFieldTextColor = [MSColorFactory redLight];
    
    self.firstnameTextField = [[MSTextField alloc] initWithFrame:CGRectMake(PADDING, PADDING, CONTROL_WIDTH_SMALL, CONTROL_HEIGHT)];
    self.firstnameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.firstnameTextField.delegate = self;
    self.firstnameTextField.placeholder = PLACEHOLDER_FIRSTNAME;
    self.firstnameTextField.focusBorderColor = focusBorderColor;
    self.firstnameTextField.textColor = textFieldTextColor;
    [self.firstnameTextField initializeAppearanceWithShadow:YES];
    self.firstnameTextField.returnKeyType = UIReturnKeyNext;
    [self.scrollView addSubview:self.firstnameTextField];
    
    self.lastnameTextField = [[MSTextField alloc] initWithFrame:CGRectMake(PADDING, self.firstnameTextField.frame.origin.y+self.firstnameTextField.frame.size.height+PADDING, CONTROL_WIDTH_SMALL, CONTROL_HEIGHT)];
    self.lastnameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.lastnameTextField.delegate = self;
    self.lastnameTextField.placeholder = PLACEHOLDER_LASTNAME;
    self.lastnameTextField.focusBorderColor = focusBorderColor;
    self.lastnameTextField.textColor = textFieldTextColor;
    [self.lastnameTextField initializeAppearanceWithShadow:YES];
    self.lastnameTextField.returnKeyType = UIReturnKeyNext;
    [self.scrollView addSubview:self.lastnameTextField];
    
    self.emailTextField = [[MSTextField alloc] initWithFrame:CGRectMake(PADDING, self.lastnameTextField.frame.origin.y+self.lastnameTextField.frame.size.height+PADDING, CONTROL_WIDTH_BIG, CONTROL_HEIGHT)];
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.delegate = self;
    self.emailTextField.placeholder = PLACEHOLDER_EMAIL;
    self.emailTextField.focusBorderColor = focusBorderColor;
    self.emailTextField.textColor = textFieldTextColor;
    [self.emailTextField initializeAppearanceWithShadow:YES];
    //    self.emailTextField.font = [UIFont preferredFontForTextStyle:FONT_IDENTIFIER_TEXTFIELD];
    [self.emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    self.emailTextField.returnKeyType = UIReturnKeyNext;
    [self.scrollView addSubview:self.emailTextField];
    
    
    CGRect smallFrame = CGRectMake(PADDING, self.emailTextField.frame.origin.y+self.emailTextField.frame.size.height+PADDING, CONTROL_WITH_PASSWORD, CONTROL_HEIGHT);
    self.passwordTextField = [[MSTextField alloc] initWithFrame:smallFrame];
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.delegate = self;
    self.passwordTextField.placeholder = PLACEHOLDER_PASSWORD;
    self.passwordTextField.focusBorderColor = focusBorderColor;
    self.passwordTextField.textColor = textFieldTextColor;
    [self.passwordTextField initializeAppearanceWithShadow:YES];
    self.passwordTextField.returnKeyType = UIReturnKeyNext;
    //    self.passwordTextField.font = [UIFont preferredFontForTextStyle:FONT_IDENTIFIER_TEXTFIELD];
    [self.scrollView addSubview:self.passwordTextField];
    
    self.genderControl = [[NKColorSwitch alloc] initWithFrame:CGRectMake(self.passwordTextField.frame.origin.x+self.passwordTextField.frame.size.width+IMAGE_MARGIN_LEFT, self.passwordTextField.frame.origin.y, CONTROL_WIDTH_GENDER, CONTROL_HEIGHT)];
    [self.genderControl setTintColor:[MSColorFactory mainColor]];
    [self.genderControl setOnTintColor:[MSColorFactory redLight]];
    [self.genderControl setThumbTintColor:[MSColorFactory whiteLight]];
    [self.scrollView addSubview:self.genderControl];
    
    
    self.birthdayTextField = [[MSTextField alloc] initWithFrame:CGRectMake(PADDING, self.passwordTextField.frame.origin.y+self.passwordTextField.frame.size.height+PADDING, CONTROL_WIDTH_BIG, CONTROL_HEIGHT)];
    self.birthdayTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.birthdayTextField.delegate = self;
    self.birthdayTextField.placeholder = PLACEHOLDER_BIRTHDAY;
    self.birthdayTextField.focusBorderColor = focusBorderColor;
    self.birthdayTextField.textColor = textFieldTextColor;
    [self.birthdayTextField initializeAppearanceWithShadow:YES];
    //    self.birthdayTextField.font = [UIFont preferredFontForTextStyle:FONT_IDENTIFIER_TEXTFIELD];
    [self.scrollView addSubview:self.birthdayTextField];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.firstnameTextField.frame.origin.x+self.firstnameTextField.frame.size.width+IMAGE_MARGIN_LEFT, PADDING, IMAGE_SIZE, IMAGE_SIZE)];
    self.imageView.backgroundColor = [UIColor grayColor];
    self.imageView.image = [UIImage imageNamed:@"pick_a_pic.png"];
    self.imageView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.imageView];
    
    
    self.nextButton = [[QBFlatButton alloc] initWithFrame:[self nextButtonNormalFrame]];
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.faceColor = [MSColorFactory mainColor];
    self.nextButton.sideColor = [MSColorFactory mainColorDark];
    [self.nextButton setTitleColor:[MSColorFactory whiteLight] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.nextButton];
    
    
    self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, self.nextButton.frame.origin.y-80, 280, 80)];
    self.commentLabel.text = @"By clicking in next button, you  accept the general terms and conditions of use.";
    self.commentLabel.textAlignment = NSTextAlignmentCenter;
    [self.commentLabel setFont:[MSFontFactory fontForCommentLabel]];
    self.commentLabel.textColor = [MSColorFactory gray];
    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.commentLabel.numberOfLines = 0;
    //    [self.scrollView addSubview:self.commentLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (CGRect)nextButtonNormalFrame
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    return CGRectMake(PADDING, screenBound.size.height-PADDING-CONTROL_HEIGHT-64, screenBound.size.width-PADDING*2, CONTROL_HEIGHT);
}

- (CGRect)nextButtonDownFrame
{
    CGRect tempFrame = [self nextButtonNormalFrame];
    return CGRectMake(tempFrame.origin.x, tempFrame.origin.y+DATEPICKER_HEIGHT, tempFrame.size.width, tempFrame.size.height);
}

- (void)nextButtonHandler
{
    NSString *message = nil;
    NSString *title = @"Profile incomplete";
    NSString *cancel = @"Cancel";
    
    if (![self.firstnameTextField.text length])
    {
        message = @"Please fill in your first name";
        [self.firstnameTextField becomeFirstResponder];
    }
    else if (![self.lastnameTextField.text length])
    {
        message = @"Please fill in your last name";
        [self.lastnameTextField becomeFirstResponder];
    }
    else if (![self.emailTextField.text length])
    {
        message = @"Please fill in your email";
        [self.emailTextField becomeFirstResponder];
    }
    else if (![self NSStringIsValidEmail:self.emailTextField.text])
    {
        title = @"Error";
        message = @"Your email address is invalid";
        [self.emailTextField becomeFirstResponder];
    }
    else if (![self.passwordTextField.text length])
    {
        message = @"Please fill in your password";
        [self.passwordTextField becomeFirstResponder];
    }
    else if (![self.birthdayTextField.text length])
    {
        message = @"Please fill in your birthday";
        if (self.datePicker.hidden) {
            [self openDatePicker];
        }
    }
    
    
    if (message && title)
    {
        [[[UIAlertView alloc] initWithTitle:title
                                    message:message
                                   delegate:self
                          cancelButtonTitle:cancel
                          otherButtonTitles:nil] show];
    } else {
        [self performTransitionToNextScreen];
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
    
    destinationVC.user = [[MSUser alloc] init];
    
    destinationVC.user.firstName = self.firstnameTextField.text;
    destinationVC.user.lastName = self.lastnameTextField.text;
    destinationVC.user.email = self.emailTextField.text;
    destinationVC.user.password = self.passwordTextField.text;
    destinationVC.user.birthday = [NSDate date];
    destinationVC.user.gender = self.genderControl.isOn ? MSUserGenderFemale : MSUserGenderMale;
    destinationVC.user.username = destinationVC.user.email;
    destinationVC.user.facebookID = FACEBOOK_DEFAULT_ID[destinationVC.user.gender]; // default IDs to get a fb picture according to your gender
    
    [self.navigationController pushViewController:destinationVC animated:YES];
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
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerDidTap)];
        
        [self.datePicker addGestureRecognizer:tapGesture];
    }
    return _datePicker;
}

#pragma mark UITextFieldDelegate

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

- (void)dismissKeyboard
{
    [self.activeTextField resignFirstResponder];
}

@end
