//
//  MSProfileVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 22/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSProfileVC.h"

#define NIB_NAME @"MSProfileVC"

@interface MSProfileVC ()

@end

@implementation MSProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark Class methods

+ (MSProfileVC *)newController
{
    return [[MSProfileVC alloc] initWithNibName:NIB_NAME bundle:nil];
}

@end
