//
//  MSWindow.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 12/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSWindow.h"

@implementation MSWindow

- (void)sendEvent:(UIEvent *)event
{
    UITouch *touch = [[event.allTouches allObjects] firstObject];
    NSLog(@"%@ - %@", [touch.view.superview class], touch.view);
    [super sendEvent:event];
}

@end
