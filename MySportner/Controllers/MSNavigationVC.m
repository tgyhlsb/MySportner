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
#import "MSFontFactory.h"

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
    
    NSShadow *titleShadow = [[NSShadow alloc] init];
    titleShadow.shadowColor = [MSColorFactory mainColorShadow];
    titleShadow.shadowOffset = CGSizeMake(0.1, 0.9);
    NSDictionary *navbarTitleTextAttributes = @{
                                                NSForegroundColorAttributeName:[MSColorFactory whiteLight],
                                                NSShadowAttributeName:titleShadow,
                                                NSFontAttributeName:[MSFontFactory fontForNavigationTitle]};
    
    [self.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    [self.navigationBar setTintColor:[MSColorFactory whiteLight]];
    [self.navigationBar setBarTintColor:[MSColorFactory mainColor]];

}

@end
