//
//  MSPinView.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 27/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MSPinView : MKAnnotationView

@property (nonatomic) CGFloat distance;

- (void)setSize:(CGSize)size;

@end
