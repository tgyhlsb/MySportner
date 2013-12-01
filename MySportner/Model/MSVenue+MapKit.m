//
//  MSVenue+MapKit.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSVenue+MapKit.h"

@implementation MSVenue (MapKit)

#pragma mark MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.location.x, self.location.y);
}

- (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return self.address;
}

@end
