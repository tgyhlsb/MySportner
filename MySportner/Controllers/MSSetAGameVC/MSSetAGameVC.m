//
//  MSSetAGameVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSSetAGameVC.h"
#import "MSPickSportCell.h"
#import "MSTextFieldPickerCell.h"
#import "MSLocationPickerCell.h"
#import "MSActivity.h"
#import "MBProgressHUD.h"
#import "MSActivityVC.h"

#define NIB_NAME @"MSSetAGameVC"

typedef NS_ENUM(int, MSSetAGameSection) {
    MSSetAGameSectionPickSport,
    MSSetAGameSectionTextField,
    MSSetAGameSectionSizePicker
};

typedef NS_ENUM(int, MSSetAGameTextFieldType) {
    MSSetAGameTextFieldTypeDay,
    MSSetAGameTextFieldTypeTime,
    MSSetAGameTextFieldTypeRepeat,
    MSSetAGameTextFieldTypeLocation
};

@interface MSSetAGameVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITextField *dayTextField;
@property (strong, nonatomic) IBOutlet UITextField *timeTextField;
@property (strong, nonatomic) IBOutlet UITextField *repeatTextField;
@property (strong, nonatomic) IBOutlet MSLocationPickerCell *venueCell;
@property (strong, nonatomic) IBOutlet MSPickSportCell *sportCell;

@property (strong, nonatomic) MBProgressHUD *loadingView;

@end

@implementation MSSetAGameVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
	
    [MSLocationPickerCell registerToTableView:self.tableView];
    [MSPickSportCell registerToTableView:self.tableView];
    [MSTextFieldPickerCell registerToTableView:self.tableView];
    
    UIBarButtonItem *validateButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(createActivity)];
    
    [self.navigationItem setRightBarButtonItem:validateButton];
    
    [self registerForKeyboardNotifications];
}

+ (MSSetAGameVC *)newController
{
    MSSetAGameVC *setAGameVC = [[MSSetAGameVC alloc] initWithNibName:NIB_NAME bundle:nil];
    setAGameVC.hasDirectAccessToDrawer = YES;
    return setAGameVC;
}

- (void)createActivity
{
    MSActivity *activity = [[MSActivity alloc] init];
    
    activity.day = self.dayTextField.text;
    activity.time = self.timeTextField.text;
    activity.sport = self.sportCell.sport;
    activity.place = self.venueCell.venue.name;
    activity.owner = [MSUser currentUser];
    activity.guests = [[NSArray alloc] init];
    activity.participants = [[NSArray alloc] init];
    
    [self showLoadingViewInView:self.navigationController.view];
    [activity saveInBackgroundWithTarget:self selector:@selector(handleActivityCreation:error:)];
}

- (void)handleActivityCreation:(BOOL)succeed error:(NSError *)error
{
    [self hideLoadingView];
    if (!error) {
        [self activityCreationDidSucceed];
    } else {
        NSLog(@"%@", error);
    }
}

- (void)activityCreationDidSucceed
{
    MSActivityVC *destinationVC = [MSActivityVC newController];
    destinationVC.hasDirectAccessToDrawer = YES;
    
    [self.navigationController setViewControllers:@[destinationVC] animated:YES];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case MSSetAGameSectionPickSport:
            return 1;
        case MSSetAGameSectionTextField:
            return 4;
        case MSSetAGameSectionSizePicker:
            return 0;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case MSSetAGameSectionPickSport:
        {
            MSPickSportCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSPickSportCell reusableIdentifier] forIndexPath:indexPath];
            
            [cell initialize];
            self.sportCell = cell;
            
            return cell;
        }
        case MSSetAGameSectionTextField:
        {
            switch (indexPath.row) {
                case MSSetAGameTextFieldTypeDay:
                {
                    MSTextFieldPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSTextFieldPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"Day";
                    self.dayTextField = cell.textField;
                    
                    return cell;
                }
                    
                case MSSetAGameTextFieldTypeTime:
                {
                    MSTextFieldPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSTextFieldPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"Time";
                    self.timeTextField = cell.textField;
                    
                    return cell;
                }
                    
                case MSSetAGameTextFieldTypeRepeat:
                {
                    MSTextFieldPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSTextFieldPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"Repeat";
                    self.repeatTextField = cell.textField;
                    
                    return cell;
                }
                    
                case MSSetAGameTextFieldTypeLocation:
                {
                    MSLocationPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:[MSLocationPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"Location";
                    self.venueCell = cell;
                    
                    return cell;
                }
                    
                default:
                    return nil;
            }
        }
        case MSSetAGameSectionSizePicker:
        {
            
        }
            
        default:
            return nil;
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case MSSetAGameSectionPickSport:
            return [MSPickSportCell height];
            
        case MSSetAGameSectionTextField:
            return [MSTextFieldPickerCell height];
            
        default:
            return 44;
    }
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
    self.tableView.contentSize = CGSizeMake(320, self.tableView.frame.size.height + kbSize.height - 64);
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.contentSize = CGSizeMake(320, self.tableView.frame.size.height - 64);
    }];
}

- (void)dismissKeyboard
{
    [self resignFirstResponder];
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
        self.loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
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
