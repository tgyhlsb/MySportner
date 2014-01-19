//
//  MSFontFactory.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 01/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSFontFactory.h"

@implementation MSFontFactory

+ (UIFont *)fontForFormTextField
{
    return [UIFont fontWithName:@"ProximaNova-Regular" size:13.5];
}

+ (UIFont *)fontForCommentLabel
{
    return [UIFont fontWithName:@"ProximaNova-Regular" size:11.5];
}

+ (UIFont *)fontForNavigationTitle
{
    return [UIFont fontWithName:@"Montserrat-Regular" size:14];
}

+ (UIFont *)fontForButton
{
    return [UIFont fontWithName:@"Montserrat-Regular" size:17];
}

+ (UIFont *)fontForButtonLight
{
    return [UIFont fontWithName:@"Montserrat-Regular" size:15];
}

+ (UIFont *)fontForCellSportTitle
{
    return [UIFont fontWithName:@"ProximaNova-SemiBold" size:9.5];
}

+ (UIFont *)fontForTitle
{
    return [UIFont fontWithName:@"ProximaNova-SemiBold" size:12];
}

+ (UIFont *)fontForCellInfo
{
    return [UIFont fontWithName:@"ProximaNova-SemiBold" size:9.5];
}

+ (UIFont *)fontForCellAcivityTitle
{
    return [UIFont fontWithName:@"ProximaNova-SemiBold" size:15];
}

+ (UIFont *)fontForDrawerMenu
{
    return [UIFont fontWithName:@"ProximaNova-Semibold" size:15];
}

+ (UIFont *)fontForGameProfileSportTitle
{
    return [UIFont fontWithName:@"ProximaNova-Semibold" size:20];
}

+ (UIFont *)fontForGameProfileSportInfo
{
    return [UIFont fontWithName:@"ProximaNova-SemiBold" size:12.5];
}

@end
