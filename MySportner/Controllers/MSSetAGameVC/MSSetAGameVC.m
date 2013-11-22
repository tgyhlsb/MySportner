//
//  MSSetAGameVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSSetAGameVC.h"

#define NIB_NAME @"MSSetAGameVC"

@interface MSSetAGameVC ()

@end

@implementation MSSetAGameVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

+ (MSSetAGameVC *)newController
{
    return [[MSSetAGameVC alloc] initWithNibName:NIB_NAME bundle:nil];
}

@end
