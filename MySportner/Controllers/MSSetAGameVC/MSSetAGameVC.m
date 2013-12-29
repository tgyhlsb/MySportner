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

#define REPEAT_VALUES @[@"Never", @"Weekly", @"Monthly"]

typedef NS_ENUM(int, MSSetAGameSection) {
    MSSetAGameSectionPickSport,
    MSSetAGameSectionTextField,
    MSSetAGameSectionSizePicker
};

typedef NS_ENUM(int, MSSetAGameTextFieldType) {
    MSSetAGameTextFieldTypeRepeat,
    MSSetAGameTextFieldTypeDay,
    MSSetAGameTextFieldTypeTime,
    MSSetAGameTextFieldTypeLocation
};

@interface MSSetAGameVC () <UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITextField *dayTextField;
@property (strong, nonatomic) IBOutlet UITextField *timeTextField;
@property (strong, nonatomic) IBOutlet UITextField *repeatTextField;
@property (strong, nonatomic) IBOutlet MSLocationPickerCell *venueCell;
@property (strong, nonatomic) IBOutlet MSPickSportCell *sportCell;

@property (strong, nonatomic) UIDatePicker *dayPicker;
@property (strong, nonatomic) UIDatePicker *timePicker;
@property (strong, nonatomic) UIPickerView *repeatPicker;

@property (strong, nonatomic) MBProgressHUD *loadingView;

@property (weak, nonatomic) MSTextField *activeTextField;
@property (strong, nonatomic) NSDate *activityDate;
@property (nonatomic) NSInteger repeatMode;

@end

@implementation MSSetAGameVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	
    [MSLocationPickerCell registerToTableView:self.tableView];
    [MSPickSportCell registerToTableView:self.tableView];
    [MSTextFieldPickerCell registerToTableView:self.tableView];
    
    UIBarButtonItem *validateButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(createActivity)];
    
    [self.navigationItem setRightBarButtonItem:validateButton];
    
    [self registerForKeyboardNotifications];
    
    self.navigationItem.title = @"SET A GAME";
    
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initializePickers];
}

- (void)initializePickers
{
    self.repeatMode = 0;
    [self dayPickerValueDidChange];
    [self timePickerValueDidChange];
}

- (void)setRepeatMode:(NSInteger)repeatMode
{
    _repeatMode = repeatMode;
    
    self.repeatTextField.text = [REPEAT_VALUES objectAtIndex:self.repeatMode];
}

- (NSDate *)activityDate
{
    if (!_activityDate) _activityDate = [NSDate date];
    return _activityDate;
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

#pragma mark DatePickers Handlers

- (void)updateAcitivityDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit|NSHourCalendarUnit|NSSecondCalendarUnit) fromDate:self.dayPicker.date];
    NSDateComponents *timeComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit|NSHourCalendarUnit|NSSecondCalendarUnit) fromDate:self.timePicker.date];
    
    [dayComponents setHour:timeComponents.hour];
    [dayComponents setMinute:timeComponents.minute];
    [dayComponents setSecond:0];
    
    self.activityDate = [calendar dateFromComponents:dayComponents];    
}

- (void)dayPickerValueDidChange
{
    [self updateAcitivityDate];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd - MM - yyyy"];
    self.dayTextField.text = [dateFormat stringFromDate:self.activityDate];
}

- (void)dayPickerDidTap
{
    
}

- (void)timePickerValueDidChange
{
    [self updateAcitivityDate];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm"];
    self.timeTextField.text = [dateFormat stringFromDate:self.activityDate];
}

- (void)timePickerDidTap
{
    
}

#pragma mark ExtensiveCellDelegate

- (UIView *)viewForContainerAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row - 1) {
        case MSSetAGameTextFieldTypeDay:
            return self.dayPicker;
        case MSSetAGameTextFieldTypeTime:
            return self.timePicker;
        case MSSetAGameTextFieldTypeRepeat:
            return self.repeatPicker;
            
        default:
            return nil;
    }
}

