//
//  MSCommentsVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSCommentsVC.h"
#import "MSComment.h"

#define NIB_NAME @"MSCommentsVC"

@interface MSCommentsVC ()

@end

@implementation MSCommentsVC

+ (instancetype)newController
{
    MSCommentsVC *controller = [[MSCommentsVC alloc] initWithNibName:NIB_NAME bundle:nil];
    controller.hasDirectAccessToDrawer = NO;
    return controller;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - Handlers

- (IBAction)testButtonHandler:(id)sender
{
    MSComment *comment = [[MSComment alloc] init];
    
    comment.content = @"Ceci est un commentaire";
    comment.author = [MSSportner currentSportner];
    
    [self.activity addComment:comment withBlock:^(BOOL succeeded, NSError *error) {
        
        NSLog(@"Commentaire envoyé");
        
    }];
}


@end
