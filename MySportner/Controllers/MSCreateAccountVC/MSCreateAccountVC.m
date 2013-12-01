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

#define NIB_NAME @"MSCreateAccountVC"

#define CONTROL_HEIGHT 40
#define CONTROL_WIDTH_BIG 270
#define CONTROL_WIDTH_SMALL 150

#define CONTROL_WIDTH_GENDER 125
#define CONTROL_WITH_BIRTHDAY 130

#define IMAGE_SIZE 105
#define IMAGE_MARGIN_LEFT 15

#define PADDING 25

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
@property (strong, nonatomic) UISwitch *genderControl;
@property (strong, nonatomic) UILabel *commentLabel;
@property (strong, nonatomic) QBFlatButton *nextButton;

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
    [self.scrollView addSubview:self.firstnameTextField];
    
    self.lastnameTextField = [[MSTextField alloc] initWithFrame:CGRectMake(PADDING, self.firstnameTextField.frame.origin.y+self.firstnameTextField.frame.size.height+PADDING, CONTROL_WIDTH_SMALL, CONTROL_HEIGHT)];
    self.lastnameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.lastnameTextField.delegate = self;
    self.lastnameTextField.placeholder = PLACEHOLDER_LASTNAME;
    self.lastnameTextField.focusBorderColor = focusBorderColor;
    self.lastnameTextField.textColor = textFieldTextColor;
    [self.lastnameTextField initializeAppearanceWithShadow:YES];
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
    [self.scrollView addSubview:self.emailTextField];
    
    self.birthdayTextField = [[MSTextField alloc] initWithFrame:CGRectMake(PADDING, self.emailTextField.frame.origin.y+self.emailTextField.frame.size.height+PADDING, CONTROL_WITH_BIRTHDAY, CONTROL_HEIGHT)];
    self.birthdayTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.birthdayTextField.delegate = self;
    self.birthdayTextField.placeholder = PLACEHOLDER_BIRTHDAY;
    self.birthdayTextField.focusBorderColor = focusBorderColor;
    self.birthdayTextField.textColor = textFieldTextColor;
    [self.birthdayTextField initializeAppearanceWithShadow:YES];
//    self.birthdayTextField.font = [UIFont preferredFontForTextStyle:FONT_IDENTIFIER_TEXTFIELD];
    [self.scrollView addSubview:self.birthdayTextField];
    
    self.genderControl = [[UISwitch alloc] initWithFrame:CGRectMake(self.birthdayTextField.frame.origin.x+self.birthdayTextField.frame.size.width+IMAGE_MARGIN_LEFT, self.emailTextField.frame.origin.y+self.emailTextField.frame.size.height+PADDING, CONTROL_WIDTH_GENDER, CONTROL_HEIGHT)];
    [self.scrollView addSubview:self.genderControl];
    
    self.passwordTextField = [[MSTextField alloc] initWithFrame:CGRectMake(PADDING, self.birthdayTextField.frame.origin.y+self.birthdayTextField.frame.size.height+PADDING, CONTROL_WIDTH_BIG, CONTROL_HEIGHT)];
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.delegate = self;
    self.passwordTextField.placeholder = PLACEHOLDER_PASSWORD;
    self.passwordTextField.focusBorderColor = focusBorderColor;
    self.passwordTextField.textColor = textFieldTextColor;
    [self.passwordTextField initializeAppearanceWithShadow:YES];
    //    self.passwordTextField.font = [UIFont preferredFontForTextStyle:FONT_IDENTIFIER_TEXTFIELD];
    [self.scrollView addSubview:self.passwordTextField];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.firstnameTextField.frame.origin.x+self.firstnameTextField.frame.size.width+IMAGE_MARGIN_LEFT, PADDING, IMAGE_SIZE, IMAGE_SIZE)];
    self.imageView.backgroundColor = [UIColor grayColor];
    self.imageView.image = [UIImage imageNamed:@"pick_a_pic.png"];
    self.imageView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.imageView];
    
    CGRect frame = CGRectMake(PADDING, self.view.frame.size.height-PADDING-CONTROL_HEIGHT-64, self.view.frame.size.width-PADDING, CONTROL_HEIGHT);
    self.nextButton = [[QBFlatButton alloc] initWithFrame:frame];
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.faceColor = [MSColorFactory mainColor];
    self.nextButton.sideColor = [MSColorFactory mainColor];
    [self.scrollView addSubview:self.nextButton];
    
    
    self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, self.nextButton.frame.origin.y-CONTROL_HEIGHT, 280, CONTROL_HEIGHT)];
    self.commentLabel.text = @"Terms and conditions";
    self.commentLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.commentLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)nextButtonHandler
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

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.birthdayTextField])
    {
        return YES;
    }
    else
    {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
    [self.scrollView scrollRectToVisible:textField.frame animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextField = nil;
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
