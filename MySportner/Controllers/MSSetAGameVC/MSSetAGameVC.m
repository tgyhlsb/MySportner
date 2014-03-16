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
#import "MSVenuePickerCell.h"
#import "MSActivity.h"
#import "MBProgressHUD.h"
#import "MSActivityVC.h"
#import "MSButtonCell.h"
#import "MSLocationPickerVC.h"
#import "TKAlertCenter.h"
#import "MSRangeCell.h"
#import "MSPickLocalisationVC.h"
#import "MSActivitiesVC.h"

#define NIB_NAME @"MSSetAGameVC"

#define REPEAT_VALUES @[@"Never", @"Weekly", @"Monthly"]

typedef NS_ENUM(int, MSSetAGameSection) {
    MSSetAGameSectionPickSport,
    MSSetAGameSectionTextField,
    MSSetAGameSectionSizePicker
};

typedef NS_ENUM(int, MSSetAGameTextFieldType) {
    MSSetAGameTextFieldTypeDay,
    MSSetAGameTextFieldTypeTime,
    MSSetAGameTextFieldTypeRepeat,
    MSSetAGameTextFieldTypeLocation,
    MSSetAGameTextFieldTypeRangePlayers,
    MSSetAGameTextFieldTypeButton
};

@interface MSSetAGameVC () <UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MSPickLocalisationVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITextField *dayTextField;
@property (strong, nonatomic) IBOutlet UITextField *timeTextField;
@property (strong, nonatomic) IBOutlet UITextField *repeatTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet MSVenuePickerCell *venueCell;
@property (strong, nonatomic) IBOutlet MSPickSportCell *sportCell;
@property (strong, nonatomic) MSRangeCell *rangeCell;

@property (strong, nonatomic) UIDatePicker *dayPicker;
@property (strong, nonatomic) UIDatePicker *timePicker;
@property (strong, nonatomic) UIPickerView *repeatPicker;

@property (strong, nonatomic) MBProgressHUD *loadingView;

@property (weak, nonatomic) MSTextField *activeTextField;
@property (nonatomic) NSInteger repeatMode;

@property (strong, nonatomic) MSActivity *activity;

@property (strong, nonatomic) NSString *location;

@end

@implementation MSSetAGameVC

- (BOOL)shouldCancelTouch:(UITouch *)touch
{
    CGPoint tapLocation = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[MSRangeCell class]] || [cell isKindOfClass:[MSPickSportCell class]]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	
    [MSVenuePickerCell registerToTableView:self.tableView];
    [MSPickSportCell registerToTableView:self.tableView];
    [MSTextFieldPickerCell registerToTableView:self.tableView];
    [MSButtonCell registerToTableView:self.tableView];
    [MSRangeCell registerToTableView:self.tableView];
    
    [self registerForKeyboardNotifications];
    
    self.navigationItem.title = @"SET A GAME";
    
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initializePickers];
    [self.rangeCell updateSliderLabels];
}

- (void)initializePickers
{
    _repeatMode = 0;
//    [self dayPickerValueDidChange];
//    [self timePickerValueDidChange];
}

- (void)setRepeatMode:(NSInteger)repeatMode
{
    _repeatMode = repeatMode;
    
    self.repeatTextField.text = [REPEAT_VALUES objectAtIndex:self.repeatMode];
}

- (MSActivity *)activity
{
    if (!_activity) _activity = [[MSActivity alloc] init];
    return _activity;
}

+ (MSSetAGameVC *)newController
{
    MSSetAGameVC *setAGameVC = [[MSSetAGameVC alloc] initWithNibName:NIB_NAME bundle:nil];
    setAGameVC.hasDirectAccessToDrawer = YES;
    return setAGameVC;
}

- (void)createActivity
{
    BOOL fieldsOK = YES;
    if (!self.sportCell.sport) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Pick a sport"];
        fieldsOK = NO;
    } else if (![self.dayTextField.text length]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Pick a day"];
        fieldsOK = NO;
    } else if (![self.timeTextField.text length]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Pick a time"];
        fieldsOK = NO;
    } else if (![self.locationTextField.text length]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Pick a place"];
        fieldsOK = NO;
    }
    
    if (fieldsOK) {
        MSSport *sport = self.sportCell.sport;
        self.activity.sport = sport;
        self.activity.level = [[MSSportner currentSportner] levelForSport:sport];
        self.activity.place = self.locationTextField.text;
        self.activity.owner = [MSSportner currentSportner];
        [[self.activity participantRelation] addObject:[MSSportner currentSportner]];
        
        [self showLoadingViewInView:self.navigationController.view];
        [self.activity saveInBackgroundWithTarget:self selector:@selector(handleActivityCreation:error:)];
    }
}

- (void)handleActivityCreation:(BOOL)succeed error:(NSError *)error
{
    [self hideLoadingView];
    if (!error) {
        [self presentSimilarAcitivties];
    } else {
        NSLog(@"%@", error);
    }
}

- (void)presentSimilarAcitivties
{
    MSActivitiesVC *destination = [MSActivitiesVC newController];
    destination.referenceActivity = self.activity;
    destination.hasDirectAccessToDrawer = NO;
    
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)activityCreationDidSucceed
{
    MSActivityVC *destinationVC = [MSActivityVC newController];
    destinationVC.hasDirectAccessToDrawer = YES;
    destinationVC.activity = self.activity;
    
    [self.navigationController setViewControllers:@[destinationVC] animated:YES];
}

#pragma mark - MSPickLocalisationVCDelegate

