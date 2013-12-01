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

+ (UIColor *)mainColorDark
{
    return [UIColor colorWithRed:0.05f green:0.66f blue:0.44f alpha:1.00f];
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

+ (UIColor *)navigationColorLight
{
    return [UIColor colorWithRed:0.33f green:0.78f blue:0.73f alpha:1.00f];
}

+ (UIColor *)navigationColorDark
{
    return [UIColor colorWithRed:0.34f green:0.73f blue:0.69f alpha:1.00f];
}

+ (UIColor *)backgroundColorGrayLight
{
    return [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
}

+ (UIColor *)gray
{
    return [UIColor colorWithRed:0.49f green:0.53f blue:0.55f alpha:1.00f];
}

@end
