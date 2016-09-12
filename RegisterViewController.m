//
//  RegisterViewController.m
//  loginapp
//
//  Created by Mihaela Pacalau on 9/2/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    
    UIDatePicker* datePicker;
    
    UIPickerView* genderPickerView;
    NSMutableArray* genderPickerViewData;
}

@end

@implementation RegisterViewController

- (void)createPickerToolbarAction {
    UIToolbar* pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [pickerToolbar setTintColor:[UIColor grayColor]];
    
    UIBarButtonItem* doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction:)];
    UIBarButtonItem* spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:spaceButtonItem, doneButtonItem, nil]];
    
    [self.genderTextField setInputAccessoryView:pickerToolbar];
    [self.dateOfBirthTextField setInputAccessoryView:pickerToolbar];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    genderPickerView = [[UIPickerView alloc] init];
    genderPickerView.delegate = self;
    genderPickerViewData = [[NSMutableArray alloc] initWithObjects:@"Male", @"Female", @"It's complicated", nil];
//    self.genderTextField.inputView = genderPickerView;
    [self.genderTextField setInputView:genderPickerView];
    
    
    
    
    self.dateOfBirthTextField.delegate = self;
    datePicker = [[UIDatePicker alloc] init];
//    [datePicker setDate:[NSDate date]];
    
    NSString* minDateString = @"01-Jan-1966";
//    NSString* maxDateString = @"31-Dec-2000";
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    
    NSDate* theMinimumDate = [dateFormatter dateFromString:minDateString];
//    NSDate* theMaximumDate = [dateFormatter dateFromString:maxDateString];
    
    [datePicker setMinimumDate:theMinimumDate];
    [datePicker setMaximumDate:[NSDate date]];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    [datePicker addTarget:self action:@selector(updateTextFieldAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.dateOfBirthTextField setInputView:datePicker];
    
    [self createPickerToolbarAction];
    
    
    
}


- (void)updateTextFieldAction:(id) sender {

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    NSString* formattedString = [dateFormatter stringFromDate:datePicker.date];
    
    self.dateOfBirthTextField.text = formattedString;
}


- (void)doneButtonAction:(id) sender {
    
    [self.genderTextField resignFirstResponder];
    [self.dateOfBirthTextField resignFirstResponder];
    
}


#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return genderPickerViewData.count;
}

#pragma mark - UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [genderPickerViewData objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.genderTextField.text = genderPickerViewData[row];
}






///////////////////////////////////////////////////////////
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [self.view setFrame:CGRectMake(0,-110,420,520)]; //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,420,670)];
}
///////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
