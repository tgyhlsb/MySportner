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
    return [UIFont fontWithName:@"ProximaNova-Semibold" size:14];
}

+ (UIFont *)fontForButton
{
    return [UIFont fontWithName:@"ProximaNova-Semibold" size:17];
}


@end