- (void)didPickLocalisation:(CLLocationCoordinate2D)localisation withRadius:(CGFloat)radius placeInfo:(NSDictionary *)placeInfo
{
    self.locationTextField.text = [placeInfo objectForKey:@"locality"];
}

#pragma mark DatePickers Handlers

- (void)updateAcitivityDate
{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit|NSHourCalendarUnit|NSSecondCalendarUnit) fromDate:self.dayPicker.date];
//    NSDateComponents *timeComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit|NSHourCalendarUnit|NSSecondCalendarUnit) fromDate:self.timePicker.date];
//    
//    [dayComponents setHour:timeComponents.hour];
//    [dayComponents setMinute:timeComponents.minute];
//    [dayComponents setSecond:0];
//    
//    self.activity.date = [calendar dateFromComponents:dayComponents];
    self.activity.date = self.dayPicker.date;
}

- (void)dayPickerValueDidChange
{
    [self updateAcitivityDate];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy    hh:mm"];
    self.dayTextField.text = [dateFormat stringFromDate:self.activity.date];
    
    if ([self.dayPicker.date timeIntervalSinceDate:self.timePicker.date] > 0 || ![self.timeTextField.text length]) {
        self.timePicker.date = self.activity.date;
        [self timePickerValueDidChange];
    }
}

- (void)dayPickerDidTap
{
    [self dayPickerValueDidChange];
    // close it
    [self textFieldShouldBeginEditing:self.dayTextField];
}

- (void)timePickerValueDidChange
{
    [self updateAcitivityDate];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy    hh:mm"];
    self.timeTextField.text = [dateFormat stringFromDate:self.timePicker.date];
}

- (void)timePickerDidTap
{
    [self timePickerValueDidChange];
    // close it
    [self textFieldShouldBeginEditing:self.timeTextField];
}

- (void)repeatPickerDidTap
{
    self.repeatMode = [self.repeatPicker selectedRowInComponent:0];
    // close it
    [self textFieldShouldBeginEditing:self.repeatTextField];
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
        _dayPicker.datePickerMode = UIDatePickerModeDateAndTime;
        _dayPicker.minuteInterval = 15;
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
        _timePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _timePicker.minuteInterval = 15;
        _timePicker.minimumDate = self.dayPicker.date;
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
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(repeatPickerDidTap)];
        [_repeatPicker addGestureRecognizer:tapGesture];
    }
    return _repeatPicker;
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
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
            return MSSetAGameTextFieldTypeButton + 1;
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
                    cell.textField.placeholder = @"Start date";
                    self.dayTextField = cell.textField;
                    cell.type = MSTextFieldTypeDate;
                    
                    return cell;
                }
                    
                case MSSetAGameTextFieldTypeTime:
                {
                    MSTextFieldPickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MSTextFieldPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"End date";
                    self.timeTextField = cell.textField;
                    
                    return cell;
                }
                    
                case MSSetAGameTextFieldTypeRepeat:
                {
                    MSTextFieldPickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MSTextFieldPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"Repeat";
                    self.repeatTextField = cell.textField;
                    cell.type = MSTextFieldTypeRepeat;
                    
                    return cell;
                }
                    
                case MSSetAGameTextFieldTypeLocation:
                {
//                    MSVenuePickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MSVenuePickerCell reusableIdentifier] forIndexPath:indexPath];
//                    
//                    [cell initializeWithViewcontroller:self];
//                    cell.textField.placeholder = @"Location";
//                    self.venueCell = cell;
//                    [cell initializeLocation];
                    
                    
                    MSTextFieldPickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MSTextFieldPickerCell reusableIdentifier] forIndexPath:indexPath];
                    
                    [cell initializeWithViewcontroller:self];
                    cell.textField.placeholder = @"Location";
                    self.locationTextField = cell.textField;
                    cell.type = MSTextFieldTypeLocation;
                    
                    return cell;
                }
                
                case MSSetAGameTextFieldTypeRangePlayers:
                {
                    self.rangeCell = [self.tableView dequeueReusableCellWithIdentifier:[MSRangeCell reusableIdentifier] forIndexPath:indexPath];
                    
                    self.rangeCell.maximumValue = 15.0;
                    self.rangeCell.minimumValue = 1.0;
                    self.rangeCell.lowerValue = 1.0;
                    self.rangeCell.upperValue = 15.0;
                    self.rangeCell.stepValue = 1.0;
                    
                    return self.rangeCell;
                }
                    
                case MSSetAGameTextFieldTypeButton:
                {
                    MSButtonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MSButtonCell reusableIdentifier] forIndexPath:indexPath];
                    [cell.button addTarget:self action:@selector(createActivity) forControlEvents:UIControlEventTouchUpInside];
                    [cell.button setTitle:@"DONE" forState:UIControlStateNormal];
                    
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
            if (indexPath.row == MSSetAGameTextFieldTypeRangePlayers) {
                return [MSRangeCell height];
            } else {
                return [MSTextFieldPickerCell height];
            }
            
        default:
            return 44;
    }
}

#pragma mark MSLocationPickerDelegate

- (void)didSelectLocation:(NSString *)location
{
    self.locationTextField.text = location;
    self.activity.place = location;
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
    else if ([textField isEqual:self.locationTextField])
    {
        MSPickLocalisationVC *destinationVC = [MSPickLocalisationVC newControler];
        destinationVC.delegate = self;
        [self.navigationController pushViewController:destinationVC animated:YES];
        self.activeTextField = nil;
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
