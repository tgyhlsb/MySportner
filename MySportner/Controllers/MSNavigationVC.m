//
//  MSNavigationVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 22/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSNavigationVC.h"
#import "MSNavigationBar.h"
#import "MSColorFactory.h"

@interface MSNavigationVC ()

@end

@implementation MSNavigationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setAppearance];
}

- (void)setAppearance
{
    UIColor *navBarColor = [MSColorFactory navigationColorDark];
    self.navigationBar.backgroundColor = navBarColor;
    self.navigationBar.barTintColor = navBarColor;
    
    NSShadow *titleShadow = [[NSShadow alloc] init];
    titleShadow.shadowColor = [UIColor grayColor];
    titleShadow.shadowOffset = CGSizeMake(0.5, 0.5);
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[MSColorFactory whiteLight],
                                                NSShadowAttributeName:titleShadow};
    
    [self.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    self.navigationBar.tintColor = [MSColorFactory whiteLight];
}

@end
