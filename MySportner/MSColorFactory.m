//
//  MSColorFactory.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSColorFactory.h"

@implementation MSColorFactory

+ (UIColor *)mainColor
{
    return [UIColor colorWithRed:0.40 green:0.78 blue:0.74 alpha:1.0];
}

+ (UIColor *)facebookColorLight
{
    return [UIColor colorWithRed:0.23 green:0.35 blue:0.61 alpha:1.0];
}

+ (UIColor *)facebookColorDark
{
    return [UIColor colorWithRed:0.17 green:0.27 blue:0.48 alpha:1.0];
}

+ (UIColor *)whiteLight
{
    return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
}

+ (UIColor *)whiteDark
{
    return [UIColor colorWithRed:0.78 green:0.91 blue:0.91 alpha:1.0];
}

+ (UIColor *)redLight
{
    return [UIColor colorWithRed:0.90 green:0.41 blue:0.35 alpha:1.0];
}

+ (UIColor *)redDark
{
    return [UIColor colorWithRed:0.78f green:0.33f blue:0.27f alpha:1.00f];
}

@end
