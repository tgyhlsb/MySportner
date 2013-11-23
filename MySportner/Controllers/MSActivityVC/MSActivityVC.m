//
//  MSActivityVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSActivityVC.h"

#define NIB_NAME @"MSActivityVC"

@interface MSActivityVC ()

@end

@implementation MSActivityVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

+ (MSActivityVC *)newController
{
    return [[MSActivityVC alloc] initWithNibName:NIB_NAME bundle:nil];
}

@end
