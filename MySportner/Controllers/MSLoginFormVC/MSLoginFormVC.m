//
//  MSLoginFormVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 26/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSLoginFormVC.h"

#define NIB_NAME @"MSLoginFormVC"

@interface MSLoginFormVC ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *forgotPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@end

@implementation MSLoginFormVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Access to form sheet controller
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = YES;
}

+ (MSLoginFormVC *)newController
{
    return [[MSLoginFormVC alloc] initWithNibName:NIB_NAME bundle:Nil];
}

- (IBAction)connectButtonPress:(UIButton *)sender
{
    [self dismissAnimated:YES completionHandler:nil];
}

@end