- (UIDatePicker *)dayPicker
{
    if (!_dayPicker) {
        _dayPicker = [[UIDatePicker alloc] init];
        CGRect tempFrame = _dayPicker.frame;
        tempFrame.origin.y = -50;
        _dayPicker.frame = tempFrame;
        _dayPicker.datePickerMode = UIDatePickerModeDate;
        _dayPicker.minimumDate = [NSDate date];
        [_dayPicker addTarget:self action:@selector(dayPickerValueDidChange) forControlEvents:UIControlEventValueChanged];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dayPickerDidTap)];
        [_dayPicker addGestureRecognizer:tapGesture];
    }
    return _dayPicker;
}

- (UIDatePicker *)timePicker
{
    if (!_timePicker) {
        _timePicker = [[UIDatePicker alloc] init];
        CGRect tempFrame = _timePicker.frame;
        tempFrame.origin.y = -50;
        _timePicker.frame = tempFrame;
        _timePicker.datePickerMode = UIDatePickerModeTime;
        [_timePicker addTarget:self action:@selector(timePickerValueDidChange) forControlEvents:UIControlEventValueChanged];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timePickerDidTap)];
        [_timePicker addGestureRecognizer:tapGesture];
    }
    return _timePicker;
}

- (UIPickerView *)repeatPicker
{
    if (!_repeatPicker) {
        _repeatPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, -30, 320, 10)];
        _repeatPicker.delegate = self;
        _repeatPicker.dataSource = self;
    }
    return _repeatPicker;
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    return [REPEAT_VALUES count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [REPEAT_VALUES count];
}

#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [REPEAT_VALUES objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.repeatMode = row;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSections
{
    return 2;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
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

- (UITableViewCell *)extensiveCellForRowIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case MSSetAGameSectionPickSport:
        {
            MSPickSportCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MSPickSportCell reusableIdentifier] forIndexPath:indexPath];
            
            self.sportCell = cell;
            
            return cell;
        }
        case MSSetAGameSectionTextField:
        {
            switch (indexPath.row) {
                case MSSetAGameTextFieldTypeDay:
                {
                    MSTextFieldPickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MSTextFieldPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"Day";
                    self.dayTextField = cell.textField;
                    
                    return cell;
                }
                    
                case MSSetAGameTextFieldTypeTime:
                {
                    MSTextFieldPickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MSTextFieldPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"Time";
                    self.timeTextField = cell.textField;
                    
                    return cell;
                }
                    
                case MSSetAGameTextFieldTypeRepeat:
                {
                    MSTextFieldPickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MSTextFieldPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"Repeat";
                    self.repeatTextField = cell.textField;
                    
                    return cell;
                }
                    
                case MSSetAGameTextFieldTypeLocation:
                {
                    MSLocationPickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MSLocationPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"Location";
                    self.venueCell = cell;
                    [cell initializeLocation];
                    
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

- (CGFloat)heightForExtensiveCellAtIndexPath:(NSIndexPath *)indexPath
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

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.dayTextField])
    {
        [self extendCellAtIndexPath:[NSIndexPath indexPathForRow:MSSetAGameTextFieldTypeDay inSection:MSSetAGameSectionTextField]];
    }
    else if ([textField isEqual:self.timeTextField])
    {
        [self extendCellAtIndexPath:[NSIndexPath indexPathForRow:MSSetAGameTextFieldTypeTime inSection:MSSetAGameSectionTextField]];
    }
    else if ([textField isEqual:self.repeatTextField])
    {
        [self extendCellAtIndexPath:[NSIndexPath indexPathForRow:MSSetAGameTextFieldTypeRepeat inSection:MSSetAGameSectionTextField]];
    }
    else
    {
        
    }
    
    self.activeTextField = (MSTextField *)textField;
    return NO;
}

- (void)setActiveTextField:(MSTextField *)activeTextField
{
    [_activeTextField setFocused:NO];
    _activeTextField = [activeTextField isEqual:_activeTextField] ? Nil : activeTextField;
    [_activeTextField setFocused:YES];
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
