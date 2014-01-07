//
//  MSSport.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 07/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SAMPLE_SPORTS @[@"foot", @"basketball", @"football", @"tennis", @"swimming", @"cycle", @"gym", @"rugby"]

@interface MSSport : NSObject

+ (NSInteger)keyForSportName:(NSString *)sportName;
+ (NSString *)sportNameForKey:(NSInteger)sportKey;

@end
