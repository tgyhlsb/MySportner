//
//  MSSport.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 07/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSSport.h"

@implementation MSSport

+ (NSInteger)keyForSportName:(NSString *)sportName
{
    NSInteger key = [SAMPLE_SPORTS indexOfObject:sportName.lowercaseString];
    return key;
}

+ (NSString *)sportNameForKey:(NSInteger)sportKey
{
    NSString *sportName = [SAMPLE_SPORTS objectAtIndex:sportKey];
    return sportName.uppercaseString;
}

@end
